function sourcePos = positionSources ( nodes, elements, sourceN )
%
% sourcePos = positionSources ( nodes, elements, sourceN )
%
% Places sources evenly into a set of given active elements. If there are less
% sources than elements, some elements are skipped and the sources are placed
% only into some.
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

    % Compute the number of sources per element. Note that this is rounded into
    % an integer. There's at least 1 source in the elements that contain one,
    % hence the max.

    sNperE = max ( floor ( sourceN / Ne ) , 1 ) ;

    % Create this many x-points within a standard element.

    xbuffer = 5e-2 ;

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

    [ T, vc ] = core.barycentricTransformation ( nodes, elements ) ;

    lastVC = vc ( :, end, : ) ;

    % Place sources into Cartesian coordinates r with the barycentric
    % transformation T b = r - re <=> r = T b + re.

    emptySpace = max ( Ne - sourceN, 0 ) ;

    if emptySpace == 0

        step = 1 ;

    else

        step = floor (Ne / sourceN) ;

    end % if

    tetI = 1 : step : Ne ;

    sourcePos = pagemtimes ( T (:,:,tetI), bcPos ) + lastVC (:,:,tetI) ;

    diffFromTarget = numel (tetI) - sourceN ;

    if diffFromTarget > 0

        % We created more sources than were ordered.

        sourcePos (:,:,end-diffFromTarget:end) = [] ;

    else if diffFromTarget < 0

        % We created less sources than was ordered and more are needed.
        % Find tetra where we didn't place sources yet.

        nonTetI = find ( not ( ismember (1:Ne, tetI) ) ) ;

        ntI = nonTetI (1 : abs(diffFromTarget)) ;

        missingPos = pagemtimes ( T (:,:,ntI), bcPos ) + lastVC (:,:,ntI)

        sourcePos = cat (3,sourcePos,missingPos) ;

    else

        % Everything is OK.


    end % if

end % function
