classdef Sensor

%
% Sensor
%
% A sensor such as an electrode that resides on the surface of the object
% being measured. Can operate in 2 modes: PEM or CEM, Point Electrode Model or
% Complete Electrode Model. In case of PEM, only the position is relevant and
% the inner and outer radii are set to 0 and impedance to ∞.
%
% Properties:
%
% - position
%
%   The position of this electrode in 3D Cartesian space.
%
% - inner_radius
%
%   The inner radius of this sensor. Must be less than or equal to
%   self.outer_radius.
%
% - outer_radius
%
%   The outer radius of this sensor. Must be more than or equal to
%   self.inner_radius.
%
% - impedance
%
%   The (real) impedance of this sensor.
%

    properties (SetAccess = private, GetAccess = public)

        position (1,3) double = [ 0 , 0 , 0 ];

        inner_radius (1,1) double { mustBeReal , mustBeNonnegative} = 0;

        outer_radius (1,1) double { mustBeReal , mustBeNonnegative} = 0;

        impedance (1,1) double { mustBeReal , mustBeNonnegative} = Inf;

    end % properties

    methods

        function self = Sensor(position, inner_radius, outer_radius, impedance)

        % Sensor
        %
        % The constructor of this class.
        %

            if inner_radius > outer_radius

                error("Tried to construct a Sensor with an inner radius greater than its outer radius. Aborting.")

            end

            if outer_radius > 0 && isinf(impedance)

                error("If a Sensor is complete, as in has a size, it cannot have infinite impedance. Aborting...");

            end

            if ~ isinf(impedance) && outer_radius == 0

                error("A point-like sensor cannot have a finite impedance. Aborting...")

            end

            self.position = position;

            self.inner_radius = inner_radius;

            self.outer_radius = outer_radius;

            self.impedance = impedance;

        end

        function self = set_position_to(position)

        %
        % set_position_to
        %
        % Sets the position of this electrode to a given value.
        %

            self.position = position;

        end

        function self = set_inner_radius_to(self, radius)

        %
        % set_inner_radius_to
        %
        % Sets the inner radius of this sensor to a given value.
        %
        % NOTE: If the value is greater than the current value of the outer
        % radius, the value of self.outer_radius is also inreased so that the
        % difference in size is maintained.
        %

            if radius >= self.outer_radius

                diff_in_size = self.outer_radius - self.inner_radius;

                self.outer_radius = radius + diff_in_size;

            end

            self.inner_radius = radius;

        end % functions

        function self = set_outer_radius_to(self, radius)

        %
        % set_outer_radius_to
        %
        % Sets the outer radius of this sensor to a given value.
        %
        % NOTE: If the value is less than the current value of the inner
        % radius, the value of self.inner_radius is also decreased so that the
        % difference in size is maintained, or set to 0 if this cannot be
        % done.
        %

            if radius <= self.inner_radius

                diff_in_size = self.outer_radius - self.inner_radius;

                new_inner_size = self.inner_radius - diff_in_size;

                if new_inner_size < 0

                    self.inner_radius = 0;

                else

                    self.inner_radius = new_inner_size;

                end

            end

            self.outer_radius = radius;

        end % function


        function self = set_impedance_to(self, impedance)

            %
            % set_impedance_to
            %
            % Sets the value of the impedance to the given value, returning
            % self.
            %

            self.impedance = impedance;

        end

        function self = set_conductance_to(self, conductance)

            %
            % set_conductance_to
            %
            % Sets the value of the impedance to the given value, returning
            % self.
            %

            self.impedance = 1 / conductance;

        end

    end % methods

    methods (Static)

        function self = default()

            self = zef_as_class.Sensor([0, 0 ,0], 0, 0, Inf);

        end

    end % methods (Static)

end % classdef
