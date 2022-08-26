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
    % - L
    %
    %   A lead field matrix computed by solving Maxwell's equations in the
    %   domain defined by the finite element mesh.
    %
    % - mesh_resolution
    %
    %   The resolution of the contained FE mesh.
    %
    % - nodes
    %
    %   The nodes that make up a finite element mesh.
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

        data struct

        use_gpu (1,1) logical = false;

        gpu_count (1,1) double { mustBeNonnegative }

        L (:,:) double

        mesh_resolution (1,1) double { mustBePositive } = 1;

        nodes (:,3) double = [];

        surface_downsampling_on (1,1) logical = false;

        tetra (:,4) double { mustBePositive, mustBeInteger } = [];

    end % properties

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

                is_graphics_obj = isa(fival, 'matlab.graphics.Graphics');

                if is_graphics_obj || strcmp(finame, "fieldnames")

                    % Ignore graphical handles

                elseif strcmp(finame, 'nodes')

                    self.nodes = data.(finame);

                elseif strcmp(finame, 'tetra')

                    self.tetra = data.(finame);

                elseif strcmp(finame, 'compartment_tags')

                    self.compartment_tags = data.(finame);

                elseif strcmp(finame, 'use_gpu')

                    self.use_gpu = data.(finame);

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

                elseif strcmp(finame, 'surface_downsampling_on') ...
                || strcmp(finame, 'downsample_surfaces')

                    self.surface_downsampling_on = data.(finame);

                elseif strcmp(finame, 'L')

                    self.L = data.(finame);

                else

                    self.data(1).(finame) = data.(finame);

                end

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

    end % methods (Access = private)

    methods (Static)

        self = load_from_file(filepath);

        patch_data = set_surface_resolution(patch_data, surface_resolution);

        [nodes,triangles,interp_vec] = triangular_mesh_refinement(nodes,triangles);

        [smoothed_nodes] = smooth_surface(nodes,triangles,smoothing_parameter,n_smoothing)

    end % methods (Static)

end % classdef
