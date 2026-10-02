function result = dispatch_inverse(bundle)
%DISPATCH_INVERSE  Run one cluster inverse job from a pre-built bundle struct.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   result = dispatch_inverse(bundle)
%
%   bundle must contain method_id, method_info (from inverse_method_registry),
%   measurements (F), lead field (L), procFile, source geometry, GPU flags, and
%   common_inverse_parameters / method_params for class-based inverters. Legacy
%   methods additionally require bundle.legacy_zef.
%
%   Class path: builds the inverter object, runs utilities.inverse.run_frame_loop,
%   optional smoother/terminateComputation, optional reconstruction normalization,
%   then zef_postProcessInverseClassObj. Legacy path: feval on legacy_function,
%   using with_zef_in_base when the legacy routine reads base workspace zef.
%
%   Returns result with fields method_id, z_inverse, reconstruction, and
%   reconstruction_information. Opens a waitbar during class-based inversion.

arguments
    bundle (1,1) struct
end

method_info = bundle.method_info;
result = struct( ...
    "method_id", bundle.method_id, ...
    "z_inverse", [], ...
    "reconstruction", [], ...
    "reconstruction_information", struct ...
);

if method_info.execution_kind == "class"
    result = i_dispatch_class(bundle, method_info, result);
elseif method_info.execution_kind == "legacy"
    result = i_dispatch_legacy(bundle, method_info, result);
else
    error("utilities:cluster:UnsupportedExecutionKind", ...
        "Unsupported execution kind '%s'.", method_info.execution_kind);
end

end

function result = i_dispatch_class(bundle, method_info, result)
MethodClassObj = i_build_class_object(method_info.class_name, bundle);

zef_shim = struct;
zef_shim.measurements = bundle.F;
zef_shim.inv_data_mode = 'raw';
if isfield(bundle, "F_initialize") && ~isempty(bundle.F_initialize)
    zef_shim.inverse_initialization_measurements = bundle.F_initialize;
end
zef_shim.use_gpu = bundle.use_gpu;
zef_shim.gpu_count = bundle.gpu_count;
zef_shim.normalize_data = bundle.normalize_data;
zef_shim.inv_time_interval_averaging = false;

waitbar_title = char("Cluster inverse: " + bundle.method_id);
waitbar_handle = zef_waitbar(0, waitbar_title);
cleanup_obj = onCleanup(@() zef_close_waitbar(waitbar_handle));

[z_inverse, MethodClassObj] = utilities.inverse.run_frame_loop( ...
    zef_shim, ...
    MethodClassObj, ...
    bundle.L, ...
    bundle.procFile, ...
    bundle.source_direction_mode, ...
    bundle.source_positions, ...
    waitbar_handle, ...
    waitbar_title ...
);

% Inverters that define smoother.m today: KalmanInverter (optional RTS)
% and UKFNMMInverter (optional RTS, then required NMM/UKF). Guard on
% use_smoothing so Kalman does not enter its smoother when unused.
% UKFNMM forces use_smoothing true so this hook runs exactly once.
% Pass bundle.L so the signature matches.
should_smooth = ismethod(MethodClassObj, 'smoother') ...
    && isprop(MethodClassObj, 'use_smoothing') ...
    && MethodClassObj.use_smoothing;
if should_smooth
    use_gpu = isfield(bundle, "use_gpu") && logical(bundle.use_gpu);
    if use_gpu && isa(MethodClassObj, "inverse.KalmanInverter")
        [z_inverse, MethodClassObj] = MethodClassObj.smoother(z_inverse, bundle.L, "use_gpu", true);
    else
        [z_inverse, MethodClassObj] = MethodClassObj.smoother(z_inverse, bundle.L);
    end
end
if ismethod(MethodClassObj,'terminateComputation')
    MethodClassObj = MethodClassObj.terminateComputation;
end
if MethodClassObj.normalize_reconstruction
    z_vec = reshape(cell2mat(z_inverse).^2,3,bundle.procFile.n_interp,MethodClassObj.number_of_frames);
    z_vec = squeeze(sum(z_vec,1));
    normalization_factor = sqrt(max(z_vec,[],'all'));
    z_vec = cell2mat(z_inverse)/normalization_factor;
    z_inverse = mat2cell(z_vec,size(z_vec,1),ones(1,MethodClassObj.number_of_frames));
end

result.z_inverse = z_inverse;
result.reconstruction = zef_postProcessInverseClassObj(z_inverse, bundle.procFile);
result.reconstruction_information = i_collect_method_info(MethodClassObj);

clear cleanup_obj;
end


function result = i_dispatch_legacy(bundle, method_info, result)
if ~isfield(bundle, "legacy_zef")
    error("utilities:cluster:MissingLegacyZef", ...
        "Legacy dispatch requires bundle.legacy_zef.");
end

zef_legacy = bundle.legacy_zef;
func_name = method_info.legacy_function;

switch func_name
    case "zef_find_mne_reconstruction"
        [z, info] = feval(func_name, zef_legacy);
    case {"zef_KF", "zef_ias_iteration", "zef_ramus_iteration", ...
            "zef_dipoleScan", "zef_sl1_iteration", "zef_mcmc"}
        [z, info] = feval(func_name, zef_legacy);
    case "zef_beamformer"
        [z, ~, info] = feval(func_name, zef_legacy);
    case {"zef_CSM_iteration", "zef_relax_iteration"}
        [z, info] = utilities.cluster.with_zef_in_base(zef_legacy, @() feval(func_name));
    case "SESAME_inversion"
        z = utilities.cluster.with_zef_in_base(zef_legacy, @() feval(func_name, []));
        info = struct("tag","SESAME");
    case "MUSIC_iteration"
        [z, ~] = utilities.cluster.with_zef_in_base(zef_legacy, @() feval(func_name));
        info = struct("tag","MUSIC");
    case "RAP_MUSIC_iteration"
        [z, ~, info] = utilities.cluster.with_zef_in_base(zef_legacy, @() feval(func_name));
    case "exp_iteration"
        [z, info] = feval(func_name, zef_legacy);
    otherwise
        error("utilities:cluster:UnsupportedLegacyFunction", ...
            "Legacy function '%s' is not supported in dispatcher.", func_name);
end

result.reconstruction = z;
result.z_inverse = z;
result.reconstruction_information = info;
end

function MethodClassObj = i_build_class_object(class_name, bundle)
MethodClassObj = feval(class_name);

common_fields = fieldnames(bundle.common_inverse_parameters);
for i = 1:numel(common_fields)
    f = common_fields{i};
    if isprop(MethodClassObj, f)
        MethodClassObj.(f) = bundle.common_inverse_parameters.(f);
    end
end

if isfield(bundle, "method_params")
    method_fields = fieldnames(bundle.method_params);
    for i = 1:numel(method_fields)
        f = method_fields{i};
        if isprop(MethodClassObj, f)
            MethodClassObj.(f) = bundle.method_params.(f);
        end
    end
end
end

function info = i_collect_method_info(MethodClassObj)
info = struct;
info.tag = erase(class(MethodClassObj),["inverse","Inverter","."]);
props = properties(MethodClassObj);
for n = 1:length(props)
    prop_name = props{n};
    value = MethodClassObj.(prop_name);
    if max(size(value)) < 2 && ~iscell(value)
        info.(prop_name) = value;
    end
end
end
