classdef Zef < handle

    % Zef
    %
    % A handle class that functions as the back-end of the Zeffiro Interface
    % application. The GUI callback functions simply call the methods defined
    % in this class, when a user presses a button to initiate an action.
    %
    % Zef Properties:
    %
    % - adaptive_refinement_on
    %
    %   A boolean that determines whether adaptive refinement is used during
    %   mesh construction.
    %
    % - adaptive_refinement_k_param
    %
    %   A parameter used in the adaptive refinement of a finite element mesh.
    %
    % - adaptive_refinement_thresh_val
    %
    %   A threshold value for ending adaptive refinement.
    %
    % - brain_ind
    %
    %   The indices of the tetra that are a part of the active brain
    %   compartments.
    %
    % - bypass_inflate
    %
    %   A boolean for expressing whether to bypass the inflation step during
    %   mesh downsampling.
    %
    % - compartments
    %
    %   An array of VolumeCompartment objects.
    %
    % - create_sensor_fn
    %
    %   A function handle to decide which function to use in constructing
    %   electrodes.
    %
    % - data
    %
    %   Other auxiliary data. Allows storing fields from zef_data structs that
    %   have not yet been statically declared here. A backwards-compatibility
    %   field, in other words.
    %
    % - domain_labels
    %
    %   Seems like this contains indices for determining which tetra belong to
    %   which volume compartment.
    %
    % - explode_everything
    %
    %   TODO.
    %
    % - gpu_count
    %
    %   The claimed number of GPUs available.
    %
    % - initial_mesh_mode
    %
    %   The mode used in meshing.
    %
    % - L
    %
    %   A lead field matrix computed by solving Maxwell's equations in the
    %   domain defined by the finite element mesh.
    %
    % - label_ind
    %
    %   An initial index set, produced by an initial mesh generation routine,
    %   before labeling and refinement.
    %
    % - labeling_accuracy (meshing_accuracy)
    %
    %   participates in telling how sensitive the labeling routine is to
    %   determining whether the value belongs to a compartment or not.
    %
    % - labeling_mode (labeling_flag)
    %
    %   One of {"initial","repeated","adaptive-repeated"}. Tells how the mesh
    %   labeling routine should proceed with its input.
    %
    % - labeling_threshold (meshing_threshold)
    %
    %   Tells how sensitive the labeling routine is to determining whether the
    %   value belongs to a compartment or not.
    %
    % - mesh_generation_phase
    %
    %   The stage at which Zef is in mesh generation. Must be one of
    %   {"pre-processing", "initial build", "refinement", "adaptive
    %   refinement", "post-processing", "done"}.
    %
    % - mesh_labeling_approach
    %
    %   Determines how label_ind is generated during initial mesh generation.
    %
    % - mesh_resolution
    %
    %   The resolution of the contained FE mesh.
    %
    % - n_compartments
    %
    %   The number of compartments in the volume.
    %
    % - nodes
    %
    %   The nodes that make up a finite element mesh.
    %
    % - n_of_surface_refinements
    %
    %   The number of surface refinements that are to be performed on the
    %   mesh.
    %
    % - n_of_volume_refinements
    %
    %   The number of volume refinements that are to be performed on the
    %   mesh.
    %
    % - n_of_adaptive_volume_refinements
    %
    %   The number of adaptive volume refinements that are to be performed on
    %   the mesh.
    %
    % - parallel_processes
    %
    %   How many cores are to be used in parallel computations, when enough
    %   cores are available.
    %
    % - parallel_vectors
    %
    %   Used to determine how many restarts are needed when inflating meshes
    %   and finding points within compartments.
    %
    % - pml_ind
    %
    %   Indices of the PML mesh generation.
    %
    % - pml_max_size
    %
    %   The maximum size of Perfectly Matched Layers (PML) during mesh
    %   generation.
    %
    % - pml_max_size_unit
    %
    %   The unit of self.pml_max_size.
    %
    % - pml_outer_radius
    %
    %   The radius used in the Perfectly Matched Layer (PML) construction
    %   during mesh generation.
    %
    % - pml_outer_radius_unit
    %
    %   The unit of self.pml_outer_radius. Used in deciding the size of the
    %   bounding box of each volume compartment.
    %
    % - refinement_on
    %
    %   Determines whether refimenent is used during mesh generation.
    %
    % - sensors
    %
    %   An N × 3 array of sensor positions when PEM is used. With CEM, has 3
    %   more columns.
    %
    % - source_model
    %
    %   The source model used in lead field calculations.
    %
    % - surface_downsampling_on
    %
    %   A flag for deciding whether to downsample surfaces during FE mesh
    %   generation.
    %
    % - surface_refinement_on
    %
    %   A flag for deciding whether to refine surfaces during FE mesh
    %   generation.
    %
    % - tetra
    %
    %   The finite elements formed from nodes.
    %
    % - volume_refinement_on
    %
    %   A flag for deciding whether to refine the volume during FE mesh
    %   generation.
    %
    % - use_gpu
    %
    %   A boolean flag to determine whether to use GPU in computations, when
    %   available.
    %
    % - use_gui
    %
    %   Determines whether Zef was intended to be started with a GUI on. This
    %   affects things like whether a textual or graphical progress bar is
    %   shown during long computations.
    %

    properties

        adaptive_refinement_on (1,1) logical = false;

        adaptive_refinement_k_param (1,1) double { mustBeReal, mustBePositive } = 1;

        adaptive_refinement_thresh_val (1,1) double { mustBeReal, mustBePositive } = 1;

        bypass_inflate (1,1) logical = false;

        compartments zef_as_class.VolumeCompartment

        create_sensor_fn function_handle

        data struct

        domain_labels (:,1) double { mustBeInteger, mustBePositive } = [];

        explode_everything (1,1) logical = false;

        gpu_count (1,1) double { mustBeNonnegative }

        initial_mesh_mode (1,1) double { ...
            mustBeInteger, ...
            mustBeMember( initial_mesh_mode, [ 1, 2 ] ) } = 1;

        L (:,:) double

        label_ind (:,:) double { mustBeInteger, mustBePositive } = [];

        labeling_accuracy (1,1) double { mustBeReal, mustBePositive } = 1;

        labeling_mode (1,1) string { ...
            mustBeMember( labeling_mode, [ "initial", "repeated", "adaptive-repeated" ] ) } = "initial";

        labeling_threshold (1,1) double { mustBeReal, mustBePositive } = 0.5;

        mesh_generation_phase (1,1) string { mustBeMember(mesh_generation_phase, ["pre-processing", "initial build", "refinement", "adaptive refinement", "post-processing", "done"]) } = "done";

        mesh_resolution (1,1) double { mustBePositive } = 1;

        mesh_labeling_approach (1,1) double { ...
            mustBeInteger, ...
            mustBeMember( mesh_labeling_approach, [ 1, 2 ] ) } = 1;

        n_compartments (1,1) double { mustBeInteger, mustBePositive } = 1;

        nodes (:,3) double = [];

        n_of_surface_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        n_of_volume_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        n_of_adaptive_volume_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        parallel_processes double { mustBeInteger, mustBePositive } = 1;

        parallel_vectors double { mustBeInteger, mustBePositive } = 1;

        pml_ind (:,1) double { mustBeInteger, mustBePositive } = [];

        pml_max_size_unit (1,1) double = 1;

        pml_max_size (1,1) double = 1;

        pml_outer_radius (1,1) double { mustBePositive } = 1;

        pml_outer_radius_unit (1,1) double { mustBeInteger, mustBePositive } = 1;

        refinement_on (1,1) logical = false;

        sensors (:,1) zef_as_class.Sensor;

        source_model (1,1) zef_as_class.SourceModel = zef_as_class.SourceModel.Hdiv;

        surface_downsampling_on (1,1) logical = false;

        surface_refinement_on (1,1) logical = false;

        tetra (:,4) double { mustBePositive, mustBeInteger } = [];

        volume_refinement_on (1,1) logical = false;

        use_gpu (1,1) logical = false;

        use_gui (1,1) logical = false;

    end % properties

    properties (Constant)

        % The names of the volumentric compartments that can be found in some
        % older Zeffiro project files. The point of this is to help with
        % backwards-compatibility.

        VOLUME_COMPARTMENT_FIELD_NAMES = [
            "affine_transform",
            "color",
            "condition_number",
            "delta",
            "epsilon",
            "invert",
            "merge",
            "mu",
            "name",
            "on",
            "points",
            "points_original_surface_mesh",
            "points_inf",
            "priority",
            "rho",
            "scaling",
            "sigma",
            "sources",
            "sources_old",
            "submesh_ind",
            "submesh_ind_original_surface_mesh",
            "tetra",
            "transform_name",
            "triangles",
            "triangles_original_surface_mesh",
            "visible",
            "x_correction",
            "xy_rotation",
            "y_correction",
            "yz_rotation",
            "z_correction",
            "zx_rotation"
        ];

        MESH_LABELING_MODES = [
            "initial",
            "repeated",
            "adaptive-repeated"
        ];

        % TETRA_FACES
        %
        % A matrix whose row indices denote node indices within a single
        % tetrahedron and each row contains the node indices of the nodes that
        % form the face opposite to the node at each row index. In other
        % words, maps nodes to their opposing faces.

        TETRA_FACES = [
            2 4 3 ;
            1 3 4 ;
            1 4 2 ;
            1 2 3
        ];

    end % properties (Constant)

    events

    end % events

    methods

        function self = Zef(data)

            % Zef.Zef
            %
            % A constructor for Zef.
            %
            % Input:
            %
            % - data
            %
            %   A struct with the fields a Zef might have. These should
            %   ideally be statically defined, but for interoperability with
            %   an older implementation
            %
            %   NOTE: Zef explicitly ignores graphics objects, because it
            %   represents the back-end of Zeffiro Interface. Back-ends do not
            %   handle graphics.
            %
            % Output:
            %
            % - self
            %
            %   An instance of Zef.

            arguments
                data struct
            end

            fieldkeys = fieldnames(data);

            for fi = 1 : length(fieldkeys)

                finame = fieldkeys{fi};

                fival = data.(finame);

                % Check if the field is a graphics object.

                is_graphics_obj = isa(fival, 'matlab.graphics.Graphics');

                if is_graphics_obj || strcmp(finame, "fieldnames")

                    % Ignore graphical handles

                elseif strcmp(finame, 'adaptive_refinement_on')

                    self.adaptive_refinement_on = data.(finame);

                elseif strcmp(finame, 'adaptive_refinement_k_param')

                    self.adaptive_refinement_k_param = data.(finame);

                elseif strcmp(finame, 'adaptive_refinement_thresh_val')

                    self.adaptive_refinement_thresh_val = data.(finame);

                elseif strcmp(finame, 'explode_everything')

                    self.explode_everything = data.(finame);

                elseif strcmp(finame, 'nodes')

                    self.nodes = data.(finame);

                elseif strcmp(finame, 'tetra')

                    self.tetra = data.(finame);

                elseif strcmp(finame, 'domain_labels')

                    self.domain_labels = data.(finame);

                elseif strcmp(finame, 'refinement_flag') ...
                || strcmp(finame, 'mesh_generation_stage')

                    if isnumeric(fival)

                        if fival == 1

                            self.mesh_generation_stage = "pre-processing";

                        elseif fival == 2

                            self.mesh_generation_stage = "initial build";

                        elseif fival == 3

                            self.mesh_generation_stage = "refinement";

                        elseif fival == 4

                            self.mesh_generation_stage = "adaptive refinement";

                        elseif fival == 5

                            self.mesh_generation_stage = "post-processing";

                        else

                            self.mesh_generation_stage = "done";

                        end

                    elseif isstring(fival)

                        self.mesh_generation_stage = fival;

                    else

                        self.mesh_generation_stage = "done";

                    end

                    self.n_compartments = data.(finame);

                elseif strcmp(finame, 'n_compartments')

                    self.n_compartments = data.(finame);

                elseif strcmp(finame, 'n_of_surface_refinements')

                    self.n_of_surface_refinements = data.(finame);

                elseif strcmp(finame, 'n_of_volume_refinements')

                    self.n_of_volume_refinements = data.(finame);

                elseif strcmp(finame, 'n_of_adaptive_volume_refinements')

                    self.n_of_adaptive_volume_refinements = data.(finame);

                elseif strcmp(finame, 'use_gpu')

                    self.use_gpu = data.(finame);

                elseif strcmp(finame, 'create_patch_sensor')

                    self.create_sensor_fn = data.(finame);

                elseif strcmp(finame, 'gpu_count') || strcmp(finame, 'gpu_num')

                    if gpuDeviceCount > 0

                        self.gpu_count = data.(finame);

                    else

                        self.gpu_count = 0;

                    end

                elseif strcmp(finame, 'bypass_inflate')

                    self.bypass_inflate = data.(finame);

                elseif strcmp(finame, 'mesh_resolution')

                    self.mesh_resolution = data.(finame);

                elseif strcmp(finame, 'mesh_labeling_approach')

                    self.mesh_labeling_approach = data.(finame);

                elseif strcmp(finame, 'surface_downsampling_on') ...
                || strcmp(finame, 'downsample_surfaces')

                    self.surface_downsampling_on = data.(finame);

                elseif strcmp(finame, 'L')

                    self.L = data.(finame);

                elseif strcmp(finame, 'label_ind')

                    self.label_ind = data.(finame);

                elseif strcmp(finame, 'labeling_flag') ...
                || strcmp(finame, 'labeling_mode')

                    lmode = data.(finame);

                    if ismember(lmode, zef_as_class.Zef.MESH_LABELING_MODES)

                        self.labeling_mode = lmode;

                        continue

                    end

                    if isinteger(lmode)

                        if lmode == 1

                            self.labeling_mode = "initial";

                        elseif lmode == 2

                            self.labeling_mode = "repeated";

                        elseif lmode == 3

                            self.labeling_mode = "adaptive-repeated";

                        else

                            self.labeling_mode = "initial";

                        end

                    end

                elseif strcmp(finame, 'meshing_accuracy') ...
                || strcmp(finame, 'labeling_accuracy')

                    self.labeling_accuracy = data.(finame);

                elseif strcmp(finame, 'meshing_threshold') ...
                || strcmp(finame, 'labeling_threshold')

                    self.labeling_threshold = data.(finame);

                elseif strcmp(finame, 'parallel_processes')

                    self.parallel_processes = data.(finame);

                elseif strcmp(finame, 'parallel_vectors')

                    self.parallel_vectors = data.(finame);

                elseif strcmp(finame, 'pml_ind')

                    self.pml_ind = data.(finame);

                elseif strcmp(finame, 'pml_max_size')

                    self.pml_max_size = data.(finame);

                elseif strcmp(finame, 'pml_max_size_unit')

                    self.pml_max_size_unit = data.(finame);

                elseif strcmp(finame, 'pml_outer_radius')

                    self.pml_outer_radius = data.(finame);

                elseif strcmp(finame, 'pml_outer_radius_unit')

                    self.pml_outer_radius_unit = data.(finame);

                elseif strcmp(finame, 'refinement_on')

                    self.refinement_on = data.(finame);

                elseif strcmp(finame, 'source_model')

                    self.source_model = zef_as_class.SourceModel.from(fival);

                elseif strcmp(finame, 'surface_refinement_on')

                    self.surface_refinement_on = data.(finame);

                elseif strcmp(finame, 'volume_refinement_on') ...
                || strcmp(finame, 'refinement_volume_on')

                    self.volume_refinement_on = data.(finame);

                else

                    self.data(1).(finame) = data.(finame);

                end % if

            end % for

            % Loop over the fields again to construct the compartment tables,
            % after compartment tags are known.

            compartment_table = cell(0,2);

            for fi = 1 : length(fieldkeys)

                % Bail early, if compartment tags were not found from the
                % project file.

                if isempty(self.data.compartment_tags)

                    break;

                end

                finame = fieldkeys{fi};

                fival = data.(finame);

                % Parse the field name to see if it is a known compartment
                % property, and store them in a set of compartment properties.

                compartment_table_len = size(compartment_table, 1);

                if contains(finame, "_")

                    split_fi_name = string(strsplit(finame, "_"));

                    prefix = split_fi_name(1);

                    suffix_parts = split_fi_name(2:end);

                    suffix = string(join(suffix_parts, "_"));

                    if ismember(prefix, self.data.compartment_tags) ...
                    && ismember(suffix, zef_as_class.Zef.VOLUME_COMPARTMENT_FIELD_NAMES)

                        % Check if compartment name is already in the
                        % compartment table.

                        name_col = [compartment_table{:,1}];

                        if isempty(name_col)

                            compartment_ind = compartment_table_len + 1;

                            compartment_exists = false;

                        else

                            compartment_ind = find(ismember(name_col, prefix));

                            compartment_exists = any(compartment_ind);

                            if ~ compartment_exists

                                compartment_ind = compartment_table_len + 1;

                            end

                        end

                        if compartment_exists

                            compartment_table{compartment_ind, 2}.(suffix) = fival;

                        else

                            compartment_table{compartment_ind, 1} = prefix;

                            compartment_table{compartment_ind, 2}.(suffix) = struct;

                        end

                    end % if

                end % if

            end % for

            % Then iterate over the accumulated compartment info to generate
            % the compartment objects.

            n_of_compartment_structs = size(compartment_table, 1);

            for ii = 1 : n_of_compartment_structs

                a_struct = compartment_table{ii,2};

                self.compartments(ii) = zef_as_class.VolumeCompartment(a_struct);

            end

            % Build sensors.

            if isfield(self.data, "sensors")

                if isfield(self.data, "s_directions")

                    directions = self.data.s_directions

                else

                    directions = [];

                end

                if size(self.data.sensors, 2) == 3

                    self.sensors = zef_as_class.Sensor.from_arrays( ...
                        self.data.sensors(:,1:3), ...
                        directions, [], [], [] ...
                    );

                elseif size(self.data.sensors, 2) == 6

                    self.sensors = zef_as_class.Sensor.from_arrays( ...
                        self.data.sensors(:,1:3), ...
                        directions, ...
                        self.data.sensors(:,4), ...
                        self.data.sensors(:,5), ...
                        self.data.sensors(:,6) ...
                    );

                else

                    self.sensors = [];

                end

            end



        end % function

        % Finite element mesh construction

        self = build_initial_mesh(self, initial_mesh_mode, mesh_labeling_approach);

        self = label_mesh(self, labeling_mode);

        self = create_finite_element_mesh(self);

        self = refine_surface(self, n_of_refinements);

        self = refine_volume(self, n_of_refinements);

        self = refine_volume_adaptively(self, n_of_refinements, tolerance, iteration_param);

        % Fetching and setting properties.

        nodes = inflate_surface(self, nodes, surface_triangles);

        compartments = active_compartments(self);

        compartment_inds = active_compartment_inds(self);

        tetra_inds = active_tetra_inds(self);

        tetra_inds = tetra_inds_in_compartment(self, compartments);

    end % methods

    methods (Access = private)

        self = downsample_surfaces(self);

        self = preprocess_meshes(self);

        self = create_fem_mesh(self);

        self = postprocess_fem_mesh(self);

        self = segmentation_counter_step(self);

        self = mesh_refinement_step(self);

        [ ...
            surface_triangles, ...
            surface_nodes, ...
            tetra_ind, ...
            tetra_ind_global, ...
            tetra_ind_diff, ...
            node_ind, ...
            node_pair ...
        ] = surface_mesh(self, tetra, varargin);

        self = with_mesh_generation_phase(self, phase);

    end % methods (Access = private)

    methods (Static)

        self = load_from_file(filepath);

        patch_data = set_surface_resolution(patch_data, surface_resolution);

        [nodes,triangles,interp_vec] = triangular_mesh_refinement(nodes,triangles);

        [smoothed_nodes] = smooth_surface(nodes,triangles,smoothing_parameter,n_smoothing)

        V = tetra_volume(nodes, tetra, take_absolute_value, edge_inds);

        [condition_number, volume, longest_edge] = tetra_condition_number(nodes, tetra);

        longest_edge = tetra_longest_edge(nodes, tetra);

        [surface_triangles, surface_tetra_inds] = surface_triangles(tetra);

    end % methods (Static)

end % classdef
