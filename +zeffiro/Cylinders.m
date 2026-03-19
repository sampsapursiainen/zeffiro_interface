classdef Cylinders
%
%   object = Cylinders(kwargs)
%
% An object representing a set of cylinders.
%

    properties
        startPoints (3,:) double { mustBeFinite } = []
        endPoints (3,:) double { mustBeFinite } = []
        radii (1,:) double { mustBeFinite, mustBeNonnegative } = []
    end

    methods

        function self = Cylinders(kwargs)
        %
        %   self = Cylinders(kwargs) ;
        %
        % A constructor for this class.
        %
            arguments
                kwargs.startPoints = []
                kwargs.endPoints = []
                kwargs.radii = []
            end

            assert( ...
                all(size(kwargs.startPoints) == size(kwargs.endPoints)), ...
                "The number of cylinder start points did not match that of cylinder endpoints." ...
            )

            assert( ...
                size(kwargs.startPoints,2) == numel(kwargs.radii), ...
                "The number of cylinder start points did not match the number of radii." ...
            )

            fieldNames = string(fieldnames(kwargs)) ;

            for ii = 1 : numel(fieldNames)

                fn = fieldNames(ii) ;

                self.(fn) = kwargs.(fn) ;

            end % for

        end % function

        function self = plus(self, point)
        %
        %   self = add(self, point)
        %
        % Defines addition of points and cylinders.
        % Essentially amounts to translation of the cylinder.
        %

            arguments
                self
                point (3,:) double
            end

            self = zeffiro.Cylinders( ...
                startPoints = self.startPoints + point, ...
                endPoints = self.endPoints + point, ...
                radii = self.radii ...
            ) ;

        end % function

        function self = uplus(self)
        %
        %   self = uplus(self)
        %
        % A unary plus is a no-op in case of cylinders.
        %
            arguments
                self
            end

            self = self ;

        end % function

        function self = minus(self,point)
        %
        %   self = minus(self,point)
        %
        % Allows subtracting a point from a cylinder.
        % Amounts to translating a cylinder.
        %
            arguments
                self
                point (3,:) double
            end

            self = zeffiro.Cylinders( ...
                startPoints = self.startPoints - point, ...
                endPoints = self.endPoints - point, ...
                radii = self.radii ...
            ) ;

        end % function

        function self = uminus(self)
        %
        %   self = uminus(self)
        %
        % Reverses a cylinder with the syntax -self.
        %
            arguments
                self
            end

            self = zeffiro.Cylinders( ...
                startPoints = self.endPoints, ...
                endPoints = self.startPoints, ...
                radii = self.radii ...
            ) ;

        end % function

        function out = directionVectors(self)
        %
        %   out = directionVectors(self)
        %
        % Computes the direction vectors of this set of cylinders.
        %

            arguments
                self
            end

            out = self.endPoints - self.startPoints ;

        end % function

        function out = lengths(self)
        %
        %   out = lenghts(self)
        %
        % Computes the lenghts of this set of cylinders.
        %

            arguments
                self
            end

            out = vecnorm(self.directionVectors) ;

        end % function

        function out = lengthsSquared(self)
        %
        %   out = lenghtsSquared(self)
        %
        % Computes the squared lengths of this set of cylinders.
        %

            arguments
                self
            end

            directions = self.directionVectors ;

            out = dot(directions,directions) ;

        end % function

    end % methods

end % class
