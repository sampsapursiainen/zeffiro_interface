function [L, R] = tesLeadField ( T, S, nodes, tetra, tetV, Gx, Gy, Gz, aggregationI, aggregationN )
%
% [L, R, Gx, Gy, Gz] = tesLeadField ( T, S, nodes, tetra, tetV, Gx, Gy, Gz, aggregationI, aggregationN )
%
% Computes an uninterpolated transcranial electrical stimulation (tES) lead field matrix.
%
% Inputs:
%
% - T
%
%   A transfer matrix inv A * B of a system [ A B ; B' C ].
%
% - S
%
%   The Schur complement of A in the system [ A B ; B' C ].
%
% - nodes
%
%   The finite element nodes.
%
% - tetra
%
%   The tetra that the electrodes are attached to.
%
% - tetV
%
%   The volumes of the tetra.
%
% - Gx, Gy, Gz
%
%   The x-, y- and z-components of the volume current in the possibly active part of the head.
%
% - aggregationI
%
%   A mapping from global lead field column indices to the indices that should contain activity.
%
% - contactSurfaces
%
%   The contact surfaces of the above electrodes.
%
% Outputs:
%
% - L
%
%   The EEG lead field. If the impedances Z of the electrodes were complex,
%   this will contain 2 pages: the first contains a lead field corresponding to
%   the real part and the second page will correspond to the imaginary part of
%   Z.
%
% - R
%
%  A resistivity matrix.
%
% - Gx, Gy, Gz
%
%  The x-, y- and z-components of a volume current matrix G = -σ∇u.
%
    arguments
        T              (:,:) double { mustBeFinite }
        S              (:,:) double { mustBeFinite }
        nodes          (:,3) double { mustBeFinite }
        tetra          (:,4) double { mustBePositive, mustBeInteger, mustBeFinite }
        tetV           (:,1) double { mustBePositive, mustBeFinite }
        volumeCurrentI (1,:) double { mustBePositive, mustBeInteger }
        aggregationI   (1,:) double { mustBePositive, mustBeInteger }
        aggregationN   (1,:) double { mustBePositive, mustBeInteger }
    end % arguments

    I = eye ( size (S) ) ;

    invSchurC = S \ I ;

    R = T * invSchurC ;

    disp ("Building lead field components…") ;

    Lx = - Gx * R ;

    Ly = - Gy * R ;

    Lz = - Gz * R ;

    disp ("Parcellating lead field components…") ;

    disp (newline + "X:" + newline) ;

    Lx = zefCore.parcellateArray ( Lx, aggregationI, aggregationN, 1 ) ;

    disp (newline + "Y:" + newline) ;

    Ly = zefCore.parcellateArray ( Ly, aggregationI, aggregationN, 1 ) ;

    disp (newline + "Z:" + newline) ;

    Lz = zefCore.parcellateArray ( Lz, aggregationI, aggregationN, 1 ) ;

    disp ("Reordering rows of L in xyz order…") ;

    L = zefCore.intersperseArray ( [ Lx ; Ly ; Lz ], 1, 3) ;

    L = transpose (L) ;

end % function
