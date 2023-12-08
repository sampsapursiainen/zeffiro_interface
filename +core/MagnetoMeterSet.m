classdef MagnetoMeterSet < core.Sensor
%
% MagnetoMeterSet < Sensor
%
% A type representing a set of magnetometers. Might be used in MEG.
%

    properties
        positions (:,3) double { mustBeFinite } % The positions of the magnetometers in this set.
    end

    methods

        function self = MagnetoMeterSet ( kwargs )
        %
        % self = MagnetoMeterSet ( kwargs )
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
