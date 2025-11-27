function T = eeg_transfer_matrix(nodes, elements, labels, tensors, electrodes, dipoles, kwargs)
%
%   T = eeg_transfer_matrix(nodes, elements, labels, tensors, electrodePositions, dipoles, kwargs)
%
% A function that computes an EEG transfer matrix from nodes to electrodes using the DUNEuro software suite.
% Assumes that the duneuro-matlab interface has been installed into $HOME/Documents/MATLAB/+duneuro.
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
%   dipoles
%
% A 6 x m double-matrix. Each column represents a dipole. The first three rows represent the cartesian coordinates of the dipole, the last three rows represent the moment of the dipole. Each column in this matrix generates to a column in the lead field matrix.
%
%   kwargs.cfg_element_type (1,:) char = 'tetrahedron'
%
% TODO
%
%   kwargs.cfg_enable_experimental (1,:) char = 'False'
%
% TODO
%
%   kwargs.cfg_post_process (1,:) char = 'True'
%
% TODO
%
%   kwargs.cfg_solver_edge_norm_type (1,:) char = 'houston'
%
% TODO
%
%   kwargs.cfg_solver_penalty (1,:) char = '20'
%
% TODO
%
%   kwargs.cfg_solver_reduction (1,:) char = '1e-16'
%
% TODO
%
%   kwargs.cfg_solver_scheme (1,:) char = 'sipg'
%
% TODO
%
%   kwargs.cfg_solver_type (1,:) char = 'cg'
%
% TODO
%
%   kwargs.cfg_solver_weights (1,:) char = 'tensorOnly'
%
% TODO
%
%   kwargs.cfg_subtract_mean (1,:) char = 'True'
%
% TODO
%
%   kwargs.cfg_type (1,:) char = 'fitted'
%
% TODO
%
%   kwargs.cfg_verbosity (1,1) uint64 = uint64(1)
%
% TODO
%
%   kwargs.electrode_cfg_codims (1,1) char = '3'
%
% TODO
%
%   kwargs.electrode_cfg_type (1,:) char = 'closest_subentity_center'
%
% TODO
%
%   kwargs.loc_sub_cfg_extensions (1,:) char = 'vertex vertex'
%
% TODO
%
%   kwargs.loc_sub_cfg_initialization (1,:) char = 'single_element'
%
% TODO
%
%   kwargs.loc_sub_cfg_intorderadd_eeg_boundary (1,1) char = '0'
%
% TODO
%
%   kwargs.loc_sub_cfg_intorderadd_eeg_patch (1,1) char = '0'
%
% TODO
%
%   kwargs.loc_sub_cfg_intorderadd_eeg_transition (1,1) char = '0'
%
% TODO
%
%   kwargs.loc_sub_cfg_restrict (1,:) char = 'False'
%
% TODO
%
%   kwargs.loc_sub_cfg_type (1,:) char = 'local_subtraction'
%
% TODO
%
%   kwargs.source_model (1,:) char { mustBeMember(kwargs.source_model, ["local_subtraction", "subtraction", "venant"]) } = "local_subtraction"
%
% TODO
%
%   kwargs.subtraction_cfg_intorderadd (1,1) char = '0'
%
% TODO
%
%   kwargs.subtraction_cfg_intorderadd_lb (1,1) char = '0'
%
% TODO
%
%   kwargs.subtraction_cfg_type (1,:) char = 'subtraction'
%
% TODO
%
%   kwargs.tolerance (1,1) double { mustBeFinite, mustBePositive } = 1e-8
%
% TODO
%
%   kwargs.venant_cfg_initialization (1,:) char = 'closest_vertex'
%
% TODO
%
%   kwargs.venant_cfg_referenceLength (1,1) uint64 = 20
%
% TODO
%
%   kwargs.venant_cfg_relaxationFactor (1,1) double = 1e-6
%
% TODO
%
%   kwargs.venant_cfg_restrict (1,:) char = 'True'
%
% TODO
%
%   kwargs.venant_cfg_type (1,:) char = 'multipolar_venant'
%
% TODO
%
%   kwargs.venant_cfg_weightingExponent (1,1) double = '1'
%

  arguments
    nodes (3,:) double { mustBeFinite }
    elements (:,:) uint64
    labels (1,:) uint64
    tensors (9,:) double { mustBeFinite }
    electrodes (3,:) double { mustBeFinite }
    dipoles (6,:) double { mustBeFinite }
    kwargs.cfg_element_type (1,:) char = 'tetrahedron'
    kwargs.cfg_enable_experimental (1,:) char = 'False'
    kwargs.cfg_post_process (1,:) char = 'True'
    kwargs.cfg_solver_edge_norm_type (1,:) char = 'houston'
    kwargs.cfg_solver_penalty (1,:) char = '20'
    kwargs.cfg_solver_reduction (1,:) char = '1e-16'
    kwargs.cfg_solver_scheme (1,:) char = 'sipg'
    kwargs.cfg_solver_type (1,:) char = 'cg'
    kwargs.cfg_solver_weights (1,:) char = 'tensorOnly'
    kwargs.cfg_subtract_mean (1,:) char = 'True'
    kwargs.cfg_type (1,:) char = 'fitted'
    kwargs.cfg_verbosity (1,1) uint64 = uint64(1)
    kwargs.electrode_cfg_codims (1,1) char = '3'
    kwargs.electrode_cfg_type (1,:) char = 'closest_subentity_center'
    kwargs.loc_sub_cfg_extensions (1,:) char = 'vertex vertex'
    kwargs.loc_sub_cfg_initialization (1,:) char = 'single_element'
    kwargs.loc_sub_cfg_intorderadd_eeg_boundary (1,1) char = '0'
    kwargs.loc_sub_cfg_intorderadd_eeg_patch (1,1) char = '0'
    kwargs.loc_sub_cfg_intorderadd_eeg_transition (1,1) char = '0'
    kwargs.loc_sub_cfg_restrict (1,:) char = 'False'
    kwargs.loc_sub_cfg_type (1,:) char = 'local_subtraction'
    kwargs.source_model (1,:) char { mustBeMember(kwargs.source_model, ["local_subtraction", "subtraction", "venant"]) } = "local_subtraction"
    kwargs.subtraction_cfg_intorderadd (1,1) char = '0'
    kwargs.subtraction_cfg_intorderadd_lb (1,1) char = '0'
    kwargs.subtraction_cfg_type (1,:) char = 'subtraction'
    kwargs.tolerance (1,1) double { mustBeFinite, mustBePositive } = 1e-8
    kwargs.venant_cfg_initialization (1,:) char = 'closest_vertex'
    kwargs.venant_cfg_referenceLength (1,1) uint64 = 20
    kwargs.venant_cfg_relaxationFactor (1,1) double = 1e-6
    kwargs.venant_cfg_restrict (1,:) char = 'True'
    kwargs.venant_cfg_type (1,:) char = 'multipolar_venant'
    kwargs.venant_cfg_weightingExponent (1,1) double = '1'
  end % arguments

% Update cfg struct with solver parameters and geometry.

cfg.type = kwargs.cfg_type ;
cfg.solver_type = kwargs.cfg_solver_type ;
cfg.element_type = kwargs.cfg_element_type ;
cfg.post_process = kwargs.cfg_post_process ;
cfg.subtract_mean = kwargs.cfg_subtract_mean ;
cfg.enable_experimental = kwargs.cfg_enable_experimental ;
cfg.verbosity = kwargs.cfg_verbosity ;
cfg.solver.reduction = kwargs.cfg_solver_reduction ;
cfg.solver.edge_norm_type = kwargs.cfg_solver_edge_norm_type ;
cfg.solver.penalty = kwargs.cfg_solver_penalty ;
cfg.solver.scheme = kwargs.cfg_solver_scheme ;
cfg.solver.weights = kwargs.cfg_solver_weights ;

cfg.volume_conductor.grid.nodes = nodes;
cfg.volume_conductor.grid.elements = elements;
cfg.volume_conductor.tensors.labels = labels;
cfg.volume_conductor.tensors.tensors = tensors;

disp('Creating driver')
driver = duneuro.duneuro_meeg(cfg);
disp('Driver created')

% Set electrodes

disp('Setting electrodes')
electrode_cfg.codims = kwargs.electrode_cfg_codims ;
electrode_cfg.type = kwargs.electrode_cfg_type ;
driver.set_electrodes(electrodes, electrode_cfg);
disp('Electrodes set')

% Setting source model parameters.

venant_cfg.type = kwargs.venant_cfg_type ;
venant_cfg.referenceLength = kwargs.venant_cfg_referenceLength ;
venant_cfg.weightingExponent = kwargs.venant_cfg_weightingExponent ;
venant_cfg.relaxationFactor = kwargs.venant_cfg_relaxationFactor ;
venant_cfg.restrict = kwargs.venant_cfg_restrict ;
venant_cfg.initialization = kwargs.venant_cfg_initialization ;

subtraction_cfg.type = kwargs.subtraction_cfg_type ;
subtraction_cfg.intorderadd = kwargs.subtraction_cfg_intorderadd ;
subtraction_cfg.intorderadd_lb = kwargs.subtraction_cfg_intorderadd_lb ;

loc_sub_cfg.type = kwargs.loc_sub_cfg_type ;
loc_sub_cfg.restrict = kwargs.loc_sub_cfg_restrict ;
loc_sub_cfg.initialization = kwargs.loc_sub_cfg_initialization ;
loc_sub_cfg.intorderadd_eeg_patch = kwargs.loc_sub_cfg_intorderadd_eeg_patch ;
loc_sub_cfg.intorderadd_eeg_boundary = kwargs.loc_sub_cfg_intorderadd_eeg_boundary ;
loc_sub_cfg.intorderadd_eeg_transition = kwargs.loc_sub_cfg_intorderadd_eeg_transition ;
loc_sub_cfg.extensions = kwargs.loc_sub_cfg_extensions ;

% Choose one of the above source models.

if kwargs.source_model == "local_subtraction"

  cfg.source_model = loc_sub_cfg ;

elseif kwargs.source_model == "subtraction"

  cfg.source_model = subtraction_cfg ;

elseif kwargs.source_model == "venant"

  cfg.source_model = venant_cfg ;

else

  error("Unknown source model type " + kwargs.source_model + ".") ;

end

% Compute transfer matrix.

disp('Computing transfer matrix')
T = driver.compute_eeg_transfer_matrix(cfg);
disp('Transfer matrix computed')

end % function
