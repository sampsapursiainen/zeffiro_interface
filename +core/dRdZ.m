function D = dRdZ ( A, dAdZ, R, dBdZ, invS, dSdZ, kwargs )
%
% DR = dRdZ ( A, dAdZ, R, dBdZ, invS, dSdZ, kwargs )
%
% Computes the derivative of the resistivity matrix R with respect to impedance
% Z.
%
% Inputs:
%
% - A
%
%   The stiffness matrix of a system [ A, B ; B', C ] * [ u ; v ] = [ x  ; y ].
%
% - dAdZ
%
%   The derivative of the stiffness matrix with respect to the impedance Z.
%
% - R
%
%   The current value of the resistivity matrix.
%
% - dBdZ
%
%   The derivative of the matrix B = ∫ ψi dS / Z / eA with respect to the impedance Z.
%
% - invS
%
%   The inverse of the Schur complement of the stiffness matrix A.
%
% - dSdZ
%
%   The derivative of the Schur complement with respect to the impedance Z.
%
%

    arguments
        A    (:,:) { mustBeNumeric, mustBeFinite }
        dAdZ (:,:) { mustBeNumeric, mustBeFinite }
        R    (:,:) { mustBeNumeric, mustBeFinite }
        dBdZ (:,:) { mustBeNumeric, mustBeFinite }
        invS (:,:) { mustBeNumeric, mustBeFinite }
        dSdZ (:,:) { mustBeNumeric, mustBeFinite }
        kwargs.useGPU (1,1) logical = true
        kwargs.solverTol (1,1) double { mustBePositive, mustBeFinite } = 1e-8
        kwargs.TdAdZRsolver (1,1) function_handle = @core.biConjugateGradientStabilized
        kwargs.TdBdZinvSsolver (1,1) function_handle = @core.biConjugateGradientStabilized
    end

    disp ("Computing dRdZ…") ;

    Nn = size (A,1) ;

    Ne = size (R,2) ;

    xA = zeros (Nn,1) ;

    xB = xA ;

    bA = zeros (Nn,1) ;

    bB = zeros (Nn,1) ;

    dAdZR = dAdZ * R ;

    dBdZinvS = dBdZ * invS ;

    % Copy data to GPU if possible.

    tolerance = kwargs.solverTol ;

    if kwargs.useGPU && gpuDeviceCount("available") > 0
        A = gpuArray (A) ;
        xA = gpuArray (xA) ;
        xB = gpuArray (xB) ;
        bA = gpuArray (bA) ;
        bB = gpuArray (bB) ;
        tolerance = gpuArray (tolerance) ;
    end % if

    % Run solvers.

    disp ("  Inverting A with respect to dAdZ * R and dBdZ * invS…")

    Ta = zeros (Nn,Ne) ;

    Tb = zeros (Nn,Ne) ;

    for col = 1 : Ne

        xA (:) = 0 ;

        xB (:) = 0 ;

        bA (:) = full ( dAdZR (:,col) ) ;

        bB (:) = full ( dBdZinvS (:,col) ) ;

        disp ("    dAdZ * R, column " + col + " / " + Ne) ;

        [ xA(:), relResNormA, itersA ]  = kwargs.TdAdZRsolver (A, xA, bA, tolerance=tolerance) ;

        disp ("    dBdZ * invS, column " + col + " / " + Ne) ;

        [ xB(:), relResNormB, itersB ]  = kwargs.TdBdZinvSsolver (A, xB, bB, tolerance=tolerance) ;

        if relResNormA > tolerance

            error ( "Solver for dAdZ * R did not converge after the theoretical maximum number of iterations " + itersA + ". The relative residual norm was " + gather (relResNorm) + "." ) ;

        end

        if relResNormB > tolerance

            error ( "Solver for dBdZ * invS did not converge after the theoretical maximum number of iterations " + itersB + ". The relative residual norm was " + gather (relResNorm) + "." ) ;

        end

        Ta (:,col) = xA ;

        Tb (:,col) = xB ;

    end % for col

    D = - Ta + Tb - R * dSdZ * invS ;

end % function
