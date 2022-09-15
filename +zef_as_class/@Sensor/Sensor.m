classdef Sensor

% Sensor
%
% A sensor such as an electrode that resides on the surface of the object
% being measured. Cna operate in 2 modes: PEM or CEM, Point Electrode Model or
% Complete Electrode Model.
%
% Properties:
%
% - position
%
%   The position of this electrode in 3D Cartesian space.
%
% - inner_radius

    properties (Access = private)

        position (3,1) double = [ 0 ; 0 ; 0 ];

        inner_radius = (1,1) double { mustBeReal , mustBeNonnegative} = 0;

        outer_radius = (1,1) double { mustBeReal , mustBeNonnegative} = 0;

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

            self.position = position;

            self.inner_radius = inner_radius;

            self.outer_radius = outer_radius;

            self.impedance = impedance;

        end

        function c = conductivity(self)

        %
        % conductivity
        %
        % Returns the conductivity computed from self.impedance.
        %

            c = 1 / self.impedance;

        end % function

        function set_inner_radius_to(radius)

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

        function set_outer_radius_to(radius)

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

    end % methods

end % classdef
