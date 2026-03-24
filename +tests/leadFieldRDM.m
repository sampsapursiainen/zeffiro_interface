function RDM = leadFieldRDM (L1,L2)
%
% RDM = leadFieldRDM (L1,L2)
%
% Computes a relative difference measure
%
%   RDM = ‖ L1 / ‖L1‖ - L2 / ‖L2‖ ‖
%
% between two given lead fields.
%

    arguments
        L1 (:,:) double { mustBeFinite }
        L2 (:,:) double { mustBeFinite }
    end

    vecNormL1 = vecnorm (L1) ;

    vecNormL2 = vecnorm (L2) ;

    normedL1 = L1 ./ vecNormL1 ;

    normedL2 = L2 ./ vecNormL2 ;

    matDiff = normedL1 - normedL2 ;

    RDM = vecnorm (matDiff) ;

end % function
