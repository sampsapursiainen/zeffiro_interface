classdef Electrode
%
% Electrode
%
% A type definition for electric sensors in Zeffiro Interface.
%

    properties
        %
        % The 3D position of this sensor.
        %
        position (1,3) double { mustBeNonNan, mustBeFinite } = [0, 0, 0]
        %
        % The inner radius of this sensor.
        %
        inner_radius (1,1) double { mustBeNonnegative, mustBeFinite, mustBeNonNan } = 0
        %
        % The outer radius of this sensor.
        %
        outer_radius (1,1) double { mustBeNonnegative, mustBeFinite, mustBeNonNan } = 0
        %
        % The impedance of this sensor.
        %
        impedance (1,1) double { mustBeNonnegative } = Inf
        %
    end % properties

    properties ( Constant, Access=private )

        DEFAULT_IMPEDANCE = 1000

    end

    methods

        function self = Electrode ( kwargs )
        %
        % Electrode (
        %   kwargs.position
        %   kwargs.inner_radius
        %   kwargs.outer_radius
        %   kwargs.impedance
        % )
        %
        % A constructor for this class.
        %
        % NOTE: If the given inner radius is greater than the given outer radius, the outer radius
        % will automatically be adjusted to match it, and vice versa, with outer radius taking
        % precedence. Also an outer radius of 0 will lead to an impedance of Inf, and a non-zero
        % outer radius will also force the impedance to be non-zero.
        %

            arguments

                kwargs.position = [0,0,0]

                kwargs.inner_radius = 0

                kwargs.outer_radius = 0

                kwargs.impedance = Inf

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end % for

            % Perform additional validations after the given values have been set.

            if self.inner_radius > self.outer_radius

                self.inner_radius = kwargs.outer_radius ;

                self.inner_radius = kwargs.outer_radius + eps ( kwargs.outer_radius ) ;

            end

            if self.impedance == 0 && self.outer_radius > 0

                self.impedance = self.DEFAULT_IMPEDANCE ;

            end

            if self.outer_radius > 0 && isinf ( self.impedance )

                self.impedance = self.DEFAULT_IMPEDANCE ;

            end

            if self.outer_radius == 0

                self.impedance = Inf ;

            end

        end % function

    end % methods

end % classdef
