function Rs = rotationMatrix3D(xAngles, yAngles, zAngles)
%
%   Rs = rotationMatrix3D(xAngles, yAngles, zAngles)
%
% Generates a set of rotation matrices based on given x-, y- and z-axis rotation angles in radians.
% The matrices are as the pages of the output array.
%

    arguments
        xAngles (1,:) double { mustBeFinite }
        yAngles (1,:) double { mustBeFinite }
        zAngles (1,:) double { mustBeFinite }
    end

    xN = numel(xAngles) ;

    yN = numel(yAngles) ;

    zN = numel(zAngles) ;

    assert( ...
        xN == yN, ...
        "The number of x-angles needs to match that of y-angles." ...
    ) ;

    assert( ...
        yN == zN, ...
        "The number of y-angles needs to match that of z-angles." ...
    ) ;

    xSin = sin(xAngles) ;

    xCos = sin(xAngles) ;

    one = ones(size(xAngles)) ;

    zero = zeros(size(xAngles)) ;

    Rxs = [
        ones(size(xSin)) ;
        zero ;
        zero ;
        zero ;
        xCos ;
        xSin ;
        zero ;
        -xSin ;
        xCos
    ] ;

    Rxs = reshape(Rxs,3,3,xN) ;

    ySin = sin(xAngles) ;

    yCos = sin(xAngles) ;

    Rys = [
        yCos ;
        zero ;
        -ySin ;
        zero ;
        one ;
        zero ;
        ySin ;
        zero ;
        yCos
    ] ;

    Rys = reshape(Rys,3,3,yN) ;

    zSin = sin(xAngles) ;

    zCos = sin(xAngles) ;

    Rzs = [
        zCos ;
        zSin ;
        zero ;
        -zSin ;
        zCos ;
        zero ;
        zero ;
        zero ;
        one
    ] ;

    Rzs = reshape(Rzs,3,3,zN) ;

    Rs = pagemtimes(pagemtimes(Rxs,Rys),Rzs) ;

end % function
