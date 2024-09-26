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

    end % methods

    methods (Static)

        % TODO: implement things like reading surface compartments from files here.

    end % methods (Static)

end % classdef
