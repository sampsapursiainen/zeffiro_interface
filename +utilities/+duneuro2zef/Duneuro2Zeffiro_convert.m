zef = zef_start_dataBank(zef);
load data/exported/mesh.mat;
mesh.labels = max(mesh.labels) + 1 - mesh.labels;
[tetra,domain_labels] = zef_hexa_to_tetra(mesh.elements,mesh.labels);
nodes = mesh.nodes;
brain_ind = find(domain_labels == 2);
save data/converted/tetra_mesh.mat tetra domain_labels nodes brain_ind
clear mesh nodes tetra domain_labels brain_ind
%load data/exported/sp_vol_rgv_N85540.mat source_grid;
load data/exported/sp_vol_rgv_N16752.mat source_grid;
source_positions = source_grid;
save data/converted/source_space.mat source_positions;
clear source_grid source_positions;

resection_points = load('data/exported/resection_points.dat');
save  data/converted/resection_points.mat resection_points;
clear resection_points;

load data/exported/LF_EEG.mat LF_EEG;
load data/exported/spikeAvgEEG;
measurements = spikeAvg_EEG.avg;
L = LF_EEG;
channels_all = spikeAvg_EEG.cfg.previous.previous.channel([302:358, end]);
channels_used = spikeAvg_EEG.label;
channels_used_ind = find(ismember(channels_all,channels_used));
L = L(channels_used_ind,:);
save data/converted/L_EEG.mat L;
clear L LF_EEG;
save data/converted/EEG_measurements.mat measurements;
clear measurements spikeAvg_EEG;

load data/exported/sensors;
points = sensors.elec.chanpos(channels_used_ind,:);
affine_transform = {[sensors.rot' -sensors.transl; 0 0 0 1]};
imaging_method_name = 'EEG';
save data/converted/EEG_sensors.mat points affine_transform imaging_method_name;
clear channels_all channels_used channels_used_ind;

load data/exported/LF_MEG.mat LF_MEG;
load data/exported/spikeAvgMEG;
T_mat = spikeAvg_MEG.grad.tra;
measurements = spikeAvg_MEG.avg;
L = T_mat*LF_MEG;
L = L(1:274,:);
save data/converted/L_MEG.mat L;
clear L LF_MEG;
save data/converted/MEG_measurements.mat measurements;
clear measurements spikeAvg_MEG;

points = sensors.grad.chanpos;
directions = sensors.grad.chanori;
imaging_method_name = 'MEG magnetometer';
save data/converted/MEG_sensors.mat points directions affine_transform imaging_method_name;
clear sensors points affine_transform;

