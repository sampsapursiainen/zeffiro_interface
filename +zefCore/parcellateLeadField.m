function [ Lx, Ly, Lz ] = parcellateleadField (Lx, Ly, Lz, aggregationI, aggregationN, axis)
%
% [ Lx, Ly, Lz ] = parcellateleadField (Lx, Ly, Lz, aggregationI, aggregationN, axis)
%
% Aggregates the x-, y- and z-components of a given lead field into a smaller array.
%

    arguments
        Lx
        Ly
        Lz
        aggregationI
        aggregationN
        axis
    end

    disp ("Parcellating lead field components…") ;

    disp (newline + "X:" + newline) ;

    Lx = zefCore.parcellateArray ( Lx, aggregationI, aggregationN, axis ) ;

    disp (newline + "Y:" + newline) ;

    Ly = zefCore.parcellateArray ( Ly, aggregationI, aggregationN, axis ) ;

    disp (newline + "Z:" + newline) ;

    Lz = zefCore.parcellateArray ( Lz, aggregationI, aggregationN, axis ) ;

end % function
