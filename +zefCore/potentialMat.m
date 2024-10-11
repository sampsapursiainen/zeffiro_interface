function B = potentialMat ( superNodes, impedances, nN, kwargs )
%
% B = potentialMat ( superNodes, impedances, nN, kwargs )
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
% - superNodes
%
%   The supernodes indicating the contact surface between the mesh and the electrodes.
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
        superNodes           (1,:) zefCore.SuperNode
        impedances           (:,1) double { mustBeNonNan }
        nN                   (1,1) uint32 { mustBePositive }
        kwargs.psiIntegral   (1,1) double { mustBePositive, mustBeFinite } = 1 / 3
        kwargs.areaThreshold (1,1) double { mustBeNonnegative } = eps
    end

    disp ( newline + "Computing potential matrix B…" ) ;

    eN = numel ( impedances ) ;

    % Impedance coefficient denominator.

    % Disallow zero impedances by setting them to unity.

    impedances ( impedances == 0 ) = 1 ;

    % Compute the impedance coefficient of the matrix ∫ ψi dS, taking into
    % account that the impedances might be infinite, or areas 0.

    Zcoeff = 1 ./ impedances ;

    % Also handle infinite impedances according to (Agsten 2018).

    Zcoeff ( isinf (impedances) ) = 1 ;

    % Iterate over the electrode triangles and place the integrals multiplied
    % by the Zcoeffs into the proper node--electrode indices.

    B = sparse ( nN, eN ) ;

    for snI = uint32 (1 : eN)

        % Find out the nodes that this supernode is made of and its area. If
        % the area of the supernode is too small, it is interpreted as a point
        % electrode and only the supernode center will be used (Agsten 2018).

        totalArea = superNodes (snI) . totalSurfaceArea ;

        isPointElectrode = totalArea <= kwargs.areaThreshold ;

        superNodeCenter = superNodes (snI) . centralNodeI ;

        if isPointElectrode

            nodeI = superNodeCenter ;
            totalArea = 1 ;
            triArea = 1 ;
            maxVertexI = 1 ;

        else

            nodeI = superNodes (snI) . surfaceTriangles ;
            totalArea = totalArea ;
            triArea = superNodes (snI) . surfaceTriangleAreas ;
            maxVertexI = 3 ;

        end % if

        % Distribute the impedance to the node positions in B.

        entry = kwargs.psiIntegral * Zcoeff (snI) / totalArea .* triArea ;

        for vi = 1 : maxVertexI

            vertexI = nodeI (vi,:) ;

            B = B + sparse ( vertexI, snI, entry, nN, eN) ;

        end % for

    end % for

end % function
