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
% - direction
%
%   The direction this electrode points in, in 3D Cartesian space.
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

        direction (1,3) double = [ 1 , 0 , 0 ];

        inner_radius (1,1) double { mustBeReal , mustBeNonnegative} = 0;

        outer_radius (1,1) double { mustBeReal , mustBeNonnegative} = 0;

        impedance (1,1) double { mustBeReal , mustBePositive} = Inf;

    end % properties

    methods

        function self = Sensor(position, direction, inner_radius, outer_radius, impedance)

        % Sensor
        %
        % The constructor of this class.
        %
        % Inputs:
        %
        % - position
        %
        % - direction
        %
        % - inner_radius
        %
        % - outer_radius
        %
        % - impedance
        %
        % Output
        %
        % - self
        %
        %   A single sensor.
        %

            if inner_radius > outer_radius

                error("Tried to construct a Sensor with an inner radius greater than its outer radius. Aborting...");

            end

            if outer_radius > 0 && isinf(impedance)

                error("If a Sensor is complete, as in has a size, it cannot have infinite impedance. Aborting...");

            end

            if ~ isinf(impedance) && outer_radius == 0

                error("A point-like sensor cannot have a finite impedance. Aborting...")

            end

            self.position = position;

            self.direction = direction;

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

        % default
        %
        % Provides a default instance of a sensor, positioned at origin,
        % pointing upwards and in PEM mode.

            self = zef_as_class.Sensor([0, 0 ,0], [0, 0, 1], 0, 0, Inf);

        end % function

        function sensors = from_arrays(positions, directions, inner_radii, outer_radii, impedances)

        % from_array
        %
        % Builds a set of sensors from a given array.
        %
        % Input:
        %
        % - positions
        %
        %   The 3D positions of the arrays.
        %
        % - directions
        %
        %   The 3D directions of the electrodes. If given as a single 3D
        %   vector, all electrodes are given the same direction.
        %
        % - inner radii (optional, default = [])
        %
        %   The inner radii of the electrodes. If given as a scalar, all
        %   electrodes are given the same inner radius.
        %
        % - outer_radii (optional, default = [])
        %
        %   The outer radii of the electrodes. If given as a scalar, all
        %   electrodes are given the same inner radius.
        %
        % - impedances (optional, default = [])
        %
        %   The impedances of the electrodes. If given as a scalar, all
        %   electrodes are given the same inner radius.
        %

            arguments

                positions (:,3) double { mustBeReal }

                directions (:,3) double { mustBeReal }

                inner_radii (:,1) double { mustBeReal, mustBeNonnegative } = 0;

                outer_radii (:,1) double { mustBeReal, mustBeNonnegative } = 0;

                impedances (:,1) double { mustBeReal, mustBePositive } = Inf;

            end

            % Determine sensor array size.

            n_of_rows = size(positions, 1);

            n_of_cols = size(positions, 2);

            % Determine the mode of the electrodes (PEM vs. CEM). If the
            % electrodes do not have a given size or impedances, they must be
            % in PEM mode.

            if isempty(outer_radii) || isempty(impedances)

                use_pem = true;

            else

                use_pem = false;

            end

            % Preallocate a sensor array.
            %
            % TODO: maybe the impedances and other scalars could be set here
            % via "vectorization" as well, based on whether they are given as
            % a single scalar or not, but that might complicate the function
            % logic and require more nested ifs.

            sensors = repmat(zef_as_class.Sensor.default, n_of_rows, 1);

            % Then build electrodes from the given arrays.

            for row = 1 : n_of_rows

                sensors(row).position = positions(row, :);

                if size(directions) == [1 3]

                    sensors(row).direction = directions;

                elseif size(directions) == size(positions)

                    sensors(row).direction = directions(row, :);

                else

                    % Do nothing and use the default direction set during
                    % pre-allocation.

                end

                if ~ use_pem % we are using CEM

                    if isscalar(inner_radii)

                        inner_radius = inner_radii;

                    elseif numel(inner_radii) == n_of_rows

                        inner_radius = inner_radii(row);

                    else

                        error("The number of given inner radii is not scalar or is different from the given number of electrode positions.")

                    end

                    sensors(row) = sensors(row).set_inner_radius_to(inner_radius);

                    if isscalar(outer_radii)

                        outer_radius = outer_radii;

                    elseif numel(outer_radii) == n_of_rows

                        outer_radius = outer_radii(row);

                    else

                        error("The number of given outer radii is not scalar or is different from the given number of electrode positions.")

                    end

                    sensors(row) = sensors(row).set_outer_radius_to(outer_radius);

                    if isscalar(impedances)

                        impedance = impedances;

                    elseif numel(impedances) == n_of_rows

                        impedance = impedances(row);

                    else

                        error("The number of given impedances is not scalar or is different from the given number of electrode positions.")

                    end

                    sensors(row) = sensors(row).set_impedance_to(impedance);

                end

            end

        end

    end % methods (Static)

end % classdef
