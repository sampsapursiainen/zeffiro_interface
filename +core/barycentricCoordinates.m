function [ C, B, vertexCoords, diffs ] = barycentricCoordinates ( nodes, elements, points )
%
% [ C, B, vertexCoords, diffs ] = barycentricCoordinates ( nodes, elements, points )
%
% Computes the barycentric coordinates of the given points in the frame of
% reference of each (simplical) element. In other words, performs a change of
% basis for each point with respect to each given element simplex.
%
% Inputs:
%
% - nodes (:,:) double { mustBeFinite }
%
%   Mesh node coordinate matrix. Each column represents one node in a simplex,
%   such as a triangle or a tetrahedron.
%
% - elements (:,:) uint64 { mustBePositive }
%
%   Index matrix whose columns contain the indices of the nodes of elements in
%   the mesh. Note that each element should be a simplex.
%
% - points (:,:) double { mustBeFinite }
%
%   The points whose barycentric coordinates with respect to the elements we
%   wish to find out.
%
% Outputs:
%
% - C
%
%   A 3D array with the barycentric coordinates of each point with respect to
%   each element as its pages.
%
% - B
%
%   A 3D array of mappings that could be used to transform the barycentric
%   coordinates back into the direction basis of the element edges:
%
%     B b = r - re ,
%
%  where b are the barycentric coordinates of r and re is the last vertex of an
%  element.
%
% - vertexCoords
%
%   A 3D array of vertex coordinates for each element. Here
%   vertexCoords(:,end,:) = re is the reference node used to compute B.
%
% - diffs
%
%   The differences between element vertices and a "last" reference vertex
%   within the same element. Performing the multiplication Bb should output
%   this array.
%

    arguments
        nodes    (:,:) double { mustBeFinite }
        elements (:,:) uint64 { mustBePositive }
        points   (:,:) double { mustBeFinite }
    end

    % Get the number of dimensions, vertices in a single element, the number of
    % elements and the number of points.

    dN = size ( nodes, 1 ) ;

    eN = size ( elements, 2 ) ;

    pN = size ( points, 2 ) ;

    % Compute transformations from a barycentric system to the frame of
    % reference of each element.

    [ B, vertexCoords ] = core.barycentricTransformation ( nodes, elements ) ;

    % Compute differences between points and last vertices of each element.

    diffs = zeros ( dN, pN, eN ) ;

    for eI = 1 : eN

        for pI = 1 : pN

            diffs (:,pI,eI) = points (:,pI) - vertexCoords (:,end,eI) ;

        end % for

    end % for

    % Go over the points and invert each page of basis B with respect to them
    % to get the barycentric coordinates.

    C = zeros (dN, pN, eN ) ;

    for eI = 1 : eN

        for pI = 1 : pN

            C (:,pI,eI) = B ( :, pI, eI ) \ diffs ( :, pI, eI ) ;

        end % for

    end % for

end % function
