%This is script for opening advanced GMM plot options.

zef.GMM_PlotOpt = GMMclustering_PlotOpt_app;

%Set position besides GMM app
zef.GMM_PlotOpt.UIFigure.Position(2) = zef.GMMclustering.UIFigure.Position(2);
zef_temp_screen_size = get(0, 'ScreenSize');
if zef.GMMclustering.UIFigure.Position(3)+zef.GMM_PlotOpt.UIFigure.Position(3)+zef.GMMclustering.UIFigure.Position(1)>zef_temp_screen_size(3)
    zef.GMM_PlotOpt.UIFigure.Position(1) = zef.GMMclustering.UIFigure.Position(1)-zef.GMM_PlotOpt.UIFigure.Position(3);
else
    zef.GMM_PlotOpt.UIFigure.Position(1) = zef.GMMclustering.UIFigure.Position(1)+zef.GMMclustering.UIFigure.Position(3);
end

zef_init_GMMPlotOpts;

%set parameters if saved in ZI:
%(Naming concept: zef.GMMclustering."field" = zef."field")
zef_props = properties(zef.GMM_PlotOpt);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        if ~ischar(zef.(zef_props{zef_i})) && ~strcmp(zef_props{zef_i},'GMM_colors')
        zef.GMM_PlotOpt.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
        elseif strcmp(zef_props{zef_i},'GMM_colors')
            if isempty(zef.GMM_colors)
                zef.GMM.PlotOpt.(zef_props{zef_i}).Value = '';
            else
            zef_aux_mat = reshape(zef.GMM_colors',[],1)';
            zef_aux_str = ['[',num2str(zef_aux_mat(1))];
            for zef_j = 2:length(zef_aux_mat)
                if mod(zef_j,3)==0
                    zef_aux_str = [zef_aux_str,' ',num2str(zef_aux_mat(zef_j)),'],'];
                elseif mod(zef_j,3)==1
                    zef_aux_str = [zef_aux_str,' [',num2str(zef_aux_mat(zef_j))];
                else
                    zef_aux_str = [zef_aux_str,' ',num2str(zef_aux_mat(zef_j))];
                end
            end
            zef.GMM_PlotOpt.(zef_props{zef_i}).Value = zef_aux_str(1:end-1);
            clear zef_aux_str zef_aux_mat
            end
        else
        zef.GMM_PlotOpt.(zef_props{zef_i}).Value = zef.(zef_props{zef_i});
        end
    end
end
clear zef_props zef_i zef_j zef_temp_screen_size

if zef.GMM_comp_ord == 3
    zef.GMM_PlotOpt.GMM_dip_comp.Enable = 'on';
    zef.GMM_PlotOpt.GMM_ellip_comp.Enable = 'on';
else
    zef.GMM_PlotOpt.GMM_dip_comp.Enable = 'off';
    zef.GMM_PlotOpt.GMM_ellip_comp.Enable = 'off';
end

if zef.GMM_ellip_coloring == 2
    zef.GMM_PlotOpt.GMM_colors.Enable = 'on';
else
    zef.GMM_PlotOpt.GMM_colors.Enable = 'off';
end

zef.GMM_PlotOpt.GMM_comp_ord.ValueChangedFcn = 'zef.GMM_comp_ord = str2num(zef.GMM_PlotOpt.GMM_comp_ord.Value); if zef.GMM_comp_ord == 3; zef.GMM_PlotOpt.GMM_dip_comp.Enable = ''on''; zef.GMM_PlotOpt.GMM_ellip_comp.Enable = ''on''; else zef.GMM_PlotOpt.GMM_dip_comp.Enable = ''off''; zef.GMM_PlotOpt.GMM_ellip_comp.Enable = ''off''; end;';
zef.GMM_PlotOpt.GMM_dip_comp.ValueChangedFcn = 'zef.GMM_dip_comp = str2num(zef.GMM_PlotOpt.GMM_dip_comp.Value);';
zef.GMM_PlotOpt.GMM_ellip_comp.ValueChangedFcn = 'zef.GMM_ellip_comp = str2num(zef.GMM_PlotOpt.GMM_ellip_comp.Value);';
zef.GMM_PlotOpt.GMM_dip_num.ValueChangedFcn = 'zef.GMM_dip_num = str2num(zef.GMM_PlotOpt.GMM_dip_num.Value);';
zef.GMM_PlotOpt.GMM_ellip_num.ValueChangedFcn = 'zef.GMM_ellip_num = str2num(zef.GMM_PlotOpt.GMM_ellip_num.Value);';
zef.GMM_PlotOpt.GMM_ellip_coloring.ValueChangedFcn = 'zef.GMM_ellip_coloring = str2num(zef.GMM_PlotOpt.GMM_ellip_coloring.Value); if zef.GMM_ellip_coloring == 2; zef.GMM_PlotOpt.GMM_colors.Enable = ''on''; else zef.GMM_PlotOpt.GMM_colors.Enable = ''off''; end;';
zef.GMM_PlotOpt.GMM_colors.ValueChangedFcn = 'if isempty(str2num(zef.GMM_PlotOpt.GMM_colors.Value)); zef.GMM_colors = strsplit(erase(zef.GMM_PlotOpt.GMM_colors.Value,{'''''''','' ''}),{'','','';''}); else zef.GMM_colors = str2num(zef.GMM_PlotOpt.GMM_colors.Value); end;';

%set fonts
set(findobj(zef.GMM_PlotOpt.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
