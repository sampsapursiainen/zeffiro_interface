function points = cylinderSurfacePoints(kwargs)
%
%   points = cylinderSurfacePoints(kwargs)
%
% Generates a set of points describing a cylindrical surface based on given arguments.
%
% Arguments:
%
%   kwargs.cylinderRadius (1,1) double { mustBePositive, mustBeFinite  } = 1
%
% The radius of the output cylinder.
%
%   kwargs.cylinderAngleSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
%
% How many angles should be samples between 0 and 2 pi.
%
%   kwargs.cylinderLength (1,1) double { mustBePositive, mustBeInteger  } = 70
%
% How long the cylinder is.
%
%   kwargs.cylinderLengthSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
%
% How many samples there should be along the cylinder length axis.
%
%   kwargs.cylinderXRotation (1,1) double { mustBeFinite } = 0
%
% The radian angle by which a cylinder should be rotated perpendicular to the X axis.
%
%   kwargs.cylinderYRotation (1,1) double { mustBeFinite } = 0
%
% The radian angle by which a cylinder should be rotated perpendicular to the Y axis.
%
%   kwargs.cylinderZRotation (1,1) double { mustBeFinite } = 0
%
% The radian angle by which a cylinder should be rotated perpendicular to the Y axis.
%
%   kwargs.cylinderTranslation (1,3) double { mustBeFinite  } = [0 ; -10 ; 30]
%
% How the cylinder should be moved in relation to the origin.
%
    arguments
        kwargs.cylinderRadius (1,1) double { mustBePositive, mustBeFinite  } = 1
        kwargs.cylinderAngleSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
        kwargs.cylinderLength (1,1) double { mustBePositive, mustBeInteger  } = 70
        kwargs.cylinderLengthSamples (1,1) double { mustBePositive, mustBeInteger  } = 100
        kwargs.cylinderXRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderYRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderZRotation (1,1) double { mustBeFinite } = 0
        kwargs.cylinderTranslation (1,3) double { mustBeFinite  } = [0 0 0]
    end

    % Create cylinder surface points.

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

    points = kwargs.cylinderTranslation + rotatedCylinderPoints ;

end % function
