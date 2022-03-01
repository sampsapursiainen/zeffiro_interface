%Script for initializing possibly invisible advanced plotting options for GMM app.

if ~isfield(zef,'GMM_comp_ord')
    zef.GMM_comp_ord = 1;
end
if ~isfield(zef,'GMM_dip_comp')
    zef.GMM_dip_comp = [];
end
if ~isfield(zef,'GMM_ellip_comp')
    zef.GMM_ellip_comp = [];
end
if ~isfield(zef,'GMM_dip_num')
    if isfield(zef,'GMModel')
        if iscell(zef.GMModel)
            zef.GMM_dip_num = zef.GMModel{find(~cellfun(@isempty,zef.GMModel),1)}.NumComponents;
        else
            zef.GMM_dip_num = zef.GMModel.NumComponents;
        end
    else
        zef.GMM_dip_num = [];
    end
end
if ~isfield(zef,'GMM_ellip_num')
    if isfield(zef,'GMModel')
        if iscell(zef.GMModel)
            zef.GMM_ellip_num = zef.GMModel{find(~cellfun(@isempty,zef.GMModel),1)}.NumComponents;
        else
            zef.GMM_ellip_num = zef.GMModel.NumComponents;
        end
    else
        zef.GMM_ellip_num = [];
    end
end
if ~isfield(zef,'GMM_ellip_coloring')
    zef.GMM_ellip_coloring = 1;
end
if ~isfield(zef,'GMM_colors')
    zef.GMM_colors = [];
end