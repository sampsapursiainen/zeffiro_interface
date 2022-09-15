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

        % conductivity
        %
        % Returns the conductivity computed from self.impedance.

            c = 1 / self.impedance;

        end

    end % methods

end % classdef
