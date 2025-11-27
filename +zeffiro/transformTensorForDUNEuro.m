function outputTensor = transformTensorForDUNEuro(inputTensor)
%
% outputTensor = transformTensorForDUNEuro(inputTensor)
%
% Resizes a given Zeffiro tensor representation T such that it
% is compatible with DUNEuro. Per-element sizes of 1 (identical diagonal),
% 3 (diagonal), 6 (symmetric) or 9 (full matrix) are accepted,
% in column-major order with the columns of the full tensor being
% concatenated as a single vector for each element. Zeffiro stores its tensor
% in the order Txx, Tyy, Tzz, Txy, Txz, Tyz, Tzz and hence assumes that.
%
% The output tensor is always in column-major order, in
% the order Txx, Tyx, Tzx, Txy, Tyy, Tzy, Txz, Tyz, Tzz. If
% the input component dimension is of size 6, the output is
% assumed to be symmetric, and the upper triangle is copied
% to the lower triangle in the output.
%

  arguments (Input)
    inputTensor (:,:) double { mustBeFinite }
  end

  arguments (Output)
    outputTensor (9,:) double { mustBeFinite }
  end

  tensorSize = size(inputTensor) ;

  validTensorSizes = [1, 3 ,6, 9] ;

  % Choose element dimension. First assume that the elementwise tensors are in column-major order and if that does not work,
  % assume a row-major ordering.

  if ismember(tensorSize(1),validTensorSizes) && tensorSize(2) >= 1

    componentDimension = 1 ;

    elementDimension = 2 ;

    transposedInputTensor = inputTensor ;

  elseif ismember(tensorSize(2),validTensorSizes) && tensorSize(1) >= 1

    componentDimension = 2 ;

    elementDimension = 1 ;

    transposedInputTensor = transpose(inputTensor) ;

  else

    error("Could not set a proper size for output tensor when input tensor was of size (" + join(string(tensorSize),", ") + ").") ;

  end % if

  % Generate output tensor. Assume that the tensor contains the components in the column-major order specified at the start.

  outputTensor = zeros(9,tensorSize(elementDimension)) ;

  if tensorSize(componentDimension) == 1

    outputTensor(1,:) = transposedInputTensor ;

    outputTensor(5,:) = transposedInputTensor ;

    outputTensor(9,:) = transposedInputTensor ;

  elseif tensorSize(componentDimension) == 3

    outputTensor(1,:) = transposedInputTensor(1,:) ;

    outputTensor(5,:) = transposedInputTensor(2,:) ;

    outputTensor(9,:) = transposedInputTensor(3,:) ;

  elseif tensorSize(componentDimension) == 6

    outputTensor(1,:) = transposedInputTensor(1,:) ; % xx

    outputTensor(2,:) = transposedInputTensor(4,:) ; % yx

    outputTensor(3,:) = transposedInputTensor(5,:) ; % zx

    outputTensor(4,:) = transposedInputTensor(4,:) ; % xy

    outputTensor(5,:) = transposedInputTensor(2,:) ; % yy

    outputTensor(6,:) = transposedInputTensor(6,:) ; % zy

    outputTensor(7,:) = transposedInputTensor(5,:) ; % xz

    outputTensor(8,:) = transposedInputTensor(6,:) ; % yz

    outputTensor(9,:) = transposedInputTensor(3,:) ; % zz

  elseif tensorSize(componentDimension) == 9

    outputTensor = transposedInputTensor ;

  else

    error("Invalid input tensor size (" + join(string(tensorSize),", ") + ").") ;

  end % if

end % function
