function L = megLeadField ( nodes, tetra, magnetometers, triA, eA, e2nI, t2nI, A, params )
%
% L = megLeadField ( nodes, tetra, gradiometers, triA, eA, e2nI, t2nI, A, params )
%
% Computes an uninterpolated magnetoencephalography lead field L.
%
    arguments
        nodes         (:,3) double { mustBeFinite }
        tetra         (:,4) double { mustBePositive, mustBeInteger }
        magnetometers (:,1) core.MagnetoMeterSet
        triA          (:,1) double { mustBePositive }
        e2nI          (:,1) double { mustBePositive, mustBeInteger }
        t2nI          (:,1) double { mustBePositive, mustBeInteger }
        A             (:,:) double { mustBeFinite }
        params        (1,1) core.LeadFieldParams = core.LeadFieldParams
    end

    L = [] ;

end % function
