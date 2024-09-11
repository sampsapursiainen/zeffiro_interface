function [L, R, Gx, Gy, Gz] = tesLeadField ( T, S, nodes, tetra, tetV, volumeCurrentI, sourceTetI, conductivity )
%
% [L, R, Gx, Gy, Gz] = tesLeadField ( nodes, tetra, tetV, volumeCurrentI, conductivity, kwargs )
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
% - volumeCurrentI
%
%   Which elements in the head volume are considered active.
%
% - sourceTetI
%
%   The indices of volumeCurrentI, that actually contain volumetric currents.
%
% - contactSurfaces
%
%   The contact surfaces of the above electrodes.
%
% - conductivity
%
%   A 3D conductivity tensor, encoded wither as a 1×Ntetra vector in the
%   isotrophiv case, or as a 6×Ntetra matrix in the anisotrophic case, with
%   each column containing the values σxx, σyy, σzz, σxy, σxz and σyz.
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
        T                      (:,:) double { mustBeFinite }
        S                      (:,:) double { mustBeFinite }
        nodes                  (:,3) double { mustBeFinite }
        tetra                  (:,4) double { mustBePositive, mustBeInteger, mustBeFinite }
        tetV                   (:,1) double { mustBePositive, mustBeFinite }
        volumeCurrentI         (1,:) uint32 { mustBePositive }
        sourceTetI             (1,:) uint32 { mustBePositive }
        conductivity           (:,:) double { mustBeFinite }
    end % arguments

    I = eye ( size (S) ) ;

    invSchurC = S \ I ;

    R = T * invSchurC ;

    disp ("Computing volume currents σ∇ψ…")

    [Gx, Gy, Gz] = core.tensorNodeGradient (nodes, tetra, tetV, conductivity, volumeCurrentI) ;

    disp ("Resricting volume currents to source tetra...")

    Gx = Gx (sourceTetI,:) ;

    Gy = Gy (sourceTetI,:) ;

    Gz = Gz (sourceTetI,:) ;

    disp ("Building lead field components…") ;

    Lx = - Gx * R ;

    Ly = - Gy * R ;

    Lz = - Gz * R ;

    disp ("Reordering rows of L in xyz order…") ;

    L = core.intersperseArray ( [ Lx ; Ly ; Lz ], 1, 3) ;

    L = transpose (L) ;

end % function
