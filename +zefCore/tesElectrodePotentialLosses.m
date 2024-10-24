function U = tesElectrodePotentialLosses (I,S)
%
% U = tesElectrodePotentialLosses (I,S)
%
% Computes the potential losses over tES electrodes, when
% the injected current pattern I and the Schur complement S
% of A in the system
%
%   [A -B ; -B' C ] * [y U] = [ 0 ; I ]
%
% is known.
%

    arguments
        I (:,1) double { mustBeFinite }
        S (:,:) double { mustBeFinite }
    end

    U = - S * I ;

end % function
