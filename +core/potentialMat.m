function B = potentialMat ( nN, Znum, impedances, triA, eA, e2nI, t2nI )
%
% B = potentialMat ( nN, Znum, impedances, triA, eA, e2nI, t2nI )
%
% Builds a sparse electrode potential matrix B, which maps potentials from a
% given set of electrodes to finite element nodes. In EEG and tES literature,
% if we have a discretized finite element system
%
%   [ A -B ; -B' C ] * x = b ,
%
% then the output corresponds to B.
%
% Inputs:
%
% - nN
%
%   The number of finite element nodes in the mesh.
%
% - Znum
%
%   The numerator of the impedance coefficient. If impedances are real, this
%   should be one, otherwise this should be the real or imaginary part of the
%   impedance.
%
% - impedances
%
%   The impedances of the electrodes. Either real or complex.
%
% - triA
%
%   The areas of the triangles that the electrode nodes are touching.
%
% - eA
%
%   The average area of the electrodes.
%
% - e2nI
%
%   A mapping of electrode indices to node indices. In other words, e2nI(i)
%   gives the node index of the ith electrode.
%
% - t2nI
%
%   A mapping of triangle indices to node indices. In other words, t2nI(i)
%   gives the node that the triangle triangles(:,i) participates in.
%

    arguments
        nN         (:,1) double { mustBePositive, mustBeInteger }
        Znum       (:,1) double { mustBeFinite }
        impedances (:,1) double { mustBeNonNan }
        triA       (:,1) double { mustBeFinite }
        eA         (:,1) double { mustBeFinite }
        e2nI       (:,1) uint32 { mustBePositive }
        t2nI       (:,1) uint32 { mustBePositive }
    end

    eN = numel ( impedances ) ;

    % Impedance coefficient denominator.

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj ( impedances ) .* impedances ;
    end

    % Compute the impedance coefficient of the matrix ∫ ψi dS, taking into
    % account that the impedances might be infinite, or areas 0.

    Zcoeff = Znum ./ Zden ./ eA ;

    % Adjust the coefficients in places that have point electrodes: if area is
    % zero or impedance is infinite.

    peI = isinf ( Zcoeff ) | Zcoeff == 0 ;

    Zcoeff ( peI ) = 1 ;

    % Iterate over the electrode triangles and place the integrals multiplied
    % by the Zcoeffs into the proper node--electrode indices.

    B = sparse ( nN, eN ) ;

    for eI = 1 : eN

        % Find node index corresponding to current electrode.

        nI = e2nI ( eI ) ;

        % Find triangles that are touching this node.

        triI = nI == t2nI ;

        % Sum up their areas.

        sumA = sum ( triA ( triI ) ) ;

        % Add the elements to the potential matrix.

        B = B + sparse ( nI, eI, Zcoeff ( eI ) * sumA, nN, eN) ;

    end % for

end % function
