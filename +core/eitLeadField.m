function L = eitLeadField ( nodes, tetra, electrodes, triA, eA, e2nI, t2nI, A, params )
%
% L = eitLeadField ( nodes, tetra, gradiometers, triA, eA, e2nI, t2nI, A, params )
%
% Computes an uninterpolated gradiometric electrical impedance tomography lead field L.
%
% Outputs:
%
% - L
%
%   The EIT lead field. If the impedances Z of the electrodes were complex,
%   this will contain 2 pages: the first contains a lead field corresponding to
%   the real part and the second page will correspond to the imaginary part of
%   Z.
%

    arguments
        nodes      (:,3) double { mustBeFinite }
        tetra      (:,4) double { mustBePositive, mustBeInteger }
        electrodes (:,1) core.ElectrodeSet
        triA       (:,1) double { mustBePositive }
        e2nI       (:,1) double { mustBePositive, mustBeInteger }
        t2nI       (:,1) double { mustBePositive, mustBeInteger }
        A          (:,:) double { mustBeFinite }
        params     (1,1) core.LeadFieldParams = core.LeadFieldParams
    end

    L = [] ;

end % function
