function B = potentialMat ( superNodeA, Znum, impedances, e2nI, nN )
%
% B = potentialMat ( superNodeA, Znum, impedances, e2nI )
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
% - e2nI
%
%   A mapping of electrode indices to node indices. In other words, e2nI(i)
%   gives the node index of the ith electrode.
%
% - triangles
%
%   The surface triangles that the electrodes are attached to. The relation
%   e2nI ⊂ triangles should hold.
%

    arguments
        superNodeA (1,:) double { mustBeFinite, mustBeNonnegative }
        Znum       (:,1) double { mustBeFinite }
        impedances (:,1) double { mustBeNonNan }
        e2nI       (:,1) uint32 { mustBePositive }
        nN         (1,1) uint32 { mustBePositive }
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

    Zcoeff = Znum ./ Zden ./ eN ;

    % Silently disallow zero impedances.

    Zcoeff ( Zcoeff == 0 ) = 1e3 ;

    % Take point electrodes into account according to (Agsten 2018).

    superNodeA (superNodeA <= eps) = 1 ;

    % Iterate over the electrode triangles and place the integrals multiplied
    % by the Zcoeffs into the proper node--electrode indices.

    B = sparse ( nN, eN ) ;

    for snI = uint32( 1 : eN )

        % Find node index corresponding to current electrode.

        nI = e2nI ( snI ) ;

        % Add the elements to the potential matrix.

        B = B + sparse ( nI, snI, Zcoeff (snI) * superNodeA (snI), nN, eN) ;

    end % for

end % function
