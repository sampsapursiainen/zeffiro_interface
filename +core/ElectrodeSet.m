classdef ElectrodeSet < core.Sensor
%
% ElectrodeSet < Sensor
%
% A type representing a set of active or a passive electrodes. Might be used in
% EEG, EIT and tES tomography.
%

    properties
        positions  (:,3) double { mustBeFinite }      = [0 0 0]
        innerRadii (:,1) double { mustBeFinite }      = 0
        outerRadii (:,1) double { mustBeFinite }      = 10
        impedances (:,1) double { mustBeNonnegative } = Inf
    end

    methods

        function self = ElectrodeSet ( kwargs )
        %
        % self = ElectrodeSet ( kwargs )
        %
        % A constructor for this class. All properties are passed as keyword
        % arguments.
        %

            arguments
                kwargs.positions  = [0 0 0]
                kwargs.innerRadii = 0
                kwargs.outerRadii = 10
                kwargs.impedances = Inf
            end

            sensorN = size ( kwargs.positions, 1 ) ;

            assert ( ...
                isscalar ( kwargs.impedances ) || numel ( kwargs.impedances ) == sensorN, ...
                "The number of given impedances must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                isscalar ( kwargs.innerRadii ) || numel ( kwargs.innerRadii ) == sensorN, ...
                "The number of given inner radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                isscalar ( kwargs.outerRadii ) || numel ( kwargs.outerRadii ) == sensorN, ...
                "The number of given outer radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                isscalar ( kwargs.impedances ) || numel ( kwargs.impedances ) == sensorN, ...
                "The number of given outer radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            fields = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fields )

                field = fields ( fni ) ;

                self.(field) = kwargs.(field) ;

            end % for

        end % function

    end % methods

end % classdef
