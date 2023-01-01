cfg = struct;

smooth_val = 3;
n_triangles = 100000; 
iso_val = 0.25;

cfg.brainsmooth = 100;
cfg.scalpsmooth = 100;
cfg.skullsmooth = 100;

cfg.brainthreshold = 0.5;
cfg.scalpthreshold = 100;
cfg.skullthreshold = 1000;

cfg.downsample = 1;

cfg.output = {'tpm'};
cfg.spmmethod = 'mars';

mri = ft_read_mri(mri_file_name,'dataformat','freesurfer_mgz');
mri.coordsys = 'ras';

segmented = ft_volumesegment(cfg, mri);

[nodes,triangles] = zef_isosurface(segmented.gray,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_gray.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.white,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_white.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.csf,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_csf.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.bone,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_bone.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.softtissue,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_softtissue.stl'], triangles, nodes);

%[nodes,triangles] = zef_isosurface(segmented.air,iso_val,smooth_val,n_triangles);
%stlwrite([dir_name filesep 'spm12_air.stl'], triangles, nodes);

cfg.brainsmooth = 5;
cfg.scalpsmooth = 5;
cfg.skullsmooth = 5;

cfg.brainthreshold = 0.5;
cfg.scalpthreshold = 0.1;
cfg.skullthreshold = 0.5;

cfg.downsample = 1;

cfg.output = {'brain' 'skull' 'scalp'};
cfg.spmmethod = 'old';

mri = ft_read_mri(mri_file_name,'dataformat','freesurfer_mgz');
mri.coordsys = 'tal';

segmented = ft_volumesegment(cfg, mri);

[nodes,triangles] = zef_isosurface(segmented.brain,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_brain.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.skull,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_skull.stl'], triangles, nodes);

[nodes,triangles] = zef_isosurface(segmented.scalp,iso_val,smooth_val,n_triangles);
stlwrite([dir_name filesep 'spm12_scalp.stl'], triangles, nodes);
