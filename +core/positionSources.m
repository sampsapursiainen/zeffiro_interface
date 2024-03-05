function sourcePos = positionSources ( nodes, elements, sourceN )
%
% sourcePos = positionSources ( nodes, tetra, activeI, sourceN )
%
% Places sources evenly into a set of given active tetrahedra. Note that if the
% given number of sources is less than the number of elements, each element
% gets at least 1 source.
%

    arguments
         nodes (3,:) double { mustBeFinite }
         elements (:,:) uint64 { mustBePositive }
         sourceN (1,1) uint64 { mustBePositive }
    end

    clc

    % Define numbers of vertices in each element and other dimensions of the
    % geometry.

    Nd = size ( nodes, 1 ) ;

    Nv = size ( elements, 1 ) ;

    Ne = size ( elements, 2 ) ;

    % Compute the number of sources per element. Note that this is rounded into
    % an integer.

    sNperE = max ( double ( sourceN ) / Ne , 1 ) ;

    % Create this many points within a standard element. Note that all of the
    % Nv barycentric coordinates (BCC) need to be in the interval [0,1] for a
    % point to be located in an element. To this end, we need to choose a
    % subset of coordinate combinations (bcP) for which this condition is true.

    da = 1 / double ( sNperE ) / 2 ;

    aa = linspace ( da, 1 - da , sNperE ) ;

    [ X, Y, Z ] = meshgrid ( aa ) ;

    bcP = zeros ( numel (X), Nv ) ;

    bcP (:,1:Nd) = [ X(:), Y(:), Z(:) ] ;

    bcP (:,end) = 1 - sum (bcP (:,1:Nd), 2) ; % Last BCC is always 1 - sum (others).

    validI = all ( 0 <= bcP & bcP <= 1, 2 ) ;

    bcPos = transpose ( bcP ( validI, 1:end-1 ) ) ;

    % Compute the barycentric transformation T of the given tetrahedra and
    % extract vertex coordinates vc.

    [ T, vc ] = core.barycentricTransformation ( nodes, elements ) ;

    NT = size ( T, 3 ) ;

    lastVC = vc ( :, end, : ) ;

    % Place sources into Cartesian coordinates r with the barycentric
    % transformation T b = r - re <=> r = T b + re.

    dN = size ( bcPos, 2) / sNperE ;

    sourcePos = pagemtimes ( T, bcPos (:, 1 : dN : end) ) + lastVC ;

end % function
