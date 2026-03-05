function [ Lx, Ly, Lz ] = tesLeadField ( R, Gx, Gy, Gz )
%
% [ Lx, Ly, Lz ] = tesLeadField ( R, Gx, Gy, Gz )
%
% Computes an uninterpolated transcranial electrical stimulation (tES) lead field matrix.
%
% Inputs:
%
% - R
%
%   A resistance matrix (see https://doi.org/10.1016/j.cmpb.2022.107084).
%
% - Gx, Gy, Gz
%
%   The x-, y- and z-components of the volume current in the possibly active part of the head.
%
% Outputs:
%
% - Lx, Ly, Lz
%
%   The different components of the ES lead field.
%
    arguments
        R  (:,:) double { mustBeFinite }
        Gx (:,:) double { mustBeFinite }
        Gy (:,:) double { mustBeFinite }
        Gz (:,:) double { mustBeFinite }
    end % arguments

    Lx = - Gx * R ;

    Ly = - Gy * R ;

    Lz = - Gz * R ;

end % function
