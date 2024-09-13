function L = megLeadField ( nodes, tetra, magnetometers, triA, eA, e2nI, t2nI, A, params )
%
% L = megLeadField ( nodes, tetra, gradiometers, triA, eA, e2nI, t2nI, A, params )
%
% Computes an uninterpolated magnetoencephalography lead field L.
%
% Outputs:
%
% - L
%
%   The MEG lead field. If the parameters P of the magnotemeters were complex,
%   this will contain 2 pages: the first contains a lead field corresponding to
%   the real part and the second page will correspond to the imaginary part of
%   P.
%
    arguments
        nodes         (:,3) double { mustBeFinite }
        tetra         (:,4) double { mustBePositive, mustBeInteger }
        magnetometers (:,1) zefCore.MagnetoMeterSet
        triA          (:,1) double { mustBePositive }
        e2nI          (:,1) double { mustBePositive, mustBeInteger }
        t2nI          (:,1) double { mustBePositive, mustBeInteger }
        A             (:,:) double { mustBeFinite }
        params        (1,1) zefCore.LeadFieldParams = zefCore.LeadFieldParams
    end

    L = [] ;

end % function
