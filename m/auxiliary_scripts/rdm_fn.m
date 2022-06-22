function rdm = rdm_fn(La, Lfem)

    % Documentation
    %
    % Calculates the Relative Difference Measure (RDM) for a given analytical
    % lead field La and a numerically produced Lfem.
    %
    % Inputs:
    %
    % - La: the analytical lead field (or other matrix)
    %
    % - Lfem: the numerical matrix we are comparing to La.
    %
    % Output
    %
    % - rdm: the N × 1 relative difference measure of between the two matrices.

    arguments
        La double
        Lfem double
    end

    scaled_Lfem = Lfem ./ repmat(sqrt(sum(Lfem.^2)), size(Lfem, 1), 1);
    scaled_La = La ./ repmat(sqrt(sum(La.^2)), size(La, 1), 1);

    diffs = scaled_Lfem - scaled_La;

    rdm = sqrt(sum(diffs.^2))';

end
