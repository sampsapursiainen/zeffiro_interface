function X = invAY (A, Y, kwargs)
%
% X = invAY (A, Y, kwargs)
%
% Inverts a sparse matrix A against a supposedly column-sparse matrix Y.
%

    arguments
        A (:,:)
        Y (:,:)
        kwargs.tolerance (1,1) double { mustBeReal, mustBePositive, mustBeFinite } = 1e-10
        kwargs.useGPU    (1,1) logical = true
    end

    [ Nr, Nc ] = size (Y) ;

    [ ~, cols ] = find (Y) ;

    ucols = unique (cols) ;

    rhs = Y (:,ucols) ;

    T = zefCore.transferMatrix (A, rhs, tolerances=kwargs.tolerance,useGPU=kwargs.useGPU) ;

    X = sparse (Nr,Nc) ;

    X (:,ucols) = T ;

end % function