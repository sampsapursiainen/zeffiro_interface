function triangles = sphericalSurfaceTriangles(kwargs)
%
%   triangles = sphericalSurfaceTriangles(kwargs)
%
% Returns the surface triangles (triples of point indices) based on the number of azimuthal and elevation samples.
% The surface normals of the triangles are facing outward.
%

    arguments
        kwargs.azimuthSamples (1,:) double { mustBeFinite, mustBeInteger, mustBePositive  }
        kwargs.elevationSamples (1,:) double { mustBeFinite, mustBeInteger, mustBePositive }
    end

    % First construct the base.

    secondBaseVertices = 1 : kwargs.azimuthSamples

    topTriangles = [
       ones(1,kwargs.azimuthSamples) ;
       circshift(secondBaseVertices+1, 1) ;
       secondBaseVertices + 1 ;
    ] ;

    % Then construct the layers between the base and the top by splitting quadrilaterals into 2 triangles.

    betweenTriangleLayerN = kwargs.elevationSamples - 1

    layerNumbers = transpose(repelem(1 : (betweenTriangleLayerN + 1) : (betweenTriangleLayerN * kwargs.elevationSamples), 1, 3))

    vertices11 = 1 : kwargs.azimuthSamples

    vertices12 = circshift(vertices11, -1)

    vertices13 = (vertices12) + kwargs.azimuthSamples

    vertices21 = vertices11

    vertices22 = vertices13

    vertices23 = vertices11 + kwargs.azimuthSamples

    firstLayerTriangles1 = [
        vertices11 ;
        vertices12 ;
        vertices13 ;
    ] ;

    allLayerTriangles1 = repmat(firstLayerTriangles1, betweenTriangleLayerN, 1) + layerNumbers

    % TODO: reshape to 0 columns if no between triangles.

    if betweenTriangleLayerN > 0

        multiplier = betweenTriangleLayerN ;

    else

        multiplier = 0 ;

    end % if

    betweenLayerTriangles1 = reshape(allLayerTriangles1, 3, multiplier * kwargs.azimuthSamples) ;

    firstLayerTriangles2 = [
        vertices21 ;
        vertices22 ;
        vertices23 ;
    ] ;

    allLayerTriangles2 = repmat(firstLayerTriangles2, betweenTriangleLayerN, 1) + layerNumbers

    betweenLayerTriangles2 = reshape(allLayerTriangles2, 3, multiplier * kwargs.azimuthSamples) ;

    % Then construct the top.

    pointN = 2 + kwargs.azimuthSamples * kwargs.elevationSamples ;

    bottomVertices1 = (pointN - kwargs.azimuthSamples) : (pointN - 1) ;

    bottomVertices2 = circshift(bottomVertices1,1) ;

    bottomVertices3 = pointN * ones(1,kwargs.azimuthSamples) ;

    bottomTriangles = [
        bottomVertices1 ;
        bottomVertices2 ;
        bottomVertices3 ;
    ] ;

    triangles = cat(2, topTriangles, betweenLayerTriangles1, betweenLayerTriangles2, bottomTriangles) ;

end % function
