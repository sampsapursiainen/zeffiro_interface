function L = eegLeadField ( T, invS, G, kwargs )
%
% L = eegLeadField ( T, invS, G, kwargs )
%
% Computes an elecroencephalography (EEG) lead field matrix in a finite element context.
%
% Inputs:
%
% - T
%
%   A transfer matrix A \ B of the system [ A B ; B' C ].
%
% - invS
%
%   An inverse of the Schur complement of A in the same system as T.
%
% - G
%
%   An right interpolation matrix, that maps a lead field to actual target
%   source positions, when the potential values at the finite elemens nodes are
%   known.
%
% - kwargs.zeroPotentialFn = @mean
%
%   A 2-argument function that determines the zero potential level of the
%   interpolated lead field. This will be reduced from the interpolated lead
%   field before it is returned. The second argument must be the axis along
%   which the zero potential level is determined.
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
    arguments
        T (:,:) double { mustBeFinite }
        invS (:,:) double { mustBeFinite }
        G (:,:) double { mustBeFinite }
        kwargs.zeroPotentialFn (1,1) function_handle = @mean
    end

    disp("Computing EEG lead field as the product of Schur complement and transpose of transfer matrix…")

    L = - invS * transpose ( T ) ;

    disp ("Interpolating L to source positions…")

    LG = L * G ;

    disp ("Setting zero potential level as the column means of the lead field components.")

    LGmean = kwargs.zeroPotentialFn (LG,1) ;

    L = LG - LGmean ;

end % function
