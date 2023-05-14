function zef = zef_GMModel_update(zef)

zef.GMModel.max_n_clusters = str2num(zef.GMModel.h_max_n_clusters.String);
zef.GMModel.credibility = str2num(zef.GMModel.h_credibility.String);
zef.GMModel.n_dynamic_levels = str2num(zef.GMModel.h_n_dynamic_levels.String);
zef.GMModel.reg_param = str2num(zef.GMModel.h_reg_param.String);
zef.GMModel.max_n_iter = str2num(zef.GMModel.h_max_n_iter.String);
zef.GMModel.tol_val = str2num(zef.GMModel.h_tol_val.String);
zef.GMModel.frame_number = str2num(zef.GMModel.h_frame_number.String);

end