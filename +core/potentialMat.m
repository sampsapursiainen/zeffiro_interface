function B = potentialMat ( superNodeCenters, superNodeTriangles, superNodeTriAreas, superNodeSurfArea, Znum, impedances, nN, kwargs )
%
% B = potentialMat ( superNodeCenters, superNodeTriangles, superNodeTriAreas, superNodeSurfArea, Znum, impedances, nN, kwargs )
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
% - superNodeCenters
%
%   The indices of the supernode centers.
%
% - superNodeTriangles (1,:) cell
%
%   Triples of node indices indicating which nodes supernode surfaces are composed of.
%
% - superNodeTriAreas
%
%   Areas of the individual supernode surface triangles per supernode.
%
% - superNodeSurfArea
%
%   The total surface areas of the supernodes whose centers the electrodes are
%   associated with.
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
% - nN
%
%   The number of finite element nodes in the mesh.
%
% - kwargs.psiIntegral = 1 / 3
%
%   The value of ∫ ψi dS over the face of a tetrahedron.
%
% - kwargs.areaThreshold = eps
%
%   The threshold, below which an electrode will be interpreted as a point electrode.
%

    arguments
        superNodeCenters     (1,:) uint32 { mustBePositive }
        superNodeTriangles       (1,:) cell
        superNodeTriAreas     (1,:) cell
        superNodeSurfArea    (1,:) double { mustBeFinite, mustBeNonnegative }
        Znum                 (:,1) double { mustBeFinite }
        impedances           (:,1) double { mustBeNonNan }
        nN                   (1,1) uint32 { mustBePositive }
        kwargs.psiIntegral   (1,1) double { mustBePositive, mustBeFinite } = 1 / 3
        kwargs.areaThreshold (1,1) double { mustBeNonnegative } = eps
    end

    disp ("Computing potential matrix B…")

    eN = numel ( impedances ) ;

    % Impedance coefficient denominator.

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj ( impedances ) .* impedances ;
    end

    % Disallow zero impedances by setting them to unity.

    Zden ( Zden == 0 ) = 1 ;

    % Compute the impedance coefficient of the matrix ∫ ψi dS, taking into
    % account that the impedances might be infinite, or areas 0.

    Zcoeff = Znum ./ Zden ./ eN ;

    % Also handle infinite impedances according to (Agsten 2018).

    Zcoeff ( isinf (Zden) ) = 1 ;

    % Iterate over the electrode triangles and place the integrals multiplied
    % by the Zcoeffs into the proper node--electrode indices.

    B = sparse ( nN, eN ) ;

    mf = matfile("newB.mat",Writable=true) ;

    for snI = uint32 (1 : eN)

        % Find out the nodes that this supernode is made of and its area. If
        % the area of the supernode is too small, it is interpreted as a point
        % electrode and only the supernode center will be used (Agsten 2018).

        isPointElectrode = superNodeSurfArea (snI) <= kwargs.areaThreshold ;

        superNodeCenter = superNodeCenters (snI) ;

        if isPointElectrode

            nodeI = superNodeCenter ;
            totalArea = 1 ;
            triArea = 1 ;

        else

            nodeI = superNodeTriangles {snI} ;
            totalArea = superNodeSurfArea (snI) ;
            triArea = superNodeTriAreas {snI} ;

        end % if

        % Distribute the impedance to the node positions in B.

        entry = kwargs.psiIntegral * Zcoeff (snI) / totalArea .* triArea ;

        mf.("entry"+snI) = entry ;

        for vi = 1 : 3

            vertexI = nodeI (vi,:) ;

            B = B + sparse ( vertexI, snI, entry, nN, eN) ;

        end % for

    end % for

    mf.B = B ;

end % function
