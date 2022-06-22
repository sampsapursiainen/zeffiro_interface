function Lsign = zef_lead_field_sign( ...
    p_source_positions, ...
    p_electrode_positions, ...
    p_L ...
)

    % Calculates the sign of the given lead field p_L based on source positions,
    % their directions, the electrode positions and the lead field itself.

    arguments
        p_source_positions (:, 3) double
        p_electrode_positions (:, 3) double
        p_L
    end

    % Source closest to origin (SCO).

    source_distances = zef_L2_norm(p_source_positions, 2);

    [~, scoind] = min(source_distances);

    scopos = p_source_positions(scoind,:);

    % Electrode whose projection onto the xy-plane is closest to that of SCO,
    % as in is "most below/above it". Call it projectively closest electrode
    % (PCE).

    sco_ele_diffs = scopos - p_electrode_positions;

    sco_ele_diffs_xy = sco_ele_diffs(:, 1:2);

    pce_dists = zef_L2_norm(sco_ele_diffs_xy, 2);

    [~, pceind] = min(pce_dists);

    % Indices of p_L that match the SCO.

    sco_xyz_inds = 3 * (scoind-1) + 1 : 3 * scoind;

    % Part of p_L that matches both SCO and PCE.

    scopceL = p_L(pceind, sco_xyz_inds);

    % Scalar potential of SCO at PCE, u = Lx.

    scodir = [ 0 ; 0 ; 1 ];

    scopceu = scopceL * scodir;

    % Calculate the sign

    Lsign = sign(scopceu);

end
