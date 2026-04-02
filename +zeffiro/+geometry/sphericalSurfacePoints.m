function points = sphericalSurfacePoints(kwargs)
%
%   points = sphericalSurfacePoints(kwargs)
%
% Generates a set of points approximating a spherical surface.
%
% Arguments:
%
%   kwargs.centerPoint (1,3) double { mustBeFinite }
%
% The center of the sphere to be generated.
%
%   kwargs.radius (1,1) double { mustBeFinite, mustBePositive }
%
% The radius of the sphere to be generated.
%
%   kwargs.azimuthSamples (1,1) double { mustBeFinite, mustBeInteger, mustBePositive }
%
% The number of azimuthal samples to be generated per elevation sample.
%
%   kwargs.elevationSamples (1,1) double {  mustBeFinite, mustBeInteger, mustBePositive }
%
% The number of elevation samples to be generated per azimuthal sample.
%

    arguments
        kwargs.centerPoint (1,3) double { mustBeFinite }
        kwargs.radius (1,1) double { mustBeFinite, mustBePositive }
        kwargs.azimuthSamples (1,:) double { mustBeFinite, mustBeInteger, mustBePositive  }
        kwargs.elevationSamples (1,:) double { mustBeFinite, mustBeInteger, mustBePositive }
    end

    azimuthDiff = 2 * pi / kwargs.azimuthSamples ;

    elevationDiff = pi / kwargs.elevationSamples ;

    azimuths = linspace(0, 2 * pi - azimuthDiff, kwargs.azimuthSamples) ;

    elevations = linspace(elevationDiff, pi, kwargs.elevationSamples) ;

    repeatedAzimuths = repmat(azimuths, 1, kwargs.elevationSamples) ;

    repeatedElevations = repelem(elevations, 1, kwargs.azimuthSamples) ;

    surfacePoints = [
        0, kwargs.radius .* sin(repeatedElevations) .* cos(repeatedAzimuths), 0 ;
        0, kwargs.radius .* sin(repeatedElevations) .* sin(repeatedAzimuths), 0 ;
        kwargs.radius, kwargs.radius .* cos(repeatedElevations), -kwargs.radius
    ]' ;

    points = surfacePoints + kwargs.centerPoint ;

end % function
