function [sourcePos, sourceTetI] = positionSources ( nodes, elements, sourceN )
%
% [sourcePos, sourceTetI] = positionSources ( nodes, elements, sourceN )
%
% Places sources evenly into a set of given active elements, returning the
% source positions and which source is in which input element. If there are
% less sources than elements, some elements are skipped and the sources are
% placed only into some. If there are more source than elements, some elements
% will contain multiple sources.
%
% Inputs:
%
% - nodes
%
%   FEM nodes.
%
% - elements
%
%   Indices of nodes ordered in column-major order, meaning a single element is a column of this array.
%
% - sourceN
%
%   The number of requested sources.
%
% Outputs:
%
% - sourcePos
%
%   An Ndim×sourceN array of source positions.
%

    arguments
         nodes (3,:) double { mustBeFinite }
         elements (:,:) uint64 { mustBePositive }
         sourceN (1,1) uint64 { mustBePositive }
    end

    % This together with the above arguments-block sourceN line is necessary
    % because MATLAB is asenine about types.

    sourceN = double (sourceN) ;

    % Number of elements.

    Ne = size ( elements, 2 ) ;

    Nd = size (nodes,1) ;

    % Compute the number of sources per element. Note that this is rounded into
    % an integer. There's at least 1 source in the elements that contain one,
    % hence the max.

    sNperE = max ( floor ( sourceN / Ne ) , 1 ) ;

    % Create this many x-points within a standard element.

    xbuffer = 5e-2 * ones (1,sNperE) ;

    tx = rand (1,sNperE) ;

    xx = xbuffer + tx .* (1 - 2 * xbuffer) ;

    Nx = numel (xx) ;

    % Generate a random y inside the standard triangle with max y = ty * (1 -
    % x), with ty ∈ [0,1]. Also do the same for z with z = tz * (1 - y - x).
    % Also add in some buffering to position the points truly inside of the
    % standard element, and not on the border.

    ty = rand (1,Nx) ;

    tz = rand (1,Nx) ;

    ybuffer = (1 - xx) / 100 ;

    yy = ybuffer + ty .* (1 - xx - ybuffer) ;

    zbuffer = (1 - yy - xx) / 100 ;

    zz = zbuffer +  tz .* (1 - yy - xx - zbuffer) ;

    % Construct barycentric positions.

    bcPos = transpose ([ xx', yy', zz' ]) ;

    % Compute the barycentric transformation T of the given tetrahedra and
    % extract vertex coordinates vc.

    [ T, vc ] = zefCore.barycentricTransformation ( nodes, elements ) ;

    lastVC = vc ( :, end, : ) ;

    % Place sources into Cartesian coordinates r with the barycentric
    % transformation T b = r - lastVC <=> r = T b + lastVC.

    step = ceil (Ne / sourceN) ;

    tetI = 1 : step : Ne ;

    sourceTetI = repelem(tetI,1,sNperE) ;

    sourcePos = pagemtimes ( T (:,:,tetI), bcPos ) + lastVC (:,:,tetI) ;

    Nse = size (sourcePos,3) ;

    sourcePos = reshape (sourcePos, Nd, sNperE * Nse) ;

    Ns = size (sourcePos,2) ;

    diffFromTarget = Ns - sourceN ;

    % After initial positioning, iterate until correct number of sources is reached.

    while diffFromTarget ~= 0

        if diffFromTarget > 0

            % We created more sources than were ordered. Just delete the extra
            % from the end of the array.

            sourcePos (:,Ns-sourceN+1:Ns) = [] ;

            sourceTetI (Ns-sourceN+1:Ns) = [] ;

        elseif diffFromTarget < 0 && sourceN < Ne

            % We created less sources than was ordered and more are needed. Find
            % tetra where we didn't place sources yet and put them there.

            nonTetI = find ( not ( ismember (1:Ne, tetI) ) ) ;

            ntI = nonTetI (1 : abs(diffFromTarget)) ;

            sourceTetI = cat ( 2, sourceTetI, ntI ) ;

            missingPos = pagemtimes ( T (:,:,ntI), bcPos ) + lastVC (:,:,ntI) ;

            missingPos = reshape (missingPos, Nd, sNperE * size(missingPos,3)) ;

            sourcePos = cat (2,sourcePos,missingPos) ;

        elseif diffFromTarget < 0 && sourceN >= Ne

            % We created less sources than was ordered and more are needed.
            % Add sources to existing tetra with an even spacing.

            absdft = abs (diffFromTarget) ;

            sNperE = max ( floor ( absdft / Ne ) , 1 ) ;

            tx = rand (1,sNperE) ;
            ty = rand (1,sNperE) ;
            tz = rand (1,sNperE) ;

            xbuffer = 5e-2 * ones (1,sNperE) ;
            xx = xbuffer + tx .* (1 - 2 * xbuffer) ;

            ybuffer = (1 - xx) / 100 ;
            yy = ybuffer + ty .* (1 - xx - ybuffer) ;

            zbuffer = (1 - yy - xx) / 100 ;
            zz = zbuffer + tz .* (1 - yy - xx - zbuffer) ;

            bcPos = transpose ([ xx', yy', zz' ]) ;

            step = ceil (Ne / absdft) ;

            range = 1 : step : Ne ;

            sourceTetI = cat ( 2, sourceTetI, repelem (range,1,sNperE) ) ;

            missingPos = pagemtimes ( T (:,:,range), bcPos ) + lastVC (:,:,range) ;

            missingPos = reshape (missingPos, Nd, sNperE * size(missingPos,3)) ;

            sourcePos = cat (2,sourcePos,missingPos) ;

        else % Correct number of sources reached.

            break

        end % if

        diffFromTarget = size (sourcePos,2) - sourceN ;

    end % while

end % function
