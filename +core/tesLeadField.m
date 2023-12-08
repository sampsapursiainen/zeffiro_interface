function L = tesLeadField ( nodes, tetra, electrodes, triA, eA, e2nI, t2nI, A, params )
%
% L = tesLeadField ( nodes, tetra, gradiometers, triA, eA, e2nI, t2nI, A, params )
%
% Computes an uninterpolated gradiometric transcranial electrical stimulation lead field L.
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
