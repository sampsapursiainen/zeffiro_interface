classdef Electrode < zefCore.Sensor
%
% Electrode < Sensor
%
% A type representing active or a passive electrodes. Might be used in EEG, EIT
% and tES tomography.
%

    properties
        position    (1,3) double { mustBeFinite } = [0 0 0]
        innerRadius (1,1) double { mustBeFinite } = 0
        outerRadius (1,1) double { mustBeFinite } = 10
        impedance   (1,1) double { mustBeNonNan } = Inf
    end

    methods

        function self = Electrode ( kwargs )
        %
        % self = Electrode ( kwargs )
        %
        % A constructor for this class. All properties are passed as keyword arguments.
        %

            arguments
                kwargs.position    = [0 0 0]
                kwargs.innerRadius = 0
                kwargs.outerRadius = 10
                kwargs.impedance   = Inf
            end

            fields = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fields )
                self.(fields(fni)) = kwargs.(fields(fni)) ;
            end

        end % function

    end % methods

end % classdef
