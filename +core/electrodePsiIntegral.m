function Bs = electrodePsiIntegral (Nn,superNodes,kwargs)
%
% Bs = electrodePsiIntegral (Nn,superNodes,kwargs)
%
% Assembles a matrix of integrals
%
%   ∫ ψᵢ dS
%
% over each electrode--mesh contact surface, represented by the surface
% triangles of the given supernodes.
%
% Inputs:
%
% - Nn
%
%   The number of rows in the output matrix.
%
% - superNodes
%
%   Contain the contact surfaces between the FE mesh and the electrodes.
%
% - kwargs.areaThreshold = eps
%
%   The threshold, below which an electrode will be interpreted as a point electrode.
%
%

    arguments
        Nn (1,1) double { mustBeInteger, mustBePositive }
        superNodes (1,:) core.SuperNode
        kwargs.areaThreshold (1,1) double { mustBeReal, mustBePositive, mustBeFinite } = eps
    end

    % Number of electrode contact surfaces.

    Ne = numel (superNodes) ;

    % This is the value of the integral over the surface triangle of a standard
    % tetrahedron.

    psiIntegral = 1 / 3 ;

    % Place integral values scaled by areas into the output matrix.

    Bs = cell (Ne,1) ;

    for snI = uint32 (1 : Ne)

        Bs {snI} = sparse (Nn, Ne) ;

        % Find out the nodes that this supernode is made of and its area. If
        % the area of the supernode is too small, it is interpreted as a point
        % electrode and only the supernode center will be used (Agsten 2018).

        totalArea = superNodes (snI) . totalSurfaceArea ;

        isPointElectrode = totalArea <= kwargs.areaThreshold ;

        superNodeCenter = superNodes (snI) . centralNodeI ;

        if isPointElectrode

            nodeI = superNodeCenter ;
            triArea = 1 ;
            totalArea = 1 ;
            maxVertexI = 1 ;

        else

            nodeI = superNodes (snI) . surfaceTriangles ;
            triArea = superNodes (snI) . surfaceTriangleAreas ;
            totalArea = superNodes (snI) . totalSurfaceArea ;
            maxVertexI = 3 ;

        end % if isPointElectrode

        % Distribute the impedance to the node positions in B.

        entry = psiIntegral .* triArea ./ totalArea ;

        for vi = 1 : maxVertexI

            vertexI = nodeI (vi,:) ;

            Bs {snI} = Bs {snI} + sparse ( vertexI, snI, entry, Nn, Ne) ;

        end % for vi

    end % for snI

end % function
