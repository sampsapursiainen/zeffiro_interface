function [payload, report] = convert(source)
%CONVERT  DUNEuro MATLAB/FieldTrip project → native Zeffiro scientific fields.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Pipeline: identify → validate → convert coordinates/indexing/units →
%   mesh/compartments → sensors → sources → lead field → metadata →
%   consistency checks. Does not recompute a lead field or remesh a valid
%   tetrahedral grid. Hexahedra are split with zef_hexa_to_tetra because
%   Zeffiro's runtime mesh is tetrahedral.
%
%   Stage implementations live in this package's private/ folder. The
%   public entry point and field payload are unchanged.
%
%   Lead field: DUNEuro / FieldTrip store EEG L as n_sensors × 3*n_sources
%   with columns [x1 y1 z1 x2 y2 z2 ...] (leadfield_duneuro.m). 3-D dumps
%   such as (n_sensors, n_sources, 3) or (3, n_sources, n_sensors) are
%   permuted onto that layout using the electrode count as the sensor axis.
%   When n_sources is also 3, (n_sensors, 3, 3) is taken as orientation-last
%   (the usual MATLAB dump of per-source xyz). This matches raw zef.L
%   consumed by zef_processLeadfields (interleaved xyz) and, after that
%   function's block reorder plus zef_inverse_extract_bundle,
%   inverse.ELORETAInverter's reshape(L, n_sensors, 3, n_sources).
%
%   Electrodes: duneuro-matlab / FieldTrip pass 3×n_electrodes into
%   set_electrodes (columns are sensors). Zeffiro stores N×3 millimetres.
%
%   Units: DUNEuro does not convert mesh units. A unit field is honoured
%   when present. Otherwise a head-sized bounding box maps millimetres vs
%   metres (diagonal in [50, 500] → mm; [0.05, 0.5] → m, ×1000). That scale
%   is applied to coordinates only. Lead-field numbers are copied unchanged.
%   Zeffiro's own EEG assembly divides millimetre nodes by 1000 before the
%   FEM, so zef.L from zef_lead_field_matrix is volts per ampere-metre.
%   A DUNEuro solve whose geometry and unit dipole moment live in
%   millimetres is smaller by about 1e6, and it still will not match a
%   native lead field unless the mesh, conductivity, electrodes, and
%   source grid are the same. Do not multiply L to chase a Frobenius norm.
%
%   Indexing: DUNE/DUNEuro elements may be 0-based; they are shifted to
%   MATLAB 1-based when min(elements)==0. Tissue IDs are remapped onto
%   consecutive Zeffiro compartment indices 1:n (original IDs kept in
%   duneuro_import.original_tissue_ids and default compartment names).
%
%   Hexahedra: split with zef_hexa_to_tetra in DUNE/ndgrid corner order.
%   If that split is degenerate, VTK order (bottom 1 2 4 3) is retried.
%
%   [payload, report] = convert(path_or_struct)
%
%   See also import_duneuro_project, load_raw, is_duneuro_project.

    if nargin < 1 || isempty(source)
        error('duneuro2zef:EmptyProject', 'A DUNEuro file, folder, or struct is required.');
    end

    raw = utilities.duneuro2zef.load_raw(source);
    report = local_empty_report();
    if isfield(raw, 'duneuro_source_path')
        report.source_path = raw.duneuro_source_path;
    elseif ischar(source) || isstring(source)
        report.source_path = char(string(source));
    else
        report.source_path = '';
    end
    omitted = {};
    if isfield(raw, 'duneuro_omitted_fields')
        omitted = raw.duneuro_omitted_fields;
    end
    for i = 1:numel(omitted)
        report.omitted{end+1} = sprintf( ...
            '%s (DUNEuro transfer matrix; FEM internal, not a Zeffiro runtime field)', ...
            omitted{i});
    end

    payload = local_empty_payload();
    payload.duneuro_import = struct( ...
        'source_path', report.source_path, ...
        'format', 'duneuro_matlab', ...
        'length_unit', 'mm', ...
        'lead_field_layout', '', ...
        'imported', {{}}, ...
        'omitted', {report.omitted}, ...
        'warnings', {{}});

    [electrodes, electrode_aux] = find_electrodes(raw);
    n_electrodes = size(electrodes, 1);
    if ~isempty(electrode_aux)
        payload.duneuro_import.electrode_aux = electrode_aux;
        report.omitted{end+1} = ['electrode extra columns (CEM radii/impedance; ' ...
            'Zeffiro sensors are PEM N×3). Stored on duneuro_import.electrode_aux'];
        report.warnings{end+1} = ['Electrode array had extra columns beyond xyz. ' ...
            'Positions use the first three columns (PEM).'];
    end

    eeg_lf = find_leadfield(raw, 'eeg');
    meg_lf = find_leadfield(raw, 'meg');
    modality = 'EEG';
    raw_lf = eeg_lf;
    if isempty(raw_lf) && ~isempty(meg_lf)
        raw_lf = meg_lf;
        modality = 'MEG';
    elseif ~isempty(eeg_lf) && ~isempty(meg_lf)
        report.warnings{end+1} = ['Both EEG and MEG lead fields are present. ' ...
            'zef.L receives the EEG matrix; the MEG matrix is not stacked onto it.'];
        report.omitted{end+1} = 'megL (second modality; Zeffiro holds one zef.L)';
    end

    if ~isempty(raw_lf)
        [payload.L, lf_info] = convert_leadfield(raw_lf, n_electrodes, modality);
        n_electrodes = lf_info.n_sensors;
        payload.n_sources = lf_info.n_sources;
        payload.lead_field_type = lf_info.lead_field_type;
        payload.imaging_method = lf_info.imaging_method;
        payload.duneuro_import.lead_field_layout = lf_info.layout;
        report.imported{end+1} = 'L';
    end

    if ~isempty(electrodes)
        [electrodes, report] = apply_length_unit(electrodes, raw, report);
        payload.sensors = electrodes;
        payload.s_points = electrodes;
        payload.s_on = 1;
        payload.s_visible = 1;
        payload.s_imaging_method_name = modality;
        payload.s_name = [modality ' electrodes'];
        payload.s_name_list = find_electrode_labels(raw, size(electrodes, 1));
        payload.sensor_tags = {'s'};
        payload.current_sensors = 's';
        payload.imaging_method = imaging_method_for(modality);
        report.imported{end+1} = 'sensors';
        if ~isempty(payload.L) && size(payload.L, 1) ~= size(electrodes, 1)
            error('duneuro2zef:SensorLeadFieldMismatch', ...
                'Lead field has %d sensor rows but %d electrode positions.', ...
                size(payload.L, 1), size(electrodes, 1));
        end
    elseif ~isempty(payload.L)
        report.warnings{end+1} = 'Lead field imported without electrode coordinates.';
    end

    [nodes, tetra, domain_labels, hex_converted, original_ids] = convert_mesh(raw);
    if hex_converted
        report.warnings{end+1} = ['Hexahedral DUNEuro elements were split into tetrahedra ' ...
            'with zef_hexa_to_tetra (Zeffiro volume meshes are tetrahedral).'];
    end
    if ~isempty(nodes)
        [nodes, report] = apply_length_unit(nodes, raw, report);
        payload.nodes = nodes;
        payload.tetra = tetra;
        payload.domain_labels = domain_labels;
        payload.duneuro_import.original_tissue_ids = original_ids;
        report.imported{end+1} = 'mesh';
        [payload, report] = fill_compartments(payload, raw, original_ids, report);
    else
        payload.nodes = [];
        payload.tetra = [];
        payload.domain_labels = [];
        payload.sigma = [];
        payload.brain_ind = [];
        payload.active_compartment_ind = [];
    end

    [source_positions, source_directions, source_model] = convert_sources(raw);
    if ~isempty(source_positions)
        [source_positions, report] = apply_length_unit(source_positions, raw, report);
        payload.source_positions = source_positions;
        report.imported{end+1} = 'source_positions';
        if ~isempty(payload.L) && size(payload.L, 2) == 3 * size(source_positions, 1)
            payload.n_sources = size(source_positions, 1);
        elseif ~isempty(payload.L) && size(payload.L, 2) ~= 3 * size(source_positions, 1) ...
                && size(payload.L, 2) ~= size(source_positions, 1)
            error('duneuro2zef:InvalidLeadField', ...
                'Lead field has %d columns but %d source positions (expected 3N or N).', ...
                size(payload.L, 2), size(source_positions, 1));
        end
    end
    if ~isempty(source_directions)
        payload.source_directions = source_directions;
        report.imported{end+1} = 'source_directions';
    end
    if ~isempty(source_model)
        payload.source_model = source_model;
        report.imported{end+1} = 'source_model';
    end

    measurements = find_measurements(raw);
    if ~isempty(measurements)
        payload.measurements = orient_measurements(measurements, n_electrodes);
        report.imported{end+1} = 'measurements';
    end

    tensors = find_tensors(raw);
    conductivity = find_conductivity(raw);
    if ~isempty(payload.tetra)
        [payload.sigma, report] = pack_sigma(payload, conductivity, tensors, hex_converted, report);
        if any(payload.sigma(:, 1) > 0)
            report.imported{end+1} = 'conductivity';
        end
        if size(payload.sigma, 2) >= 8
            report.imported{end+1} = 'anisotropy';
        end
    elseif ~isempty(tensors) || ~isempty(conductivity)
        report.omitted{end+1} = 'conductivity/tensors (no mesh to attach them to)';
    end

    if ~isempty(payload.L)
        n_src = source_count(payload);
        payload.source_interpolation_ind = {(1:n_src)', [], []};
        if mod(size(payload.L, 2), 3) == 0
            payload.source_direction_mode = 1;
        else
            payload.source_direction_mode = 3;
            report.warnings{end+1} = ['Lead-field columns are not Cartesian xyz triplets. ' ...
                'source_direction_mode=3 (one column per source).'];
        end
        if isempty(payload.source_positions)
            report.warnings{end+1} = ['Source coordinates are not in this DUNEuro file. ' ...
                'zef.L is imported; spatial inverse plotting needs source_positions.'];
        end
    end

    if ~isempty(payload.nodes) && ~isempty(payload.source_positions)
        payload = mark_source_compartments(payload);
    end

    validate_payload(payload);

    if isfield(report, 'length_unit') && ~isempty(report.length_unit)
        payload.duneuro_import.length_unit = report.length_unit;
    end
    payload.duneuro_import.imported = report.imported;
    payload.duneuro_import.omitted = report.omitted;
    payload.duneuro_import.warnings = report.warnings;
    report.payload_fields = fieldnames(payload);
end

function report = local_empty_report()
    report = struct();
    report.source_path = '';
    report.imported = {};
    report.omitted = {};
    report.warnings = {};
    report.payload_fields = {};
end

function payload = local_empty_payload()
    payload = struct();
    payload.L = [];
    payload.nodes = [];
    payload.tetra = [];
    payload.domain_labels = [];
    payload.sigma = [];
    payload.sensors = [];
    payload.s_points = [];
    payload.source_positions = [];
    payload.source_directions = [];
    payload.source_ind = [];
    payload.brain_ind = [];
    payload.active_compartment_ind = [];
    payload.sensors_attached_volume = [];
    payload.measurements = [];
    payload.reconstruction = [];
    payload.n_sources = [];
    payload.location_unit = 1;
    payload.lead_field_id = 1;
    payload.source_direction_mode = 1;
    payload.lead_field_type = 1;
    payload.imaging_method = 1;
    payload.compartment_tags = {};
    payload.sensor_tags = {};
    payload.current_version = 6.0;
end
