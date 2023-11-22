function C = pemVoltageMat ( impedances )
%
% C = pemVoltageMat ( impedances )
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

    eN = numel ( impedances ) ;

    % Yeah, this really is this simple, due to the related PEM integral
    %
    %   integral_electrodes psi_i dS
    %
    % converging to the value of a basis function at the electrode
    % position.

    C = sparse ( 1 : eN, 1 : eN, 1 ./ impedances, eN, eN ) ;

end % function
