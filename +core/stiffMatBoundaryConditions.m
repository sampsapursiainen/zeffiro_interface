function A = stiffMatBoundaryConditions ( A, Znum, impedances, e2nI, triangles, triA, kwargs )
%
% A = stiffMatBoundaryConditions ( A, Znum, impedances, e2nI, triangles, triA, kwargs )
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
%   The numerator in the expression Z / (conj(Z) * Z), if the input impedances
%   are complex. If the impedances are real, this should equal 1.
%
% - impedances (:,1)
%
%   The (possibly complex) impedances of the electrodes.
%
% - e2nI (:,1)
%
%   A mapping of electrodes to the nodes that they are attached to.
%
% - triangles (3,:)
%
%   Triangles that the elecrodes are in contact with.
%
% - triA (:,1)
%
%   The areas of the surface triangles the electrode nodes are in contact with.
%
% - kwargs.onDC = 1 / 6
%
%   The value of the integral ∫ ψi ψj dS on the diagonal.
%
% - kwargs.offDC = 1 / 12
%
%   The value of the integral ∫ ψi ψj dS off the diagonal.
%

    arguments
        A            (:,:) double { mustBeFinite }
        Znum         (:,1) double { mustBeNonNan }
        impedances   (:,1) double { mustBeNonNan }
        e2nI         (:,1) uint32 { mustBeFinite }
        triangles    (3,:) uint32 { mustBePositive }
        triA         (:,1) double { mustBeFinite }
        kwargs.onDC  (1,1) double { mustBeFinite } = 1 / 6
        kwargs.offDC (1,1) double { mustBeFinite } = 1 / 12
    end

    % Extract matrix sizes.

    nN = size ( A, 1 ) ;

    eN = numel ( impedances ) ;

    % Preallocate vectors needed in constructing the boundary condition matrix
    % in one sweep.

    [Arows, Acols, Avals] = preallocateEntries (eN, e2nI, triangles) ;

    % Compute impedance coefficients.

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj ( impedances ) .* impedances ;
    end

    Zcoeff = Znum ./ Zden ./ eN ;

    % Apply boundary condition coefficients to on-diagonal and off-diagonal
    % coefficients. Cursor is used in saving indices to the preallocated
    % vectors.

    cursor = 1 ;

    for eI = 1 : eN

        % Find node index corresponding to current electrode.

        nI = e2nI ( eI ) ;

        % Find triangles that are touching this node.

        triI = any ( ismember ( triangles, nI ), 1 ) ;

        % Sum the areas of the triangles together.

        sumA = sum ( triA ( triI ) ) ;

        % Also get the specific node indices of the triangles for accessing
        % groups of columns and rows of A later.

        tnI = triangles (:,triI) ;

        rangeLen = size (tnI,2) - 1 ;

        range = cursor : cursor + rangeLen ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            for jj = ii : 3

                % The rows and columns of A that are being modified.

                Arows (range) = tnI (ii,:) ;

                Acols (range) = tnI (jj,:) ;

                if ii == jj
                    Avals (range) = Zcoeff ( eI ) .* kwargs.onDC .* sumA ;
                else
                    Avals (range) = Zcoeff ( eI ) .* kwargs.offDC .* sumA ;
                end

                cursor = cursor + rangeLen + 1 ;

                range = cursor : cursor + rangeLen ;

            end % for jj

        end % for ii

    end % for eI

    % Apply boundary conditions to A.

    Addend = sparse ( Arows, Acols, Avals, nN, nN ) ;

    A = A + Addend + transpose (Addend) ;

end % function

%% Helper functions

function [Arows, Acols, Avals] = preallocateEntries (eN,e2nI,triangles)
%
% [Arows, Acols, Avals] = preallocateEntries (Ne,e2nI,triangles)
%
% Preallocates the required vectors needed in applying boundary conditions to
% the given sparse stiffness matrix at once.
%

    vecsize = 0 ;

    for eI = 1 : eN

        % Find node index corresponding to current electrode.

        nI = e2nI ( eI ) ;

        % Find triangles that are touching this node.

        triI = any ( ismember ( triangles, nI ), 1 ) ;

        % Also get the specific node indices of the triangles for accessing
        % groups of columns and rows of A later.

        tnI = triangles (:,triI) ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            for jj = ii : 3

                % The rows and columns of A that are being modified.

                colnum = numel ( tnI (ii,:) ) ;

                vecsize = vecsize + colnum ;

            end % for jj

        end % for ii

    end % for eI

    Acols = zeros (vecsize,1) ;
    Arows = zeros (vecsize,1) ;
    Avals = zeros (vecsize,1) ;

end % function
