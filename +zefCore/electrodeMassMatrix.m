function Ms = electrodeMassMatrix (N, superNodes, kwargs)
%
% M = electrodeMassMatrix (N, superNodes, kwargs)
%
% Computes the mass matrix
%
%   M = ∫ ψᵢψⱼ dS
%
% for a set of SuperNodes representing a contact surface between a FE mesh and
% a set of electrodes.
%
% Inputs:
%
% - N
%
%   The size of the square output matrix.
%
% - superNodes
%
%   The contact surfaces between the FE mesh and the electrodes.
%
% - kwargs.areaThreshold = eps
%
%   The threshold, below which an electrode will be interpreted as a point electrode.
%
% Outputs:
%
% - M
%
%   The mass matrix.
%

    arguments
        N                    (1,1) double { mustBePositive, mustBeInteger }
        superNodes           (:,1) zefCore.SuperNode
        kwargs.areaThreshold (1,1) double { mustBePositive, mustBeFinite, mustBeReal } = eps
    end

    % Values of the mass matrix elements when i == j and when i ~= j. Prove
    % this by integrating the basis functions across the surface of a standard
    % tetrahedron.

    iiCoeff = 1 / 6 ;

    ijCoeff = 1 / 12 ;

    % Number of supernodes.

    snN = numel (superNodes) ;

    % Preallocate vectors needed in constructing the boundary condition matrix
    % in one sweep.

    [Mrows, Mcols, Mvals] = preallocateEntries (snN, superNodes, kwargs.areaThreshold) ;

    % Apply boundary condition coefficients to on-diagonal and off-diagonal
    % coefficients. Cursor is used in saving indices to the preallocated
    % vectors.

    cursor = 1 ;

    Ms = cell (1,snN) ;

    for snI = 1 : snN

        % Find out the nodes that the surface of this supernode is made of and
        % its area. If the area of the supernode is too small, it is
        % interpreted as a point electrode and only the supernode center will
        % be used (Agsten 2018).

        totalArea = superNodes (snI) . totalSurfaceArea ;

        useOnlyCenter = totalArea <= kwargs.areaThreshold ;

        if useOnlyCenter

            nodeI = superNodes (snI) . centralNodeI ;
            totalArea = 1 ;
            triArea = 1 ;

        else

            nodeI = superNodes (snI) . surfaceTriangles ;
            totalArea = totalArea ;
            triArea = superNodes (snI) . surfaceTriangleAreas ;

        end % if

        snCursor = cursor ;

        rangeLen = size (nodeI,2) - 1 ;

        range = cursor : cursor + rangeLen ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            if useOnlyCenter

                Mrows (range) = nodeI ;

                Mcols (range) = nodeI ;

                Mvals (range) = iiCoeff .* triArea ;

            else

                for jj = ii : 3

                    % The rows and columns of M that are being modified.

                    Mrows (range) = nodeI (ii,:) ;

                    Mcols (range) = nodeI (jj,:) ;

                    if ii == jj
                        Mvals (range) = iiCoeff .* triArea ;
                    else
                        Mvals (range) = ijCoeff .* triArea ;
                    end

                    cursor = cursor + rangeLen + 1 ;

                    range = cursor : cursor + rangeLen ;

                end % for jj

            end % if

        end % for ii

        snRange = snCursor : range (1) - 1 ;

        snMrows = Mrows (snRange) ;

        snMcols = Mcols (snRange) ;

        snMvals = Mvals (snRange) ;

        diagBool = snMrows == snMcols ;

        upperTriBool = snMrows < snMcols ;

        lowerTriBool = snMrows > snMcols ;

        diagVals = snMvals (diagBool) ;

        % Make sure diagonal is real, since A is supposed to be Hermitian.

        Mvals (diagBool) = real ( diagVals ) ;

        % Formulate the boundary ∂A.

        M = sparse (N,N) ;

        M = M + sparse ( snMrows (diagBool), snMcols (diagBool), snMvals (diagBool), N, N ) ;

        M = M + sparse ( snMrows (lowerTriBool), snMcols (lowerTriBool), snMvals (lowerTriBool), N, N ) ;

        M = M + sparse ( snMrows (upperTriBool), snMcols (upperTriBool), snMvals (upperTriBool), N, N ) ;

        M = M + sparse ( snMcols (lowerTriBool), snMrows (lowerTriBool), conj ( snMvals (lowerTriBool) ) , N, N ) ;

        M = M + sparse ( snMcols (upperTriBool), snMrows (upperTriBool), conj ( snMvals (upperTriBool) ) , N, N ) ;

        Ms {snI} = M ;

    end % for snI

end % function

%% Helper functions

function [Mrows, Mcols, Mvals] = preallocateEntries (snN,superNodes, areaThreshold)
%
% [Mrows, Mcols, Mvals] = preallocateEntries (Ne,superNodeCenters,triangles)
%
% Preallocates the required vectors needed in applying boundary conditions to
% the given sparse stiffness matrix at once.
%

    vecsize = 0 ;

    for snI = 1 : snN

        % Determine whether to use all of supernode surface or just their
        % centers.

        totalArea = superNodes (snI) . totalSurfaceArea ;

        useOnlyCenter = totalArea <= areaThreshold ;

        if useOnlyCenter

            nodeI = superNodes (snI) . centralNodeI ;

        else

            nodeI = superNodes (snI) . surfaceTriangles ;

        end % if

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or just use supernode center.

        for ii = 1 : 3

            if useOnlyCenter

                colnum = size (nodeI, 2) ;

                vecsize = vecsize + colnum ;

            else

                for jj = ii : 3

                    % The rows and columns of M that are being modified.

                    colnum = size (nodeI, 2) ;

                    vecsize = vecsize + colnum ;

                end % for jj

            end % if

        end % for ii

    end % for snI

    Mrows = zeros (vecsize,1) ;
    Mcols = zeros (vecsize,1) ;
    Mvals = zeros (vecsize,1) ;

end % function
