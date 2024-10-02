function C = impedanceMat ( impedances )
%
% C = impedanceMat ( impedances )
%
% Builds a sparse electrode voltage matrix C, which contains the ungrounded
% voltages of a given set of point electrodes (PEM) to finite element nodes. In
% EEG and tES literature, if we have a discretized finite element system
%
%   [ A -B ; -B' C ] * x = b ,
%
% then the output corresponds to C.
%
% Inputs:
%
% - impedances
%
%   The impedances of the electrodes.
%

    arguments
        impedances (:,1) double { mustBeNonNan }
    end

    disp ( newline + "Computing impedance matrix C…" ) ;

    eN = numel ( impedances ) ;

    % Disallow zero impedances by setting them to unity.

    impedances ( impedances == 0 ) = 1 ;

    Zcoeff = 1 ./ impedances ;

    % Also handle infinite impedances according to (Agsten 2018).

    Zcoeff ( isinf (impedances) ) = 1 ;

    C = sparse ( 1 : eN, 1 : eN, Zcoeff, eN, eN ) ;

end % function
