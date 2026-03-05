
HOME = getenv("HOME") ;

data_dir   = fullfile(HOME, "Downloads", "DTI_data") ;

bvec_file  = fullfile(data_dir, 'bvectors.txt') ;

bval_file  = fullfile(data_dir, 'bvalues.txt') ;

roi_radius = 15;

white_matter_conductivity = 0.14;

num_points = 10000;

num_streamlines = 5000;

step_size = 2;

% This is how one gets the tensor from files

dti_tensor = zeffiro.dti_tensor(data_dir, bvec_file,bval_file);

nx = size(dti_tensor,1);
ny = size(dti_tensor,2);
nz = size(dti_tensor,3);

seed_point = [nx/2, ny/2, nz/2];

source_space = [ ...
    rand(num_points,1) * (nx-1) + 1, ...
    rand(num_points,1) * (ny-1) + 1, ...
    rand(num_points,1) * (nz-1) + 1 ];

%This is how the stream lines are calculated for a single point (could
%potentially be sped up using GPU arrays for the Euler iteration)
%zeffiro.dti_directions needs to be run only once
[dti_directions, dti_anisotropy] = zeffiro.dti_directions(dti_tensor);
tic
dti_streamlines = zeffiro.dti_streamlines(dti_directions, dti_anisotropy,seed_point,roi_radius,num_streamlines,step_size);
toc

%This is how one can get connectivity characteristics for source_space.
[sl_indices, sl_dists, sl_lengths] = zeffiro.dti_nearest_streamlines(source_space, dti_streamlines, roi_radius);

%This is how one can interpolate the tensor to a set of tetrahedron centers
%(shown for source_space).
conductivity_tensor = zeffiro.dti_tensor_interpolate(source_space, dti_tensor, white_matter_conductivity, roi_radius, 'nearest');

zeffiro.plot_streamlines;
