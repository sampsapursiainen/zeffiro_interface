
zeffiro.read_ICBM_avgTensor;

roi_radius = 15;
wm_conductivity = 0.14;
wm_label = 23;
num_points = size(zef.source_positions,1);
num_streamlines = 10000;
step_size = 4;
max_steps = 1000;
fa_thresh = 0.05;
seed_point = [91,109,71];

dti_tensor = zeffiro.dti_tensor_condition(dti_tensor, wm_conductivity);

nx = size(dti_tensor,1);
ny = size(dti_tensor,2);
nz = size(dti_tensor,3);

%Tetrahedron centers for the white matter layer.
tetra_c = 0.25*(zef.nodes(zef.tetra(:,1),:) + zef.nodes(zef.tetra(:,2),:) + zef.nodes(zef.tetra(:,3),:) + zef.nodes(zef.tetra(:,4),:));
I_wm = find(zef.domain_labels == wm_label);

%Matrix M and center point c ([c_r c_a c_s]) are from the output of FreeSurfer command
% mri_info orig.mgz. The matrix M corresponds to the affine ras2vox mapping.
M =    [1.0000   0.0000   0.0000    90.0000
           0.0000   1.0000   0.0000   126.0000
           0.0000   0.0000   1.0000    72.0000
           0.0000   0.0000   0.0000     1.0000];
c = [0.5 -17.5 18.5 0]';

%Mapping from RAS coordinate space to voxel space.
source_space = (M*([zef.source_positions ones(size(zef.source_positions,1),1)]' + c))';
source_space = source_space(:,1:3);

tetra_c = (M*([tetra_c ones(size(tetra_c,1),1)]' + c))';
tetra_c = tetra_c(I_wm,1:3);

%This is how the stream lines are calculated for a single point (could
%potentially be sped up using GPU arrays for the Euler iteration)
%zeffiro.dti_directions needs to be run only once
[dti_directions, dti_anisotropy] = zeffiro.dti_directions(dti_tensor);

sl_indices = zeros(num_points, num_points);
sl_dists = zeros(num_points, num_points);
sl_lengths = zeros(num_points, num_points);

if num_points == 1
dti_streamlines = zeffiro.dti_streamlines(dti_directions, dti_anisotropy,seed_point,roi_radius,num_streamlines,step_size,max_steps,fa_thresh);
[sl_indices, sl_dists, sl_lengths] = zeffiro.dti_nearest_streamlines(seed_point, dti_streamlines, roi_radius);
else
for ind_aux = 1 : num_points
    [ind_aux num_points]
seed_point = zef.source_positions(ind_aux,:);
dti_streamlines = zeffiro.dti_streamlines(dti_directions, dti_anisotropy,seed_point,roi_radius,num_streamlines,step_size,max_steps,fa_thresh);
[sl_indices(:,ind_aux), sl_dists(:,ind_aux), sl_lengths(:,ind_aux)] = zeffiro.dti_nearest_streamlines(source_space, dti_streamlines, roi_radius);
end
end

%This is how one can interpolate the tensor to a set of tetrahedron centers
%(shown for source_space).
conductivity_tensor = [zef.sigma zef.sigma(:,[1 1 1]) zeros(size(zef.sigma,1),3)];
tensor_array = zeffiro.dti_tensor_interpolate(tetra_c, dti_tensor, wm_conductivity, roi_radius, 'nearest');
conductivity_tensor(I_wm, 3:8) = tensor_array;

if num_points > 1
save dti_tensor_data.mat -v7.3 conductivity_tensor sl_lengths sl_dists sl_indices;
else
plot_streamlines;
end
