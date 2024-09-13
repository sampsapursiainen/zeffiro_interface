function [ sourcePos, aggregationN, aggregationI, individualI  ] = positionSourcesRectGrid (nodes, tetra, targetTetraI, sourceN)
%
% [ sourcePos, aggregationN, aggregationI, individualI ] = positionSourcesRectGrid ( nodes, tetra, targetTetraI, sourceN )
%
% Generates a regular grid of source positions inside of elemental indices
% targetTetraI, based on a desired number of sources.
%
% Inputs:
%
% - nodes
%
%   Vertices of the finite elements.
%
% - tetra
%
%   The finite elements (quadruples of vertex indices).
%
% - targetTetraI
%
%   The elements into which sources are to be placed.
%
% - sourceN
%
%   A rough approximation of how many sources are desired.
%
% Output:
%
% - sourcePos
%
%   The source positions in elements of targetTetraI.
%
% - aggregationN
%
%   The numbers of sources that were generated inside of each element.
%
% - aggregationI
%
%   A mapping from global source indices to its local subset. Allows (for
%   example) integrating or interpolating the effects of all generated source
%   positions to a smaller amount of points within the source position set.
%
% - individualI
%
% The opposite of aggregationI.
%
    arguments
        nodes        (:,3) double { mustBeFinite }
        tetra        (:,4) int32  { mustBePositive }
        targetTetraI (:,1) int32  { mustBePositive }
        sourceN      (1,1) double { mustBePositive }
    end

    % Find tetrahedral centroids.

    centerPoints = zefCore.tetraCentroids (nodes, tetra) ;

    centerPoints = centerPoints (targetTetraI,:) ;

    % Generate rectangular grid, whose resolution is scaled based on desired
    % number of sources via a lattice constant.

    minX = min (centerPoints(:,1));
    maxX = max (centerPoints(:,1));
    minY = min (centerPoints(:,2));
    maxY = max (centerPoints(:,2));
    minZ = min (centerPoints(:,3));
    maxZ = max (centerPoints(:,3));

    latticeConstant = sourceN .^ (1/3) / ( (maxX - minX) * (maxY - minY) * (maxZ - minZ) ) ^ (1/3);

    latticeResX = floor ( latticeConstant * (maxX - minX) ) ;
    latticeResY = floor ( latticeConstant * (maxY - minY) ) ;
    latticeResZ = floor ( latticeConstant * (maxZ - minZ) ) ;

    dx = (maxX - minX) / (latticeResX + 1) ;
    dy = (maxY - minY) / (latticeResY + 1) ;
    dz = (maxZ - minZ) / (latticeResZ + 1) ;

    minX = minX + dx ;
    maxX = maxX - dx ;
    minY = minY + dy ;
    maxY = maxY - dy ;
    minZ = minZ + dz ;
    maxZ = maxZ - dz ;

    xspace = linspace (minX, maxX, latticeResX) ;
    yspace = linspace (minY, maxY, latticeResY) ;
    zspace = linspace (minZ, maxZ, latticeResZ) ;

    [latticeX, latticeY, latticeZ] = meshgrid (xspace, yspace, zspace);

    sourcePos = [ latticeX(:) latticeY(:) latticeZ(:) ];

    % Generate indices of elements that were actually inside of tetra.

    sourceElementI = latticeIndexFn ( centerPoints, latticeResX, latticeResY, latticeResZ ) ;

    [ uniqueSourceElementI, uInI, uOutI ] = unique (sourceElementI);

    sourceElementIToBe = zeros ( size (sourcePos,1),1);

    sourceElementIToBe (uniqueSourceElementI) = 1 : length (uniqueSourceElementI);

    aggregationI = sourceElementIToBe (sourceElementI) ;

    % Restrict outselves to the actual source positions that were located inside of the active elements.

    sourcePos = sourcePos (uniqueSourceElementI,:) ;

    aggregationN = accumarray (uOutI,1) ;

    individualI = uInI;

end % function

%% Helper functions.

function sourceElementI = latticeIndexFn( cp, lrx, lry, lrz )

% Documentation
%
% A helper function for generating lattice indices based on the barycentra
% of the tetrahedra that form the lattice, and the x-, y- and z-resultions
% of the lattice.
%
% Input:
%
% - in_center_points: the barycenters of the tetrahedral lattice we are
%   observing.
%
% - lrx: the (integer) resolution of the lattice in the x-direction.
%
% - lry: the (integer) resolution of the lattice in the y-direction.
%
% - lrz: the (integer) resolution of the lattice in the z-direction.
%
% Output:
%
% - sourceElementI
%
%   Linear index locations of the tetrehedral barycenters in the lattice
%   we are interested in.

    arguments
        cp (:,3) double
        lrx (1,1) double
        lry (1,1) double
        lrz (1,1) double
    end

    % Extract centroid components.

    cpx = cp (:,1);
    cpy = cp (:,2);
    cpz = cp (:,3);

    % Absolute coordinates (relative coordinates times resolution) in the
    % rectangular lattice.

    acx = max ( 1, round ( lrx * (cpx - min(cpx)) ./ ( max(cpx) - min(cpx) ) ) );
    acy = max ( 1, round ( lry * (cpy - min(cpy)) ./ ( max(cpy) - min(cpy) ) ) );
    acz = max ( 1, round ( lrz * (cpz - min(cpz)) ./ ( max(cpz) - min(cpz) ) ) );

    % Linear indices from absolute coordinates.

    sourceElementI = (acz-1) * lrx * lry + (acx-1) * lry + acy;

end % function
