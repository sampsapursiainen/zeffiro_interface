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

    % Create cylinder surface points.

    cylinderSurfacePoints = zeffiro.geometry.cylinderSurfacePoints( ...
        cylinderRadius = kwargs.cylinderRadius, ...
        cylinderAngleSamples = kwargs.cylinderAngleSamples, ...
        cylinderLength = kwargs.cylinderLength,...
        cylinderLengthSamples = kwargs.cylinderLengthSamples, ...
        cylinderXRotation = kwargs.cylinderXRotation, ...
        cylinderYRotation = kwargs.cylinderYRotation, ...
        cylinderZRotation = kwargs.cylinderZRotation, ...
        cylinderTranslation = kwargs.cylinderTranslation ...
    ) ;

    %% Debug plotting.

    figure ;

    scatter3(cylinderSurfacePoints(:,1), cylinderSurfacePoints(:,2), cylinderSurfacePoints(:,3)) ;

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
