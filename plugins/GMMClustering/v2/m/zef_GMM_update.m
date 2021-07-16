%Script for updating edit field of GMM system.

%_ Main app _
zef_props = properties(zef.GMM.apps.main);
zef_n=0;
for zef_i = 2:length(zef_props)
    if strcmp(zef.GMM.apps.main.(zef_props{zef_i-1}).Type,'uilabel')
        zef_n=zef_n+1;
        zef.GMM.apps.main.(zef_props{zef_i}).Value = zef.GMM.parameters.Values{zef_n};
    end
end

%_ Advanced plot options _
if isfield(zef.GMM.apps,'PlotOpt')
    if isvalid(zef.GMM.apps.PlotOpt)
        zef_props = properties(zef.GMM.apps.PlotOpt);
        for zef_i = 2:length(zef_props)
            if strcmp(zef.GMM.apps.PlotOpt.(zef_props{zef_i-1}).Type,'uilabel')
                zef_n=zef_n+1;
                if ~strcmp(zef_props{zef_i},'GMM_colors')
                    zef.GMM.apps.PlotOpt.(zef_props{zef_i}).Value = zef.GMM.parameters.Values{zef_n};
                else
                    if iscell(zef.GMM.parameters{zef_n,2}{1})
                        zef_aux_str = '';
                        for zef_k = 1:length(zef.GMM.parameters{zef_n,2}{1})
                            zef_aux_str = [zef_aux_str,zef.GMM.parameters{zef_n,2}{1}{zef_k},', '];
                        end
                        zef_aux_str = zef_aux_str(1:end-2);
                        zef.GMM.apps.PlotOpt.(zef_props{zef_i}).Value=zef_aux_str;
                        clear zef_k zef_aux_str
                    else
                        zef.GMM.apps.PlotOpt.(zef_props{zef_i}).Value=zef.GMM.parameters{zef_n,2}{1};
                    end
                end
            end
        end
        if strcmp(zef.GMM.apps.PlotOpt.GMM_comp_ord.Value,'3')
            zef.GMM.apps.PlotOpt.GMM_dip_comp.Enable = 'on'; 
            zef.GMM.apps.PlotOpt.GMM_ellip_comp.Enable = 'on';
        else
            zef.GMM.apps.PlotOpt.GMM_dip_comp.Enable = 'off';
            zef.GMM.apps.PlotOpt.GMM_ellip_comp.Enable = 'off';
        end
        
        if strcmp(zef.GMM.apps.PlotOpt.GMM_ellip_coloring.Value,'2')
            zef.GMM.apps.PlotOpt.GMM_colors.Enable = 'on';
        else
            zef.GMM.apps.PlotOpt.GMM_colors.Enable = 'off';
        end
    else
        zef.GMM.apps = rmfield(zef.GMM.apps,'PlotOpt');
    end
end

%_ Export options _
if isfield(zef.GMM.apps,'Export')
    if isvalid(zef.GMM.apps.Export)
        zef.GMM.apps.Export.ComponentTable.Data=[{'model';'dipoles';'parameters'},zef.GMM.parameters.Values{find(strcmp(zef.GMM.parameters.Tags,'saved'))}];
    else
        zef.GMM.apps = rmfield(zef.GMM.apps,'Export');
    end
end

clear zef_props zef_i zef_n