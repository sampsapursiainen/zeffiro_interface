function mag = mag_fn(La, Lfem)

    % Documentation
    %
    % Calculates the MAG difference measure for a given analytical lead field
    % La and a numerically produced Lfem.
    %
    % Inputs:
    %
    % - La: the analytical lead field (or other matrix)
    %
    % - Lfem: the numerical matrix we are comparing to La.
    %
    % Output
    %
    % - rdm: the N × 1 MAG difference measure between the two matrices.

    mag = 1 - sqrt(sum(Lfem.^2))' ./ sqrt(sum(La.^2))';
end
