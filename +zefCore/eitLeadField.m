function L = eitLeadField ( T, dAds, R, currentPattern, activeI, nodeI )
%
% L = eitLeadField ( T, invS, dAds, R, currentPattern, nodeI )
%
% Computes an uninterpolated gradiometric electrical impedance tomography lead field L
% for the system [ A, B ; B' C ] * [ z ; v ] = [ - Gx ; I ].
%
% See https://doi.org/10.1007/s12021-019-09436-9 for details.
%
% Inputs:
%
% - T
%
%   A transfer matrix A \ B of the above system .
%
% - dAds
%
%   The derivative of the stiffness matrix A with respect to the volume
%   conductivity.
%
% - R
%
%   A mapping from v = invS * I to the zero-mean potential vector u, or u = Rv.
%
% - currentPattern
%
%   The current pattern vector I of the above system.
%
% - activeI
%
%   The indices of the elements into which sources are to be positioned.
%
% - nodeI
%
%   The node incides of the elements indicated by activeI.
%
% Outputs:
%
% - L
%
%   The EIT lead field.
%

    arguments
        T (:,:) double { mustBeFinite }
        dAds (:,10) double { mustBeFinite }
        R (:,:) double { mustBeFinite }
        currentPattern (:,1) double { mustBeFinite }
        activeI (:,1) double { mustBeInteger, mustbeFinite, mustbePositive }
        nodeI (:,4) double { mustBeInteger, mustbeFinite, mustbePositive }
    end

    disp ( newline + "Building linearized EIT lead field:" + newline ) ;

    cpN = numel (currentPattern) ;

    activeN = numel (activeI) ;

    L = zeros (cpN,activeN) ;

    for ii = 1 : activeN

        zefCore.dispProgress (ii,activeN) ;

        aI = activeI (ii) ;

        iidAdsVec = dAds (aI,:);

        dDiagonal = [
            iidAdsVec(1) 0 0 0 ;
            0 iidAdsVec(5) 0 0 ;
            0 0 iidAdsVec(8) 0 ;
            0 0 0 iidAdsVec(10)
        ] ;

        dOffDiagonal = [
            0 iidAdsVec(2) iidAdsVec(3) iidAdsVec(4) ;
            0 0 iidAdsVec(6) iidAdsVec(7) ;
            0 0          0 iidAdsVec(9) ;
            0 0 0 0
        ] ;

        iidAdsMat = dDiagonal + dOffDiagonal + transpose (dOffDiagonal);

        iiNodeI = nodeI (ii,:);

        iiT = T (:, iiNodeI) ;

        % L = - R * invS * transpose (B) * inv(A) * dAds * T * invS * currentPattern ;

        iiL = - R * iiT * iidAdsMat * transpose (iiT) * currentPattern ;

        L (:,ii) = L (:,ii) + iiL (:);

    end % for ii

end % function
