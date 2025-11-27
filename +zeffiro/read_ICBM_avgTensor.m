
HOME = getenv("HOME") ;

folder_name = fullfile(HOME, "Downloads", 'ICBM_avgTensor') ;

dti_tensor = zeros(181, 217, 181, 6);

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_xx.nii'));

dti_tensor(:, :, :, 1) = aux_var;

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_yy.nii'));

dti_tensor(:, :, :, 2) = aux_var;

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_zz.nii'));

dti_tensor(:, :, :, 3) = aux_var;

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_xy.nii'));

dti_tensor(:, :, :, 4) = aux_var;

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_xz.nii'));

dti_tensor(:, :, :, 5) = aux_var;

aux_var = niftiread(fullfile(folder_name, 'ICBM_avgTensor_yz.nii'));

dti_tensor(:, :, :, 6) = aux_var;
