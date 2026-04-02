function seegElectrodeInterpolation(kwargs)
%
% seegElectrodeInterpolation(kwargs)
%
% TODO
%

    arguments
        kwargs.cylinderRadius (1,1) double { mustBePositive, mustBeFinite  } = 1
        kwargs.cylinderAngleSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
        kwargs.cylinderLength (1,1) double { mustBePositive, mustBeInteger  } = 70
        kwargs.cylinderLengthSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
        kwargs.cylinderXRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderYRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderZRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderTranslation (1,3) double { mustBeFinite  } = [0 ; -10 ; 30]
        kwargs.sourcePositions (:,3) double { mustBeFinite } = []
        kwargs.fieldValues (:,3) double { mustBeFinite } = []
        kwargs.meshNodes (:,3) double { mustBeFinite  } = []
        kwargs.elements (4,:) double { mustBePositive, mustBeInteger }
        kwargs.interpolator (1,1) function_handle = @scatteredInterpolant
    end

    [sourcePositionN, sourcePositionDimension] = size(kwargs.sourcePositions) ;

    [fieldValueN, fieldDimension] = size(kwargs.fieldValues) ;

    assert( ...
        sourcePositionN == fieldValueN, ...
        "The number of source positions id not match the number of field values." ...
    ) ;

    assert( ...
        sourcePositionDimension == fieldDimension || fieldDimension == 1, ...
        "The dimensionality of the srource positions did not match the field dimensions, or the field was not a scalar field." ...
    ) ;

    % Create cylinder points [cx, cy, cz].

    angles = linspace(0, 2 * pi - eps, kwargs.cylinderAngleSamples) ;

    zCoordinates = linspace(0, kwargs.cylinderLength, kwargs.cylinderLengthSamples) ;

    cylinderSurfacePoints = [
        0 repmat(kwargs.cylinderRadius .* cos(angles), 1, kwargs.cylinderLengthSamples) 0 ;
        0 repmat(kwargs.cylinderRadius .* sin(angles), 1, kwargs.cylinderLengthSamples) 0 ;
        0 repelem(zCoordinates, 1, kwargs.cylinderAngleSamples) zCoordinates(end)
    ]' ;

    % Create rotation matrix R.

    Rx = [
        1 0 0 ;
        0 cos(kwargs.cylinderXRotation) -sin(kwargs.cylinderXRotation) ;
        0 sin(kwargs.cylinderXRotation) cos(kwargs.cylinderXRotation)
    ] ;

    Ry = [
        cos(kwargs.cylinderYRotation) 0 sin(kwargs.cylinderYRotation) ;
        0 1 0 ;
        - sin(kwargs.cylinderYRotation) 0 cos(kwargs.cylinderYRotation)];

    Rz = [
        cos(kwargs.cylinderZRotation) -sin(kwargs.cylinderZRotation) 0 ;
        sin(kwargs.cylinderZRotation) cos(kwargs.cylinderZRotation) 0 ;
        0 0 1
    ] ;

    R = Rz * Ry * Rx ;

    % Rotate and translate cylinder, in this order.

    rotatedCylinderPoints = cylinderSurfacePoints * transpose(R) ;

    translatedCylinderPoints = kwargs.cylinderTranslation + rotatedCylinderPoints ;

    %% Debug plotting.

    figure ;

    scatter3(translatedCylinderPoints(:,1), translatedCylinderPoints(:,2), translatedCylinderPoints(:,3)) ;

    xlabel("x") ;

    ylabel("y") ;

    zlabel("z") ;

    axis equal ;

    % With the cylinder in place, we interpolate the field values from the source positions to the cylinder surface.

    interpolatorFn = kwargs.interpolator( ...
        kwargs.sourcePositions, ...
        kwargs.fieldValues ...
    ) ;

    interpolatedFieldValues = interpolatorFn(translatedCylinderPoints) ;

end % function
