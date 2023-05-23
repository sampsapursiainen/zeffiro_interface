load data/ary_model/ary_model.mat;

%% 1

load zeffiro_projects/pallomalli_pem.mat;

[mag_v_1, rdm_v_1, La, Lfem] = mag_rdm_fn(ary_model, zef_data);
s_p_1 = zef_data.source_positions;

% %% 2
%
% load zeffiro_projects/pallomalli_pem.mat;
%
% [mag_v_2, rdm_v_2, La, Lfem] = mag_rdm_fn(ary_model, zef_data);
% s_p_2 = zef_data.source_positions;
%
% %% 3
%
% load zeffiro_projects/pallomalli_pem.mat;
%
% [mag_v_3, rdm_v_3, La, Lfem] = mag_rdm_fn(ary_model, zef_data);
% s_p_3 = zef_data.source_positions;
%
% %% 4
%
% load zeffiro_projects/pallomalli_pem.mat;
%
% [mag_v_4, rdm_v_4, La, Lfem] = mag_rdm_fn(ary_model, zef_data);
% s_p_4 = zef_data.source_positions;

%% Function definitions

function [mag, rdm, La, Lfem] = mag_rdm_fn(ary_model, zef_data)

% Compare the FEM lead field Lfem (taken from zef_data) to an analytical
% lead field La (produced from a given Ary model). Returns the MAG and RDM
% over the columns of the lead fields.
%
% Input:
%
% - ary_model: the struct loaded from data → ary_model → ary_model.m,
%              which can be used to calculate the analytical lead field
%              for comparison purposes.
%
% - zef_data: the zef struct that contains the FEM-based lead field.
%
% Output:
%
% - The MAG and RDM difference measures between the lead fields.

La = zef_lead_field_eeg_multilayer_sphere( ...
    zef_data.sensors_attached_volume(:,1:3) / 1000, ...
    zef_data.source_positions / 1000, ...
    [], ...
    ary_model ...
    );

Lfem = zef_data.L;

rdm = rdm_fn(La, Lfem);

mag = mag_fn(La, Lfem);

end

function rdm = rdm_fn(La, Lfem)

scaled_Lfem = Lfem ./ repmat(sqrt(sum(Lfem.^2)), size(Lfem, 1), 1);
scaled_La = La ./ repmat(sqrt(sum(La.^2)), size(La, 1), 1);

diffs = scaled_Lfem - scaled_La;

rdm = sqrt(sum(diffs.^2))';

end

function mag = mag_fn(La, Lfem)
mag = 1 - sqrt(sum(Lfem.^2))' ./ sqrt(sum(La.^2))';
end
