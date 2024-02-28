function C = barycentricCoordinates ( nodes, elements, points )
%
% C = barycentricCoordinates ( nodes, elements, points )
%
% Computes the barycentric coordinates of the given points in the frame of
% reference of each (simplical) element. In other words, performs a change of
% basis for each point with respect to each given element simplex.
%
% Inputs:
%
% - nodes (:,:) double { mustBeFinite }
%
%   Mesh node coordinate matrix. Each column represents one node.
%
% - elements (:,:) uint64 { mustBePositive }
%
%   Index matrix whose columns contain the indices of the nodes of elements in
%   the mesh. Note that each element should be convex.
%
% - points (:,:) double { mustBeFinite }
%
%   The points whose barycentric coordinates we wish to find out.
%
% Outputs:
%
% - C
%
%   A 3D array with the barycentric coordinates of each point with respect to
%   each element as its pages.
%

    arguments
        nodes    (:,:) double { mustBeFinite }
        elements (:,:) uint64 { mustBePositive }
        points   (:,:) double { mustBeFinite }
    end

    % Get the number of dimensions, vertices in a single element, the number of
    % elements and the number of points.

    dN = size ( nodes, 1 ) ;

    vN = size ( elements, 1 ) ;

    eN = size ( elements, 2 ) ;

    pN = size ( points, 2 ) ;

    % First get the vertex coordinates of each element in groups of as many
    % columns as there are vertices in a single element, taking into account
    % the column-major ordering of MATLAB arrays.

    vertexCoords = nodes ( :, elements )

    % Reshape it such that the vertex coordinates of each element are as pages
    % of a 3D array.

    vertexCoords = reshape ( vertexCoords, dN, vN, eN )

    % Compute differences between the last vertex of each element and its other
    % vertices. These give the basis of the coordinate system defined by each
    % element in a 3D array B.

    B = vertexCoords ( :, 1:end-1 ,: ) - vertexCoords ( :, end, : )

    % Compute differences between points and last vertices of each element.

    diffs = zeros ( dN, pN, eN ) ;

    for eI = 1 : eN

        for pI = 1 : pN

            diffs (:,pI,eI) = points (:,pI) - vertexCoords (:,end,eI) ;

        end % for

    end % for

    diffs

    % Go over the points and invert each page of basis B with respect to them
    % to get the barycentric coordinates.

    C = zeros (dN, pN, eN ) ;

    for eI = 1 : eN

        for pI = 1 : pN

            C (:,pI,eI) = B ( :, pI, eI ) \ diffs ( :, pI, eI ) ;

        end % for

    end % for

end % function
