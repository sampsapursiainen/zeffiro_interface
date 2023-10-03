classdef Zef < handle
%
% Zef
%
% The central data structure of Zeffiro Interface. Holds onto the data that is needed for running
% reconstruction / inverse methods on data gathered by some sensors, including the sensor
% configuration itself.
%

    properties
        %
        % A surface mesh, generated from (for example) FreeSurfer ASCII files.
        %
        surface_segmentation (1,1) core.SurfaceSegmentation = core.SurfaceSegmentation
        %
        % A tetrahedral finite element mesh.
        %
        tetra_mesh (1,1) core.TetraMesh = core.TetraMesh
        %
        % L
        %
        % A lead field matrix computed based on a set of synthetic sources and a sensor
        % configuration. The rows correspond to sensors and column correspond to the different
        % source positions.
        %
        L (1,1) core.LeadField = core.LeadField
        %
        % The electrodes used in computing the lead field, among other things.
        %
        electrodes (:,1) core.Electrode = core.Electrode.empty
        %
    end % properties

    methods

        function self = Zef ( kwargs )
        %
        % Zef ( kwargs )
        %
        % A constructor for the Zef class.
        %
        % Inputs:
        %
        % - kwargs.surface_segmentation
        %
        %   An instance of core.SurfaceSegmentation.
        %
        % - kwargs.mesh
        %
        %   An instance of core.TetraMesh. This is constructed from
        %   self.surface_segmentation.
        %
        % - kwargs.L
        %
        %   A lead field matrix constructed from a given set of synthetic sources and a sensor
        %   configuration.
        %
        % - kwargs.electrodes
        %
        %   A set of core.Electrode.
        %

            arguments

                kwargs.tetra_mesh = core.TetraMesh

                kwargs.L = core.LeadField

                kwargs.electrodes = core.Electrode.empty

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end

        end % function

    end % methods

end % classdef
