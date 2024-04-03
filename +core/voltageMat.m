function C = voltageMat ( Znum, impedances )
%
% C = pemVoltageMat ( Znum, impedances )
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
% - Znum
%
%   The numerator in the expression Z / (conj(Z) * Z), if the input impedances
%   are complex. If the impedances are real, this should equal 1.
%
% - impedances
%
%   The impedances of the electrodes.
%

    arguments
        Znum (:,1) double { mustBeNonNan }
        impedances (:,1) double { mustBeNonNan }
    end

    eN = numel ( impedances ) ;

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj(impedances) .* impedances ;
    end

    % Disallow zero impedances by setting them to unity.

    Zden ( Zden == 0 ) = 1 ;

    C = sparse ( 1 : eN, 1 : eN, Znum ./ Zden, eN, eN ) ;

end % function
