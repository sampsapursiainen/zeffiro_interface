classdef VolumeCompartment

    % app.VolumeCompartment
    %
    % A class that describes how volumetric compartments are structured and
    % what operations are defined on them.
    %
    % Properties:
    %
    % - color
    %
    %   The RGB color of this compartment. Should probably not be stored here, but
    %   in the GUI.
    %
    % - condition_number
    %
    %   The condition number of this compartment.
    %
    % - delta
    %
    %   A parameter that might be used for something.
    %
    % - epsilon
    %
    %   A parameter that might be used for something.
    %
    % - is_on
    %
    %   A boolean flag for denoting whether this volumetric compartment is
    %   active.
    %
    % - name
    %
    %   The textual label of this compartment.
    %
    % - scaling
    %
    %   A scalar which denotes whether this compartment is scaled.
    %
    % - points
    %
    %   The set of points that belong to this volume compartment.
    %
    % - points_inf
    %
    %   Some set of points.
    %
    % - points_original_surface_mesh
    %
    %   The set of points that belong to this volume compartment, before being
    %   modified by the mesh creation process.
    %
    % - sigma
    %
    %   The condutivity of this compartment.
    %
    % - sources
    %
    %   A number indicating the number of sources in this volume.
    %
    % - sources_original_surface_mesh
    %
    %   A number indicating the number of sources in this volume, before being
    %   modified by the mesh creation routine.
    %
    % - submesh_ind
    %
    %   The indices of the submeshes that this compartment is a member of?
    %
    % - submesh_ind_original_surface_mesh
    %
    %   The indices of the submeshes that this compartment is a member of,
    %   before being modified by the mesh generation routine?
    %
    % - transform_name
    %
    %   The name of the affine transform applied to this compartment.
    %
    % - triangles
    %
    %   The index set signifying which triangles or triples of nodes belong to
    %   this compartment.
    %
    % - triangles_original_surface_mesh
    %
    %   The index set signifying which triangles or triples of nodes belong to
    %   this compartment, before being modified by the mesh creation process.
    %
    % - x_correction
    %
    %   A scalar which indicates whether the compartment has been corrected in
    %   the x-direction in a Cartesian coordinate system.
    %
    % - xy_rotation
    %
    %   A scalar which indicates how much this compartment has been rotated on
    %   relation to the xy-plane in a Cartesian system.
    %
    % - y_correction
    %
    %   A scalar which indicates whether the compartment has been corrected in
    %   the y-direction in a Cartesian coordinate system.
    %
    % - yz_rotation
    %
    %   A scalar which indicates how much this compartment has been rotated on
    %   relation to the yz-plane in a Cartesian system.
    %
    % - z_correction
    %
    %   A scalar which indicates whether the compartment has been corrected in
    %   the z-direction in a Cartesian coordinate system.
    %
    % - zx_rotation
    %
    %   A scalar which indicates how much this compartment has been rotated on
    %   relation to the zx-plane in a Cartesian system.
    %

    properties

        color (1,3) double {} = [0 0 0];

        condition_number (1,1) double = 1;

        delta (1,1) double = 0;

        epsilon (1,1) double = 0;

        is_on (1,1) logical = true;

        name (1,1) string = "";

        scaling (1,1) double { mustBePositive } = 1;

        x_correction (1,1) double = 0;

        y_correction (1,1) double = 0;

        z_correction (1,1) double = 0;

        xy_rotation (1,1) double = 0

        yz_rotation (1,1) double = 0

        zx_rotation (1,1) double = 0

        points_inf (:,3) double = [];

        points (:,3) double = [];

        points_original_surface_mesh (:,3) double = [];

        triangles (:,3) double { mustBeInteger, mustBePositive } = [];

        sigma (1,1) double { mustBeNonnegative } = 1;

        submesh_ind double { mustBeInteger, mustBePositive } = [];

        submesh_ind_original_surface_mesh double { mustBeInteger, mustBePositive } = [];

        sources (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        transform_name (1,1) string { mustBeText } = "";

    end % properties

    methods

        function self = VolumeCompartment(args)

            % app.VolumeCompartment.VolumeCompartment
            %
            % Constructor for this class. Takes as an input a struct whose
            % contents will be converted to the properties of this
            % compartment.

            arguments

                args struct

            end

            self.color = args.color;

            self.condition_number = args.condition_number;

            self.delta = args.delta;

            self.epsilon = args.epsilon;

            self.is_on = args.is_on;

            self.name = args.name;

            self.points = args.points;

            self.points_inf = args.points_inf;

            self.points_original_surface_mesh = args.points_original_surface_mesh;

            self.scaling = args.scaling;

            self.sigma = args.sigma;

            self.sources = args.sources;

            self.sources_original_surface_mesh = args.sources_original_surface_mesh;

            self.submesh_ind args.submesh_ind;

            self.submesh_ind_original_surface_mesh = args.submesh_ind_original_surface_mesh;

            self.transform_name = args.transform_name;

            self.triangles = args.triangles;

            self.x_correction = args.x_correction;

            self.xy_rotation = args.xy_rotation;

            self.y_correction = args.y_correction;

            self.yz_rotation = args.yz_rotation;

            self.z_correction = args.z_correction;

            self.zx_rotation = args.zx_rotation;

        end % function

    end % methods

end % classdef
