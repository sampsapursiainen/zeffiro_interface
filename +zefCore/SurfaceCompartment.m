classdef SurfaceCompartment
%
% SurfaceCompartment
%
% A class whose objects hold onto data related to a single compartment of a surface segmentation.
%

    properties
        name (1,1) string = "" % The name of this compartment
        points (3,:) double { mustBeFinite } = [] % The points that this surface consists of.
        triangles (3,:) double { mustBePositive, mustBeInteger } = [] % Triangular elements of this surface, that can be used to index into self.points.
        parameters (1,1) struct = struct % The parameters related to this compartment in a struct.
    end % properties

    methods

        function self = SurfaceCompartment (kwargs)
        %
        % self = SurfaceCompartment (kwargs)
        %
        % A constructor of this class. All properties are given as keyword arguments.
        %

            arguments
                kwargs.name = ""
                kwargs.points = []
                kwargs.triangles = []
                kwargs.parameters = struct
            end

            fieldNames = string ( fieldnames (kwargs) ) ;

            fieldN = numel (fieldNames) ;

            for ii = 1 : fieldN

                fieldName = fieldNames (ii) ;

                self.(fieldName) = kwargs.(fieldName) ;

            end % for ii

        end % function

        function N = pointCount (self)
        %
        % N = pointCount (self)
        %
        % Returns the number of points within self.
        %

            N = size (self.points, 2) ;

        end % function

        function N = triangleCount (self)
        %
        % N = triangleCount (self)
        %
        % Returns the number of triangles within self.
        %

            N = size (self.triangles,2) ;

        end % function

        function self = mergeWith (self, otherCompartments)
        %
        % self = mergeWith (self, otherCompartments)
        %
        % Merges self with a set of given compartments.
        %
            arguments
                self
                otherCompartments (:,1) zefCore.SurfaceCompartment
            end

            % First count the space required for the new merged compartment.

            triangleN = self.triangleCount ;

            pointN = self.pointCount ;

            cN = numel (otherCompartments) ;

            for ii = 1 : cN

                ci = otherCompartments (ii) ;

                pointN = pointN + ci.pointCount ;

                triangleN = triangleN + ci.triangleCount ;

            end % for ii

            % Preallocate arrays for writing and store data from self to output start.

            points = zeros (3,pointN) ;

            triangles = zeros (3,triangleN) ;

            points (:,1:self.pointCount) = self.points ;

            triangles (:,1:self.triangleCount) = self.triangles ;

            % Write other compartment data into the arrays, keeping the
            % triangle indices updated, as those of indivifual compartments
            % refer to nodes within that compartment.

            pointRangeStart = self.pointCount + 1 ;

            triangleRangeStart = self.triangleCount + 1 ;

            triangleUpdateI = self.triangleCount - 1 ;

            for ii = 1 : cN

                ci = otherCompartments (ii) ;

                pointRangeEnd = pointRangeStart + ci.pointCount - 1 ;

                triangleRangeEnd = triangleRangeStart + ci.triangleCount - 1 ;

                points (:, pointRangeStart:pointRangeEnd) = ci.points ;

                triangles (:, triangleRangeStart:triangleRangeEnd) = ci.triangles + pointRangeStart - 1 ;

                pointRangeStart = pointRangeEnd + 1 ;

                triangleRangeStart = triangleRangeEnd + 1 ;

            end % for ii

            % TODO: also merge parameters before calling constructor.

            self = zefCore.SurfaceCompartment (name=self.name, points=points, triangles=triangles, parameters=struct) ;

        end % function

    end % methods

    methods (Static)

        function self = fromFreeSurferASCIIFile (filePath, kwargs)
        %
        % self = fromFreeSurferASCIIFile (filePath)
        %
        % Reads a given FreeSurfer-generated surface segmentation ASCII file
        % and generates a compartment based on it.
        %

            arguments
                filePath (1,1) string { mustBeFile }
                kwargs.name (1,1) string = ""
                kwargs.fileID (1,1) double { mustBePositive, mustBeInteger } = 1
            end

            fileLines = readlines (filePath) ;

            lineN = numel (fileLines) ;

            countsLine = 2 ;

            fieldSeparator = " " ;

            countStrs = strsplit ( fileLines (countsLine), fieldSeparator) ;

            nodeN = double ( countStrs (1) ) ;

            triangleN = double ( countStrs (2) ) ;

            nodeStartLine = countsLine + 1 ;

            nodeEndLine = nodeStartLine + nodeN - 1 ;

            triangleStartLine = nodeEndLine + 1 ;

            triangleEndLine = lineN - 1 ;

            fprintf (kwargs.fileID, newline + "Reading points from file " + filePath + ":" +newline ) ;

            points = zeros (3,nodeN) ;

            for ii = nodeStartLine : nodeEndLine

                nodeI = ii - countsLine ;

                zefCore.dispProgress ( nodeI, nodeEndLine-countsLine, fileDescriptor=kwargs.fileID ) ;

                line = fileLines (ii) ;

                coords = double ( strsplit (line, fieldSeparator) ) ;

                points (:,nodeI) = coords (1:3) ;

            end % for ii

            fprintf (kwargs.fileID, newline + "Reading triangles from file " + filePath + ":" +newline ) ;

            triangles = zeros (3,triangleN) ;

            for ii = triangleStartLine : triangleEndLine

                triI = ii - nodeN - countsLine ;

                zefCore.dispProgress ( triI, triangleEndLine - nodeN - countsLine, fileDescriptor=kwargs.fileID ) ;

                line = fileLines (ii) ;

                triangle = double ( strsplit (line, fieldSeparator) ) ;

                triangles (:,triI) = triangle (1:3) ;

            end % for ii

            if strlength (kwargs.name) == 0

                [fileStem, fileName, fileExtension] = fileparts (filePath) ;

                usedName = fileName ;

            else

                usedName = kwargs.name ;

            end % if

            % FreeSurfer uses zero-based indexing.

            triangles = triangles + 1 ;

            self = zefCore.SurfaceCompartment ( name = usedName, points=points,triangles=triangles ) ;

        end % function

        % TODO: implement things like reading surface compartments from files here.

    end % methods (Static)

end % classdef
