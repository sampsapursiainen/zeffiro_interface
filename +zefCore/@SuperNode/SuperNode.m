classdef SuperNode
%
% SuperNode
%
% A supernode in a finite element mesh is a structure that holds onto a central
% mesh node index, a set of finite elements around the central node and the
% surface of the volume defined by the elements. This could represent the
% contact surface of a sensor with a finite element domain, for example.
%

    properties
        centralNodeI         (1,1) uint32 { mustBeNonnegative } = 0  % A central node of this supernode.
        centralNodePos       (3,:) double { mustBeFinite }      = [] % The positions of the central node indices, after having been attached to a mesh.
        radius               (1,1) double { mustBeNonnegative } = 0  % A radius of the largest sphere that is entirely contained in this supernode.
        meshElements         (:,:) uint32 { mustBePositive }    = [] % Elements such as triangles or tetrahedra around the central node.
        indInElements        (:,:) logical                      = [] % A logical array whose columns indicate which nodes in corresponding elements are within kwargs.radius of the supernode center.
        surfaceTriangles     (3,:) uint32 { mustBePositive }    = [] % The surface of the volume defined by elements.
        surfaceTriangleAreas (1,:) double { mustBeNonnegative } = [] % Areas of the surface triangles.
        totalSurfaceArea     (1,1) double  { mustBeNonnegative } = 0 % The total area of the surface triangles.
    end % properties

    methods

        function self = SuperNode (kwargs)
        %
        % SuperNode
        %
        % A constructor for this class. Keyword arguments with default values
        % handle the no input argument case required by MATLAB.
        %

            arguments
                kwargs.centralNodeI = 0
                kwargs.centralNodePos = []
                kwargs.meshElements = []
                kwargs.indInElements = []
                kwargs.surfaceTriangles = []
                kwargs.surfaceTriangleAreas = []
                kwargs.totalSurfaceArea = 0
            end

            fieldNames = string ( fieldnames (kwargs) ) ;

            for fni = 1 : numel (fieldNames)

                fieldName = fieldNames (fni) ;

                self.(fieldName) = kwargs.(fieldName) ;

            end % for

        end % function

        function self = computeSurfaceAreas (self,meshNodes)
        %
        % self = computeSurfaceAreas (self,meshNodes)
        %
        % Computes the surface areas of self.surfaceTriangles and returns a
        % modified instance of self.
        %

            arguments
                self
                meshNodes (3,:) double { mustBeFinite }
            end

            [ self.surfaceTriangleAreas, ~ ] = zefCore.triangleAreas (meshNodes,self.surfaceTriangles) ;

        end % function

        function self = attachToMesh (self,meshNodes)
        %
        % self = attachToMesh (self,meshNodes)
        %
        % Recomputes self.centralNode{I,Pos} based on given meshNodes.
        %

            arguments
                self
                meshNodes (3,:) double { mustBeFinite }
            end

            [self.centralNodePos, self.centralNodeI] = zefCore.attachSensors (self.centralNodePos,meshNodes,[]) ;

        end

        function self = computeTotalSurfaceArea (self)
        %
        % area = computeTotalSurfaceArea (self)
        %
        % Computes the total surface area of the surface triangles in this supernode.
        %

            arguments
                self
            end

            self.totalSurfaceArea = sum (self.surfaceTriangleAreas) ;

        end % function

    end % methods

    methods (Static)

        function self = fromMeshAndPos (meshNodes,meshElements,superNodePos,kwargs)
        %
        % self = fromMeshAndPos (meshNodes,meshElements,superNodePos,kwargs)
        %
        % Constructs a vector of SuperNodes by attaching a set of superNodePos
        % to a given mesh, by finding their nearest nodes in the mesh.
        %

            arguments
                meshNodes            (3,:) double { mustBeFinite }
                meshElements         (4,:) uint32 { mustBePositive }
                superNodePos         (3,:) double { mustBeFinite }
                kwargs.nodeRadii     (1,:) double { mustBeNonnegative, mustBeFinite } = 0
                kwargs.attachNodesTo (1,1) string { mustBeMember(kwargs.attachNodesTo,["surface","volume"]) } = "volume"
            end

            disp ( newline + "Constructing mesh (" + kwargs.attachNodesTo + ") SuperNodes... ")

            % Extract array sizes.

            superNodeN = size (superNodePos,2) ;

            % Expand radii to the number of nodes, if given as a scalar.

            if isscalar (kwargs.nodeRadii)

                nodeRadii = repmat ( kwargs.nodeRadii, 1, superNodeN ) ;

            else

                nodeRadii = kwargs.nodeRadii ;

            end % if

            % Preallocate vector of objects with default property values.

            superNodes (superNodeN) = zefCore.SuperNode ;

            % Find supernode centers.

            if kwargs.attachNodesTo == "volume"

                [centralNodePos, centralNodeIs] = zefCore.attachSensors (superNodePos,meshNodes,[]);

                sNodeElements = meshElements ;

            else % use surface triangles.

                % First find surface triangles and their coordinates.

                surfTri = transpose ( zefCore.tetraSurfaceTriangles (meshElements') ) ;

                surfTriCoords = meshNodes (:,surfTri) ;

                % Then attach supernodes to surface triangles and map the result to global node indices.

                [centralNodePos, centralNodeIs] = zefCore.attachSensors (superNodePos, surfTriCoords, []);

                centralNodeIs = surfTri (centralNodeIs) ;

                sNodeElements = surfTri ;

            end % if

            % Compute and set properties for all supernodes.

            for ii = 1 : superNodeN

                zefCore.dispProgress (ii, superNodeN) ;

                nI = centralNodeIs (ii) ;

                superNodes (ii) . centralNodeI = nI ;

                superNodes (ii) . centralNodePos = centralNodePos (:,ii) ;

                radius = nodeRadii (ii) ;

                superNodes (ii) . radius = radius ;

                [whichElements,surfTri,indInElements] = zefCore.superNode (sNodeElements,nI,radius=radius,nodes=meshNodes') ;

                superNodes (ii) . indInElements = indInElements ;

                superNodes (ii) . meshElements = whichElements ;

                superNodes (ii) . surfaceTriangles = surfTri ;

                [superNodes(ii).surfaceTriangleAreas, ~] = zefCore.triangleAreas (meshNodes,surfTri) ;

                superNodes (ii) = superNodes (ii) . computeTotalSurfaceArea ;

            end % for

            self = superNodes ;

        end % function

    end % methods (Static)

end % classdef SuperNode
