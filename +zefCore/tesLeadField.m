function [ Lx, Ly, Lz, R ] = tesLeadField ( T, S, Gx, Gy, Gz )
%
% [ Lx, Ly, Lz, R ] = tesLeadField ( T, S, Gx, Gy, Gz )
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
% - Gx, Gy, Gz
%
%   The x-, y- and z-components of the volume current in the possibly active part of the head.
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
    arguments
        T            (:,:) double { mustBeFinite }
        S            (:,:) double { mustBeFinite }
        Gx           (:,:) double { mustBeFinite }
        Gy           (:,:) double { mustBeFinite }
        Gz           (:,:) double { mustBeFinite }
    end % arguments

    I = eye ( size (S) ) ;

    invSchurC = S \ I ;

    R = T * invSchurC ;

    disp ("Building lead field components…") ;

    Lx = - Gx * R ;

    Ly = - Gy * R ;

    Lz = - Gz * R ;

end % function
