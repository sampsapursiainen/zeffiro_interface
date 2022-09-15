classdef AffinelyTransformable

    % AffinelyTransformable
    %
    % A superclass of classes which can be affinely transformed, as in have a
    % position, orientation and so forth. Within Zeffiro, these include
    % volumetric ompartments and sensors.
    %
    % Properties:
    %
    % - affine_transform
    %
    %   A transformation matrix that was last applied to this
    %   AffinelyTransformable.
    %
    % - scaling
    %
    %   A scalar which denotes whether this transformable is scaled.
    %
    % - transform_name
    %
    %   The name of the affine transform applied to this transformable.
    %
    % - x_correction
    %
    %   A scalar which indicates whether the transformable has been corrected in
    %   the x-direction in a Cartesian coordinate system.
    %
    % - xy_rotation
    %
    %   A scalar which indicates how much this transformable has been rotated on
    %   relation to the xy-plane in a Cartesian system.
    %
    % - y_correction
    %
    %   A scalar which indicates whether the transformable has been corrected in
    %   the y-direction in a Cartesian coordinate system.
    %
    % - yz_rotation
    %
    %   A scalar which indicates how much this transformable has been rotated on
    %   relation to the yz-plane in a Cartesian system.
    %
    % - z_correction
    %
    %   A scalar which indicates whether the transformable has been corrected in
    %   the z-direction in a Cartesian coordinate system.
    %
    % - zx_rotation
    %
    %   A scalar which indicates how much this transformable has been rotated on
    %   relation to the zx-plane in a Cartesian system.
    %

    properties

        affine_transform double = [];

        scaling (1,1) double { mustBePositive } = 1;

        transform_name (1,1) string { mustBeText } = "";

        x_correction (1,1) double = 0;

        y_correction (1,1) double = 0;

        z_correction (1,1) double = 0;

        xy_rotation (1,1) double = 0

        yz_rotation (1,1) double = 0

        zx_rotation (1,1) double = 0

    end % properties

    methods

        function self = AffinelyTransformable(args)

            % zef_as_class.AffinelyTransformable.AffinelyTransformable
            %
            % Constructor for this class. Takes as an input a struct whose
            % contents will be converted to the properties of this
            % transformable.

            arguments

                args struct

            end

            if isfield(args, "affine_transform")

                self.affine_transform = args.affine_transform;

            end

            if isfield(args, "scaling")

                self.scaling = args.scaling;

            end

            if isfield(args, "transform_name")

                self.transform_name = args.transform_name;

            end

            if isfield(args, "x_correction")

                self.x_correction = args.x_correction;

            end

            if isfield(args, "xy_rotation")

                self.xy_rotation = args.xy_rotation;

            end

            if isfield(args, "y_correction")

                self.y_correction = args.y_correction;

            end

            if isfield(args, "yz_rotation")

                self.yz_rotation = args.yz_rotation;

            end

            if isfield(args, "z_correction")

                self.z_correction = args.z_correction;

            end

            if isfield(args, "zx_rotation")

                self.zx_rotation = args.zx_rotation;

            end

        end % function

    end % methods

end % classdef
