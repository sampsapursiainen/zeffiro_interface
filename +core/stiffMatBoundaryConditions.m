function A = stiffMatBoundaryConditions ( A, Znum, impedances, e2nI, t2nI, triangles, triA, eA, kwargs )
%
% A = stiffMatBoundaryConditions ( A, e2nI, t2nI, triangles, triA )
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
% - t2nI (:,1)
%
%   A mapping of mesh surface triangles to the nodes that they are attached to.
%
% - triangles (3,:)
%
%   Triangles that the elecrodes are in contact with.
%
% - triA (:,1)
%
%   The areas of the surface triangles the electrode nodes are in contact with.
%
% - eA (:,1) or (1,1)
%
%   Electrode areas.
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
        A            (:,:) sparse { mustBeFinite }
        Znum         (:,1) double { mustBeNonNan }
        impedances   (:,1) double { mustBeNonNan }
        e2nI         (:,1) uint32 { mustBeFinite }
        t2nI         (:,1) uint32 { mustBeFinite }
        triangles    (:,1) uint32 { mustBePositive }
        triA         (:,1) double { mustBeFinite }
        eA           (:,1) double { mustBeNonNan }
        kwargs.onDC  (1,1) double { mustBeFinite } = 1 / 6
        kwargs.offDC (1,1) double { mustBeFinite } = 1 / 12
    end

    % Extract matrix sizes.

    nN = size ( A, 1 ) ;

    eN = numel ( impedances ) ;

    % Compute impedance coefficients.

    if isreal ( impedances )
        Zden = impedances ;
    else
        Zden = conj ( impedances ) .* impedances ;
    end

    Zcoeff = Znum ./ Zden ./ eA ;

    % Apply boundary condition coefficients to on-diagonal and off-diagonal
    % coefficients.

    for eI = 1 : eN

        % Find node index corresponding to current electrode.

        nI = e2nI ( eI ) ;

        % Find triangles that are touching this node.

        triI = nI == t2nI ;

        % Sum the areas of the triangles together.

        sumA = sum ( triA ( triI ) ) ;

        % Go over the combinations of basis functions ψi and ψj in the
        % triangles, or the combinations of vertices.

        for ii = 1 : 3

            for jj = ii : 3

                % The rows and columns of A that are being modified.

                Arows = triangles ( :, triI ( ii ) );

                Acols = triangles ( :, triI ( jj ) );

                if ii == jj
                    Aentry = Zcoeff ( eI ) .* kwargs.onDC .* sumA ;
                else
                    Aentry = Zcoeff ( eI ) .* kwargs.offDC .* sumA ;
                end

                Add = sparse ( Arows, Acols, Aentry, nN, nN ) ;

                A = A + Add ;

                if ii ~= jj
                    A = A + Add' ;
                end

            end % for jj

        end % for ii

    end % for eI

    for i = 1 : 3

        for j = i : 3

            if i == j

                A_part = sparse ( e2nI(t2nI,i+1), e2nI(t2nI,j+1), (1/6) * entry_vec, nN, nN );

                A = A + A_part;

            else

                A_part = sparse ( e2nI(t2nI,i+1),  e2nI(t2nI,j+1),  (1/12) * entry_vec , nN, nN );

                A = A + A_part + A_part';

            end % if

        end % for

    end % for

end % function
