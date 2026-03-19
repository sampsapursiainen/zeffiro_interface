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

        function out = moments(self)
        %
        %   out = moments(self)
        %
        % Computes the moments of the cylinders in this set as a cross product of the start and endpoint position vectors.
        % This gives an idea of how much the cylinders are tilted and scaled with respect to a standard cylinder of identical
        % radius pointing in z-direction.
        %

            arguments
                self
            end

            out = cross(self.startPoints,self.endPoints) ;

        end % function

        function N = numel(self)
        %
        %   N = numel(self)
        %
        % Computes the number of cylinders in this set.
        %

            arguments
                self
            end

            [~, N] = size(self.startPoints) ;

        end % function

        function tetraIndices = tetraCollisions(self,points,tetra)
        %
        %   tetraIndices = tetraCollisions(self,points,tetra)
        %
        % Determines which given tetra the cylinders in self are in contact with in a vectorized manner.
        % Returns a Boolean matrix where the rows correspond cylinders|tetra and columns to cylinders|tetra.
        %

            arguments
                self
                points
                tetra
            end

            % Extract matrix sizes.

            [~, pointN] = size(points) ;

            cylinderN = self.numel ;

            % First assume that our cylinder is infinite and compute distances to center line.

            repeatedDirections = repelem(self.directions, 1, pointN) ;

            startPointDiffs = repmat(points, 1, cylinderN) - repelem(self.startPoints, 1, pointN) ;

            distancesToCenterLine = vecnorm(cross(repeatedDirections, startPointDiffs)) ./ vecnorm(repeatedDirections) ;

            repeatedRadii = repelem(self.radii,1,pointN) ;

            indicesWithinInfiniteCylinder = distancesToCenterLine < repeatedRadii ;

            % Then we discard all points which did not project onto the actual cylinder line segment.

            indicesBeforeEndpoint = dot(startPointDiffs, -repeatedDirections) <= 0

            % Finally do the same for points outside of the cylinder before its start point.

            indicesAfterStartpoint = dot(startPointDiffs, repeatedDirections) <= 0

            % Combine all restrictions to find out points within cylinders.

            indicesWithinCylinders = indicesWithinInfiniteCylinder & indicesBeforeEndpoint & indicesAfterStartpoint ;

            % Fold the index array such that the cylinderwise collisions with the points are in their respective columns.

            indicesWithinCylinders = reshape(indicesWithinCylinders, cylinderN, pointN) ;

            % TODO: compare this point-related columns of this index set with the tetra and check which node indices can be found.
            % This is true if any points of a tetrahedron lie within a cylinder.
            %
            % tetraIndices = ... ;

            error("Unimplemented!")

        end % function

    end % methods

end % classdef
