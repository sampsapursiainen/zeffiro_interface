function dB = inDecibels (quantity,reference)
%
% dB = inDecibels (quantity,reference)
%
% Converts a given quantity into "decibels":
%
%   dB = 20 * log10 (quantity / reference)
%
% The quantity and reference must be positive and finite for this to make
% sense.
%

    arguments
        quantity { mustBeFinite, mustBePositive }
        reference { mustBeFinite, mustBePositive }
    end

    dB = 20 * log10 (quantity ./ reference) ;

end % function
