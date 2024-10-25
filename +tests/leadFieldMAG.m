function MAG = leadFieldMAG (L1,L2)
%
% MAG = leadFieldMAG (L1,L2)
%
% Computes a magnitude measure
%
%   MAG = ‖ 1 - ‖L1‖ / ‖L2‖ ‖
%
% between two given lead fields.
%

    arguments
        L1 (:,:) double { mustBeFinite }
        L2 (:,:) double { mustBeFinite }
    end

    colNormL1 = vecnorm (L1) ;

    colNormL2 = vecnorm (L2) ;

    MAG = vecnorm ( 1 - colNormL1 / colNormL2 ) ;

end % function
