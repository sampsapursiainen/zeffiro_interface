function out = convolveField(field, kernel, kwargs)
%
%   out = convolveField(field, kernel, kwargs)
%
% Convolves a given signal with a given kernel.
% The resulting convolution is also divided by sum(kernel) to maintain the units and scale of the output field.
% The output is the same size as field by default.
%
% Arguments:
%
%   field double { mustBeFinite }
%
% The input field.
%
%   kernel double { mustBeFinite }
%
% The kernel to be convolved with signal.
%
%   kwargs.convolutionShape (1,1) string = "same"
%
% See the convn documentation for the meaning of these. The default argument results in an output of size(field).
%

    arguments
        field double { mustBeFinite }
        kernel double { mustBeFinite }
        kwargs.convolutionShape (1,1) string = "same"
    end



    scalingFactor = sum(kernel, "all") ;

    convolution = convn(field, kernel, kwargs.convolutionShape) ;

    out = convolution / scalingFactor ;

end % function
