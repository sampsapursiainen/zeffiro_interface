classdef Zef < handle

    % Zef
    %
    % A handle class that functions as the back-end of the Zeffiro Interface
    % application. The GUI callback functions simply call the methods defined
    % in this class, when a user presses a button to initiate an action.
    %
    % Zef Properties:
    %
    % - active_compartment_tags
    %
    %   An array that contains the compartment tags of active compartments.
    %   Tags are added here when they are active and removed when made
    %   inactive.
    %
    % - bypass_inflate
    %
    %   A boolean for expressing whether to bypass the inflation step during
    %   mesh downsampling.
    %
    % - compartment_tags
    %
    %   A cell array that contains the textual compartment tags of a domain.
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
    % - mesh_resolution
    %
    %   The resolution of the contained FE mesh.
    %
    % - name_tags
    %
    %   Names of the different brain compartments.
    %
    % - nodes
    %
    %   The nodes that make up a finite element mesh.
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
    % - sensors
    %
    %   An N × 3 array of sensor positions when PEM is used. With CEM, has 3
    %   more columns.
    %
    % - surface_downsampling_on
    %
    %   A flag for deciding whether to downsample surfaces during FE mesh
    %   generation.
    %
    % - tetra
    %
    %   The finite elements formed from nodes.
    %
    % - use_gpu
    %
    %   A boolean flag to determine whether to use GPU in computations, when
    %   available.


    properties

        active_compartment_tags string = [];

        bypass_inflate (1,1) logical = false;

        compartment_tags string = [];

        compartments zef_as_class.VolumeCompartment

        create_sensor_fn function_handle

        data struct

        use_gpu (1,1) logical = false;

        gpu_count (1,1) double { mustBeNonnegative }

        initial_mesh_mode (1,1) double { mustBeInteger }

        L (:,:) double

        mesh_resolution (1,1) double { mustBePositive } = 1;

        name_tags string = [];

        nodes (:,3) double = [];

        parallel_processes double { mustBeInteger, mustBePositive }

        parallel_vectors double { mustBeInteger, mustBePositive }

        sensors (:,:) double = [];

        surface_downsampling_on (1,1) logical = false;

        tetra (:,4) double { mustBePositive, mustBeInteger } = [];

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

                elseif strcmp(finame, 'nodes')

                    self.nodes = data.(finame);

                elseif strcmp(finame, 'tetra')

                    self.tetra = data.(finame);

                elseif strcmp(finame, 'compartment_tags')

                    self.compartment_tags = data.(finame);

                elseif strcmp(finame, 'name_tags')

                    self.name_tags = data.(finame);

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

                elseif strcmp(finame, 'active_compartment_tags')

                    self.active_compartment_tags = data.(finame);

                elseif strcmp(finame, 'bypass_inflate')

                    self.bypass_inflate = data.(finame);

                elseif strcmp(finame, 'mesh_resolution')

                    self.mesh_resolution = data.(finame);

                elseif strcmp(finame, 'sensors')

                    self.sensors = data.(finame);

                elseif strcmp(finame, 'surface_downsampling_on') ...
                || strcmp(finame, 'downsample_surfaces')

                    self.surface_downsampling_on = data.(finame);

                elseif strcmp(finame, 'L')

                    self.L = data.(finame);

                elseif strcmp(finame, 'parallel_processes')

                    self.parallel_processes = data.(finame);

                elseif strcmp(finame, 'parallel_vectors')

                    self.parallel_vectors = data.(finame);

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

                if isempty(self.compartment_tags)

                    break;

                end

                finame = fieldkeys{fi};

                fival = data.(finame);

                % Parse the field name to see if it is a known compartment
                % property, and store them in a set of compartment properties.

                compartment_table_len = size(compartment_table, 1);

                if contains(finame, "_")

                    split_fi_name = strsplit(finame, "_");

                    prefix = string(split_fi_name{1});

                    suffix_parts = split_fi_name{2:end};

                    suffix = string(join(suffix_parts, "_"));

                    if ismember(prefix, self.compartment_tags) ...
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

        end % function

        % Finite element mesh construction

        self = create_finite_element_mesh(self);

        nodes = inflate_surface(self, nodes, surface_triangles);

    end % methods

    methods (Access = private)

        self = downsample_surfaces(self);

        self = process_meshes(self);

        self = create_fem_mesh(self);

        self = postprocess_fem_mesh(self);

        self = segmentation_couter_step(self);

        [ ...
            surface_triangles, ...
            surface_nodes, ...
            tetra_ind, ...
            tetra_ind_global, ...
            tetra_ind_diff, ...
            node_ind, ...
            node_pair ...
        ] = surface_mesh(self, tetra, varargin);

    end % methods (Access = private)

    methods (Static)

        self = load_from_file(filepath);

        patch_data = set_surface_resolution(patch_data, surface_resolution);

        [nodes,triangles,interp_vec] = triangular_mesh_refinement(nodes,triangles);

        [smoothed_nodes] = smooth_surface(nodes,triangles,smoothing_parameter,n_smoothing)

    end % methods (Static)

end % classdef
