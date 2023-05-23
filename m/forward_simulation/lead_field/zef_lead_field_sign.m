function [Lsignx, Lsigny, Lsignz] = zef_lead_field_sign( ...
    p_source_positions, ...
    p_electrode_positions, ...
    p_L ...
    )

% Documentation
%
% Calculates the x-, y- and z-signs of the given lead field p_L based on
% cartesian source positions, their directions, the electrode positions
% and the lead field itself.
%
% Input:
%
% - p_source_positions: the cartesian positions of the dipole sources in
%   the brain.
%
% - p_electrode_positions: the cartesian positions of the electrodes on
%   the surface of the head.
%
% - p_L: the cartesian lead field matrix whose sign we are checkin for.
%
% Output:
%
% - Lsignx: the sign of the x-component of p_L or p_L(1:3:end).
%
% - Lsigny: the sign of the y-component of p_L or p_L(1:3:end).
%
% - Lsignz: the sign of the z-component of p_L or p_L(1:3:end).

arguments
    p_source_positions (:, 3) double
    p_electrode_positions (:, 3) double
    p_L
end

% Source closest to origin (SCO).

source_distances = zef_L2_norm(p_source_positions, 2);

[~, scoind] = min(source_distances);

scopos = p_source_positions(scoind,:);

% Restrict ourselves to electrodes where the desired coordinate is
% positive or in the direction of the basis vector that will be used.

electrode_pos_xy_ind = find(p_electrode_positions(:,3) > 0);
electrode_pos_xy = p_electrode_positions(electrode_pos_xy_ind, :);

electrode_pos_xz_ind = find(p_electrode_positions(:,2) > 0);
electrode_pos_xz = p_electrode_positions(electrode_pos_xz_ind, :);

electrode_pos_yz_ind = find(p_electrode_positions(:,1) > 0);
electrode_pos_yz = p_electrode_positions(electrode_pos_yz_ind, :);

% Electrodes whose projections onto the planes xy, xz and yz are closest
% to that of SCO, as in are "most below/above or left/right of it". Call
% it projectively closest electrode (PCE).

sco_ele_diffs_xy_to_be = scopos - electrode_pos_xy;
sco_ele_diffs_xz_to_be = scopos - electrode_pos_xz;
sco_ele_diffs_yz_to_be = scopos - electrode_pos_yz;

sco_ele_diffs_xy = sco_ele_diffs_xy_to_be(:, 1:2);
sco_ele_diffs_xz = sco_ele_diffs_xz_to_be(:, [1, 3]);
sco_ele_diffs_yz = sco_ele_diffs_yz_to_be(:, 2:3);

pce_dists_xy = zef_L2_norm(sco_ele_diffs_xy, 2);
pce_dists_xz = zef_L2_norm(sco_ele_diffs_xz, 2);
pce_dists_yz = zef_L2_norm(sco_ele_diffs_yz, 2);

[~, pceind_xy] = min(pce_dists_xy);
[~, pceind_xz] = min(pce_dists_xz);
[~, pceind_yz] = min(pce_dists_yz);

% Indices of p_L that match the SCO.

sco_xyz_inds = 3 * (scoind-1) + 1 : 3 * scoind;

% Part of p_L that matches both SCO and PCE.

scopceLxy = p_L(pceind_xy, sco_xyz_inds);
scopceLxz = p_L(pceind_xz, sco_xyz_inds);
scopceLyz = p_L(pceind_yz, sco_xyz_inds);

% Scalar potential of SCO at PCE, u = Lx.

basis = eye(3);

scopceux = scopceLyz * basis(:,1);
scopceuy = scopceLxz * basis(:,2);
scopceuz = scopceLxy * basis(:,3);

% Calculate the sign

Lsignx = sign(scopceux);
Lsigny = sign(scopceuy);
Lsignz = sign(scopceuz);

end
