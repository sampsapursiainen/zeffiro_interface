classdef GradioMeterSet < core.Sensor
%
% GradioMeterSet < Sensor
%
% A type representing a set of gradiometers. Might be used in gMEG.
%

    properties
        positions (:,3) double { mustBeFinite } % The positions of the gradiometers in this set.
    end

    methods

        function self = GradioMeterSet ( kwargs )
        %
        % self = GradioMeterSet ( kwargs )
        %
        % A constructor for this class. All properties are passed as keyword
        % arguments.
        %

            arguments
                kwargs.positions  = []
            end

            fields = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fields )

                field = fields ( fni ) ;

                self.(field) = kwargs.(field) ;

            end % for

        end % function

    end % methods

end % classdef
