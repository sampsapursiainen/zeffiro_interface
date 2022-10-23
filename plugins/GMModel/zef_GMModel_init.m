
if not(isfield(zef,'GMModel'))
zef.GMModel = struct;
end

if not(isfield(zef.GMModel,'frame_number'))
zef.GMModel.frame_number = 1;
end


if not(isfield(zef.GMModel,'max_n_clusters'))
zef.GMModel.max_n_clusters = 20;
end

if not(isfield(zef.GMModel,'credibility'))
zef.GMModel.credibility = 0.90;
end

if not(isfield(zef.GMModel,'n_dynamic_levels'))
zef.GMModel.n_dynamic_levels = 4;
end

if not(isfield(zef.GMModel,'reg_param'))
zef.GMModel.reg_param = 1e-1;
end

if not(isfield(zef.GMModel,'max_n_iter'))
zef.GMModel.max_n_iter = 1000;
end

if not(isfield(zef.GMModel,'tol_val'))
zef.GMModel.tol_val = 1E-5;
end

zef.GMModel.h_max_n_clusters.String = num2str(zef.GMModel.max_n_clusters);
zef.GMModel.h_credibility.String = num2str(zef.GMModel.credibility);
zef.GMModel.h_n_dynamic_levels.String = num2str(zef.GMModel.n_dynamic_levels);
zef.GMModel.h_reg_param.String = num2str(zef.GMModel.reg_param);
zef.GMModel.h_max_n_iter.String = num2str(zef.GMModel.max_n_iter);
zef.GMModel.h_tol_val.String = num2str(zef.GMModel.tol_val);



