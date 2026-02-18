function [driverConfig, electrodeConfig] = duneuroConfig(kwargs)
%
%   [driverConfig, electrodeConfig] = duneuroConfig(kwargs)
%
% Generates a DUNEuro configuration object struct. See
%
%   https://gitlab.dune-project.org/duneuro/duneuro/-/wikis/Creation-of-a-driver#python-and-matlab-interface
%
% for the possible configuration struct values related to the driver. Also see
%
%   https://gitlab.dune-project.org/duneuro/duneuro/-/wikis/Source-model-parameters
%
% for values related to the different source model configuration options.
%
% Note that DUNEuro seems to want some floating point numbers passed as character arrays (not strings),
% even if the documentation page talks of numeric types.
%
% Arguments:
%
%   nodes
%
% A 3 x n double-matrix containing the cartesian coordinates of the nodes, where n is the number of nodes.
%
%   elements
%
% A l x e uint64-matrix, where the j-th column contains the element indices forming the j-th element. l depends on the element geometry, a tetrahedron consists of l = 4 nodes, a hexahedron of l = 8 nodes. At the moment duneuro only supports meshes consisting of a single type of element. e denotes the number of elements.
%
%   labels
%
% A 1 x e uint64-matrix. Associates to every element a label from the set {0, 1, 2, ..., p}.
%
%   tensors
%
% A 9 x p double-matrix. Associates to every label a conductivity tensor. The matrix representing the conductivity tensor is interpreted to be stored column-wise.
%
%   electrodes
%
% A 3 x k double-matrix, where k is the number of electrodes. Each column corresponds to the cartesian coordinate of an electrode. Note that duneuro at the moment only supports the point electrode model.
%
%   kwargs
%
% Other keyword arguments. See the links above for details.
%

    arguments
        kwargs.nodes (3,:) double { mustBeFinite } = []
        kwargs.elements (:,:) uint64 = []
        kwargs.labels (1,:) uint64 = []
        kwargs.tensors (9,:) double { mustBeFinite } = []
        kwargs.cfg_tensors_filename (1,:) char = []
        kwargs.cfg_grid_filename (1,:) char = []
        kwargs.electrodes (3,:) double { mustBeFinite } = []
        kwargs.dipoles (6,:) double { mustBeFinite } = []
        kwargs.cfg_element_type (1,:) char { mustBeMember( kwargs.cfg_element_type, {'tetrahedron','hexahedron'} ) } = 'tetrahedron'
        kwargs.cfg_enable_experimental (1,:) char { mustBeMember(kwargs.cfg_enable_experimental, {'True','False'} ) } = 'False'
        kwargs.cfg_meg_intorderadd (1,:) char = '5'
        kwargs.cfg_meg_type (1,:) char { mustBeMember(kwargs.cfg_meg_type, {'physical','numerical'}) } = 'physical'
        kwargs.cfg_post_process (1,:) char { mustBeMember(kwargs.cfg_post_process, {'True','False'} ) } = 'True'
        kwargs.cfg_post_process_meg (1,:) char { mustBeMember(kwargs.cfg_post_process_meg, {'True','False'} ) } = 'True'
        kwargs.cfg_solver_edge_norm_type (1,:) char { mustBeMember( kwargs.cfg_solver_edge_norm_type, {'structured','face','cell','houston', 'fundamentalcell'} ) } = 'houston'
        kwargs.cfg_solver_penalty (1,:) char = '20'
        kwargs.cfg_solver_reduction (1,:) char = '1e-16'
        kwargs.cfg_solver_scheme (1,:) char { mustBeMember(kwargs.cfg_solver_scheme, {'sipg','nipg','obb'}) } = 'sipg'
        kwargs.cfg_solver_type (1,:) char { mustBeMember(kwargs.cfg_solver_type, {'cg', 'dg', 'udg'}) } = 'cg'
        kwargs.cfg_solver_weights (1,:) char { mustBeMember(kwargs.cfg_solver_weights, {'constant','tensorOnly','annavarapu','barrau'} ) } = 'tensorOnly'
        kwargs.cfg_subtract_mean (1,:) char { mustBeMember(kwargs.cfg_subtract_mean, {'True','False'}) } = 'True'
        kwargs.cfg_type (1,:) char { mustBeMember(kwargs.cfg_type, {'fitted', 'unfitted'}) } = 'fitted'
        kwargs.cfg_verbosity (1,1) uint64 = uint64(1)
        kwargs.electrode_cfg_codims (1,1) char = '3'
        kwargs.electrode_cfg_type (1,:) char = 'closest_subentity_center'
        kwargs.loc_sub_cfg_extensions (1,:) char = 'vertex vertex'
        kwargs.loc_sub_cfg_initialization (1,:) char = 'single_element'
        kwargs.loc_sub_cfg_intorderadd_eeg_boundary (1,1) char = '0'
        kwargs.loc_sub_cfg_intorderadd_eeg_patch (1,1) char = '0'
        kwargs.loc_sub_cfg_intorderadd_eeg_transition (1,1) char = '0'
        kwargs.loc_sub_cfg_restrict (1,:) char { mustBeMember(kwargs.loc_sub_cfg_restrict, {'True','False'}) } = 'False'
        kwargs.loc_sub_cfg_type (1,:) char = 'local_subtraction'
        kwargs.source_model (1,:) char { mustBeMember(kwargs.source_model, ["local_subtraction", "subtraction", "venant", "partial_integration", "whitney"]) } = "local_subtraction"
        kwargs.subtraction_cfg_intorderadd (1,1) char = '0'
        kwargs.subtraction_cfg_intorderadd_lb (1,1) char = '0'
        kwargs.subtraction_cfg_type (1,:) char = 'subtraction'
        kwargs.tolerance (1,1) double { mustBeFinite, mustBePositive } = 1e-8
        kwargs.venant_cfg_initialization (1,:) char = 'closest_vertex'
        kwargs.venant_cfg_referenceLength (1,1) uint64 = 20
        kwargs.venant_cfg_relaxationFactor (1,1) double = 1e-6
        kwargs.venant_cfg_restrict (1,:) char { mustBeMember(kwargs.venant_cfg_restrict, {'True','False'}) } = 'True'
        kwargs.venant_cfg_type (1,:) char = 'multipolar_venant'
        kwargs.venant_cfg_weightingExponent (1,1) double = '1'
        kwargs.whitney_interpolation (1,:) char { mustBeMember(kwargs.whitney_interpolation, {'PBO', 'MPO'} ) } = 'PBO'
        kwargs.whitney_faceSources (1,:) char { mustBeMember(kwargs.whitney_faceSources, {'all', 'none'} ) } = 'all'
        kwargs.whitney_edgeSources  (1,:) char { mustBeMember(kwargs.whitney_edgeSources, {'all', 'internal', 'none'} ) } = 'all'
        kwargs.whitney_referenceLength (1,1) double { mustBePositive, mustBeFinite } = 10
        kwargs.whitney_restricted (1,:) char { mustBeMember(kwargs.whitney_restricted, {'True','False'}) } = 'True'
    end % arguments

    % Volume conductor input validation.

    if isempty(kwargs.nodes) || isempty(kwargs.tensors) || isempty(kwargs.elements) || isempty(kwargs.labels)

        assert(isfile(kwargs.cfg_tensors_filename), "The tensor file (" + kwargs.cfg_tensors_filename + ") was not found or was not a file.")

        assert(isfile(kwargs.cfg_grid_filename), "The grid file (" + kwargs.cfg_grid_filename + ") was not found or was not a file.")

    end % if

    % Driver creation.

    driverConfig.type = kwargs.cfg_type ;
    driverConfig.solver_type = kwargs.cfg_solver_type ;
    driverConfig.element_type = kwargs.cfg_element_type ;
    driverConfig.post_process = kwargs.cfg_post_process ;
    driverConfig.post_process_meg = kwargs.cfg_post_process_meg ;
    driverConfig.subtract_mean = kwargs.cfg_subtract_mean ;
    driverConfig.enable_experimental = kwargs.cfg_enable_experimental ;
    driverConfig.verbosity = kwargs.cfg_verbosity ;

    driverConfig.meg.intorderadd = kwargs.cfg_meg_intorderadd ;
    driverConfig.meg.type = kwargs.cfg_meg_type ;

    driverConfig.solver.reduction = kwargs.cfg_solver_reduction ;
    driverConfig.solver.edge_norm_type = kwargs.cfg_solver_edge_norm_type ;
    driverConfig.solver.penalty = kwargs.cfg_solver_penalty ;
    driverConfig.solver.scheme = kwargs.cfg_solver_scheme ;
    driverConfig.solver.weights = kwargs.cfg_solver_weights ;

    driverConfig.volume_conductor.grid.nodes = kwargs.nodes;
    driverConfig.volume_conductor.grid.elements = kwargs.elements;
    driverConfig.volume_conductor.grid.filename = kwargs.cfg_grid_filename ;

    driverConfig.volume_conductor.tensors.labels = kwargs.labels;
    driverConfig.volume_conductor.tensors.tensors = kwargs.tensors;
    driverConfig.volume_conductor.tensors.filename = kwargs.cfg_tensors_filename ;

    % Setting source model parameters.

    venant_cfg.type = kwargs.source_model ;
    venant_cfg.referenceLength = kwargs.venant_cfg_referenceLength ;
    venant_cfg.weightingExponent = kwargs.venant_cfg_weightingExponent ;
    venant_cfg.relaxationFactor = kwargs.venant_cfg_relaxationFactor ;
    venant_cfg.restrict = kwargs.venant_cfg_restrict ;
    venant_cfg.initialization = kwargs.venant_cfg_initialization ;

    subtraction_cfg.type = kwargs.source_model ;
    subtraction_cfg.intorderadd = kwargs.subtraction_cfg_intorderadd ;
    subtraction_cfg.intorderadd_lb = kwargs.subtraction_cfg_intorderadd_lb ;

    loc_sub_cfg.type = kwargs.source_model ;
    loc_sub_cfg.restrict = kwargs.loc_sub_cfg_restrict ;
    loc_sub_cfg.initialization = kwargs.loc_sub_cfg_initialization ;
    loc_sub_cfg.intorderadd_eeg_patch = kwargs.loc_sub_cfg_intorderadd_eeg_patch ;
    loc_sub_cfg.intorderadd_eeg_boundary = kwargs.loc_sub_cfg_intorderadd_eeg_boundary ;
    loc_sub_cfg.intorderadd_eeg_transition = kwargs.loc_sub_cfg_intorderadd_eeg_transition ;
    loc_sub_cfg.extensions = kwargs.loc_sub_cfg_extensions ;

    partial_integration_cfg.type = kwargs.source_model ;

    whitney_cfg.type = kwargs.source_model ;
    whitney_cfg.interpolation = kwargs.whitney_interpolation ;
    whitney_cfg.faceSources = kwargs.whitney_faceSources ;
    whitney_cfg.edgeSources = kwargs.whitney_edgeSources ;
    whitney_cfg.referenceLength = kwargs.whitney_referenceLength ;
    whitney_cfg.restricted = kwargs.whitney_restricted ;

    % Choose one of the above source models.

    if kwargs.source_model == "local_subtraction"

      driverConfig.source_model = loc_sub_cfg ;

    elseif kwargs.source_model == "subtraction"

      driverConfig.source_model = subtraction_cfg ;

    elseif kwargs.source_model == "venant"

      driverConfig.source_model = venant_cfg ;

    elseif driverConfig.source_model == "partial_integration"

      driverConfig.source_model == partial_integration_cfg ;

    elseif driverConfig.source_model == "whitney"

      driverConfig.source_model = whitney_cfg ;

    else

      error("Unknown source model type " + kwargs.source_model + ".") ;

    end

    % Set electrode configuration.

    electrodeConfig.type = kwargs.electrode_cfg_type ;

    electrodeConfig.codims = kwargs.electrode_cfg_codims ;

end % function
