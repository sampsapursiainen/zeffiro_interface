function A = stiffMatBoundaryConditions ( A, Znum, impedances, superNodeCenters, superNodeTri, superNodeTriAreas, superNodeSurfArea, kwargs )
%
% A = stiffMatBoundaryConditions ( A, Znum, impedances, superNodeCenters, superNodeTri, superNodeTriAreas, superNodeSurfArea, kwargs )
%
% Modifies the stiffness matrix A to take the effects of electrodes into
% account.
%
% Inputs:
%
% - A (:,:)
%
%   The stiffness matrix being modified.
%
% - Znum
%
%   The numerator in the expression Z / (conj(Z) * Z), where Z is an impedance
%   vector. If the impedances are real, this should equal 1.
%
% - impedances (:,1)
%
%   The (possibly complex) impedances of the electrodes. If these are set to
%   infinity (Inf), boundary effects will be nullified.
%
% - superNodeCenters (:,1)
%
%   A mapping of electrodes to the nodes that they are attached to.
%
% - superNodeTri (3,:)
%
%   Mesh triangles that the elecrodes are in contact with.
%
% - superNodeTriAreas (1,:)
%
%   The areas of the individual triangles in each supernode.
%
% - superNodeSurfArea (:,1)
%
%   The areas of the surface triangles the electrode nodes are in contact with.
%
% - kwargs.onDC = 1 / 6
%
%   The value of the integral ∫ ψi ψj dS when i == j.
%
% - kwargs.offDC = 1 / 12
%
%   The value of the integral ∫ ψi ψj dS when i ~= j.
%

    arguments
        A                    (:,:) double { mustBeFinite }
        Znum                 (:,1) double { mustBeNonNan }
        impedances           (:,1) double { mustBeNonNan }
        superNodeCenters     (1,:) uint32 { mustBePositive }
        superNodeTri         (1,:) cell
        superNodeTriAreas    (1,:) cell
        superNodeSurfArea    (1,:) double { mustBeFinite, mustBeNonnegative }
        kwargs.onDC          (1,1) double { mustBeFinite } = 1 / 6
        kwargs.offDC         (1,1) double { mustBeFinite } = 1 / 12
        kwargs.areaThreshold (1,1) double { mustBeNonnegative } = eps
    end

    % Extract matrix sizes.

    nN = size ( A, 1 ) ;

    snN = numel ( impedances ) ;

    % Preallocate vectors needed in constructing the boundary condition matrix
    % in one sweep.

    [Arows, Acols, Avals] = preallocateEntries (snN, superNodeCenters, superNodeTri, superNodeSurfArea, kwargs.areaThreshold) ;

    % Compute impedance coefficients.

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj ( impedances ) .* impedances ;
    end

    Zcoeff = Znum ./ Zden ;

    % Apply boundary condition coefficients to on-diagonal and off-diagonal
    % coefficients. Cursor is used in saving indices to the preallocated
    % vectors.

    cursor = 1 ;

    for snI = 1 : snN

        % Find out the nodes that the surface of this supernode is made of and
        % its area. If the area of the supernode is too small, it is
        % interpreted as a point electrode and only the supernode center will
        % be used (Agsten 2018).

        useOnlyCenter = superNodeSurfArea (snI) <= kwargs.areaThreshold ;

        if useOnlyCenter

            nodeI = superNodeCenters (snI) ;
            totalArea = 1 ;
            triArea = 1 ;

        else

            nodeI = superNodeTri {snI} ;
            totalArea = superNodeSurfArea (snI) ;
            triArea = superNodeTriAreas {snI} ;

        end % if

        rangeLen = size (nodeI,2) - 1 ;

        range = cursor : cursor + rangeLen ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            if useOnlyCenter

                Arows (range) = nodeI ;

                Acols (range) = nodeI ;

                Avals (range) = Zcoeff ( snI ) .* kwargs.onDC .* area / totalArea ;

            else

                for jj = ii : 3

                    % The rows and columns of A that are being modified.

                    Arows (range) = nodeI (ii,:) ;

                    Acols (range) = nodeI (jj,:) ;

                    if ii == jj
                        Avals (range) = Zcoeff ( snI ) .* kwargs.onDC .* triArea / totalArea ;
                    else
                        Avals (range) = Zcoeff ( snI ) .* kwargs.offDC .* triArea / totalArea ;
                    end

                    cursor = cursor + rangeLen + 1 ;

                    range = cursor : cursor + rangeLen ;

                end % for jj

            end % if

        end % for ii

    end % for snI

    % Apply boundary conditions to A.

    Addend = sparse ( Arows, Acols, Avals, nN, nN ) ;

    A = A + Addend + transpose (Addend) ;

end % function

%% Helper functions

function [Arows, Acols, Avals] = preallocateEntries (snN,superNodeCenters, superNodeTri, superNodeSurfArea, areaThreshold)
%
% [Arows, Acols, Avals] = preallocateEntries (Ne,superNodeCenters,triangles)
%
% Preallocates the required vectors needed in applying boundary conditions to
% the given sparse stiffness matrix at once.
%

    vecsize = 0 ;

    for snI = 1 : snN

        % Determine whether to use all of supernode surface or just their
        % centers.

        useOnlyCenter = superNodeSurfArea (snI) <= areaThreshold ;

        if useOnlyCenter

            nodeI = superNodeCenters (snI) ;

        else

            nodeI = superNodeTri {snI} ;

        end % if

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or just use supernode center.

        for ii = 1 : 3

            if useOnlyCenter

                colnum = size (nodeI, 2) ;

                vecsize = vecsize + colnum ;

            else

                for jj = ii : 3

                    % The rows and columns of A that are being modified.

                    colnum = size (nodeI, 2) ;

                    vecsize = vecsize + colnum ;

                end % for jj

            end % if

        end % for ii

    end % for snI

    Acols = zeros (vecsize,1) ;
    Arows = zeros (vecsize,1) ;
    Avals = zeros (vecsize,1) ;

end % function
