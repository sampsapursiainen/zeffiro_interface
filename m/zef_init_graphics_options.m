if not(isfield(zef,'streamline_draw'))
zef.streamline_draw = 0;
end

if not(isfield(zef,'streamline_linestyle'));
zef.streamline_linestyle = '-';
end

if not(isfield(zef,'cone_alpha'));
    zef.cone_alpha = 1;
end;

if not(isfield(zef,'cone_lattice_resolution'));
    zef.cone_field_lattice_resolution = 10;
end;
if not(isfield(zef,'cone_scale'));
    zef.cone_scale = 0.5;
end;
if not(isfield(zef,'parcellation_type'));
    zef.parcellation_type = 1;
end;

if not(isfield(zef,'parcellation_quantile'));
    zef.parcellation_quantile = 0.98;
end;

if not(isfield(zef,'sensors_visual_size'));
    zef.sensors_visual_size = 3.5;
end;

if not(isfield(zef,'use_gpu_graphic'));
    zef.use_gpu_graphic = 1;
end;

if not(isfield(zef,'colortune_param'));
    zef.colortune_param = 1;
end;