function out = surfaceFnIntegral ( nodes, triangles, gradients )
%
% out = surfaceFnIntegral ( nodes, triangles, gradients )
%
% Computes the single basis function integral
%
%   ∫ ψi dS
%
% over the given triangles.
%
% Inputs:
%
% - nodes
%
%   Finite element nodes.
%
% - triangles
%
%   The triangles we wish to compute the integral in.
%
% - gradients
%
%   The gradients of the basis functions at the corners of the triangles.
%

    arguments
        nodes     (:,3) double { mustBeFinite }
        triangles (3,:) uint32 { mustBePositive }
        gradients (3,:) double { mustBeFinite }
    end

    % Compute triangle centroids and triangle corners.

    [C, c1, c2, c3] = core.triangleCentroids ( nodes, triangles ) ;

    % Compute direction vectors and their lengths.

    d1 = C - c1 ;
    d2 = C - c2 ;
    d3 = C - c3 ;

    l1 = sqrt ( sum ( d1 .^ 2, 2 ) ) ;
    l2 = sqrt ( sum ( d2 .^ 2, 2 ) ) ;
    l3 = sqrt ( sum ( d3 .^ 2, 2 ) ) ;

    % Compute the directional derivatives of the basis functions.

    gradients = transpose ( gradients ) ;

    dd1 = core.directionalDerivative ( gradients ( 1 : 3 : end, : ), d1 ) ;
    dd2 = core.directionalDerivative ( gradients ( 2 : 3 : end, : ), d2 ) ;
    dd3 = core.directionalDerivative ( gradients ( 3 : 3 : end, : ), d3 ) ;

    % Basis function values at the triangle centroids.

    fnC1 = 1 - dd1 * l1 ;
    fnC2 = 1 - dd2 * l2 ;
    fnC3 = 1 - dd3 * l3 ;

    % Approximation of integral as the sum of basis function values at the centroid.

    out = sum ( [ fnC1, fnC2, fnC3 ], 2 ) ;

end % function
