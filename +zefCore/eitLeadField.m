function L = eitLeadField ( T, invS, dAds, currentPattern )
%
% L = eitLeadField ( T, invS, dAds, currentPattern )
%
% Computes an uninterpolated gradiometric electrical impedance tomography lead field L
% for the system [ A, B ; B' C ] * [ z ; v ] = [ - Gx ; I ]
%
% Inputs:
%
% - T
%
%   A transfer matrix A \ B of the above system .
%
% - invS
%
%   The inverse of a Schur complement of A of in the above system.
%
% - dAds
%
%   The derivative of the stiffness matrix A with respect to the volume
%   conductivity.
%
% - currentPattern
%
%   The current pattern vector I of the above system.
%
% Outputs:
%
% - L
%
%   The EIT lead field.
%

    arguments
        T (:,:) double { mustBeFinite }
        invS (:,:) double { mustbeFinite }
        dAds (:,10) double { mustBeFinite }
        currentPattern (:,1) double { mustBeFinite }
    end

    L = [] ;

end % function
