function B = pemPotentialMat ( nN, impedances, e2nI )
%
% B = pemPotentialMat ( nN, impedances, e2nI )
%
% Builds a sparse electrode potential matrix B, which maps potentials from a
% given set of point electrodes (PEM) to finite element nodes. In EEG and tES
% literature, if we have a discretized finite element system
%
%   [ A -B ; -B' C ] * x = b ,
%
% then the output corresponds to B.
%
% Inputs:
%
% - nN
%
%   The number of finite element nodes in the domain we are solvng a forward
%   problem in.
%
% - impedances
%
%   The impedances of the electrodes.
%
% - e2nI
%
%   A mapping of electrode indices to node indices. In other words, e2nI(i)
%   gives the node index of the ith electrode.
%

    arguments
        nN         (1,1) double { mustBeFinite }
        impedances (:,1) double { mustBeNonNan }
        e2nI       (:,1) double { mustBePositive, mustBeInteger }
    end

    eN = numel ( impedances ) ;

    % Yeah, this really is this simple, due to the related PEM integral
    %
    %   integral_electrodes
    %     psi_i
    %     psi_j
    %   dS
    %
    % converging to the value of the basis functions at the electrode position.

    B = sparse ( e2nI, (1 : eN), 1 ./ impedances, nN, eN ) ;

end % function
