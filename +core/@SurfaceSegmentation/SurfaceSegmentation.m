classdef SurfaceSegmentation
%
% SurfaceSegmentation
%
% An in-memory representation of a surface segmentation generated by the recon-all program of the
% FreeSurfer software suite. Zeffiro uses this as the starting point of FEM mesh generation.
%

    properties

        %
        % The nodes read in from a surface segmentation file.
        %
        nodes (:,3) double = []

        %
        % The triangles (triples of node indices) read in from a segmentation file.
        %
        triangles (:,3) uint64 = []

        %
        % The numerical labels indicating which compartment each triangle belongs to.
        %
        labels (:,1) uint64 = []

        label_names (:,1) string = string ( [] )

    end % properties

    methods

        function self = SurfaceSegmentation ( kwargs )
        %
        % SurfaceSegmentation (
        %   kwargs.nodes,
        %   kwargs.triangles,
        %   kwargs.labels,
        %   kwargs.label_names
        % )
        %
            arguments
                kwargs.nodes = []
                kwargs.triangles = []
                kwargs.labels = []
                kwargs.label_names = string ( [] )
            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end % for

        end % function

    end % methods

end % classdef