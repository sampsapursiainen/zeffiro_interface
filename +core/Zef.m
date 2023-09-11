classdef Zef < handle
%
% core.Zef
%
% The central data structure of Zeffiro Interface. Holds onto the data that is needed for running
% reconstruction / inverse methods on data gathered by some sensors, including the sensor
% configuration itself.
%

    properties
        %
        % nodes
        %
        % Triples of coordinates making up the the 3D nodes of a finite element mesh.
        %
        nodes (:,3) double { mustBeNonNan, mustBeFinite } = []
        %
        % tetra
        %
        % Quadruples of node indices of a finite element mesh, defining which nodes belong to which
        % element.
        %
        tetra (:,4) uint64 { mustBePositive } = []
        %
        % L
        %
        % A lead field matrix computed based on a set of synthetic sources and a sensor
        % configuration. The rows correspond to sensors and column correspond to the different
        % source positions.
        %
        L (1,1) core.LeadField = core.LeadField
        %
    end % properties

    methods

        function self = Zef ( kwargs )
        %
        % Zef (kwargs)
        %
        % A constructor for the Zef class.
        %

            arguments

                kwargs.nodes = []

                kwargs.tetra = []

                kwargs.L = core.LeadField

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end

        end % function

    end % methods

end % classdef
