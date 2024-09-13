function A = stiffMatBoundaryConditions ( A, impedances, superNodes, kwargs )
%
% A = stiffMatBoundaryConditions ( A, impedances, superNodes, kwargs )
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
% - impedances (:,1)
%
%   The (possibly complex) impedances of the electrodes. If these are set to
%   infinity (Inf), boundary effects will be nullified.
%
% - superNodes (:,1)
%
%   A set of supernodes establishing a contact surface between electrodes and
%   the mesh.
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
        impedances           (:,1) double { mustBeNonNan }
        superNodes           (1,:) zefCore.SuperNode
        kwargs.onDC          (1,1) double { mustBeFinite } = 1 / 6
        kwargs.offDC         (1,1) double { mustBeFinite } = 1 / 12
        kwargs.areaThreshold (1,1) double { mustBeNonnegative } = eps
    end

    % Extract matrix sizes.

    nN = size ( A, 1 ) ;

    snN = numel ( impedances ) ;

    % Preallocate vectors needed in constructing the boundary condition matrix
    % in one sweep.

    [Arows, Acols, Avals] = preallocateEntries (snN, superNodes, kwargs.areaThreshold) ;

    % Compute impedance coefficients.

    Zcoeff = 1 ./ impedances ;

    % Apply boundary condition coefficients to on-diagonal and off-diagonal
    % coefficients. Cursor is used in saving indices to the preallocated
    % vectors.

    cursor = 1 ;

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

        rangeLen = size (nodeI,2) - 1 ;

        range = cursor : cursor + rangeLen ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            if useOnlyCenter

                Arows (range) = nodeI ;

                Acols (range) = nodeI ;

                Avals (range) = Zcoeff ( snI ) .* kwargs.onDC .* triArea / totalArea ;

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

    A = A + Addend + ctranspose (Addend) ;

end % function

%% Helper functions

function [Arows, Acols, Avals] = preallocateEntries (snN,superNodes, areaThreshold)
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
