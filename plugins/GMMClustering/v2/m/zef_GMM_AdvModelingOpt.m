%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%This is script for opening advanced GM modeling options.

if isfield(zef.GMM.apps,'ModelingOpt')
    if isvalid(zef.GMM.apps.ModelingOpt)
        eval(zef.GMM.apps.ModelingOpt.UIFigure.CloseRequestFcn);
    end
end

zef.GMM.apps.ModelingOpt = GMM_ModelingOpt;

%Set position besides GMM app
zef.GMM.apps.ModelingOpt.UIFigure.Position(2) = zef.GMM.apps.main.UIFigure.Position(2)+zef.GMM.apps.main.UIFigure.Position(4)-zef.GMM.apps.ModelingOpt.UIFigure.Position(4);
zef_temp_screen_size = get(0, 'ScreenSize');
if zef.GMM.apps.main.UIFigure.Position(3)+zef.GMM.apps.ModelingOpt.UIFigure.Position(3)+zef.GMM.apps.main.UIFigure.Position(1)>zef_temp_screen_size(3)
    zef.GMM.apps.ModelingOpt.UIFigure.Position(1) = zef.GMM.apps.main.UIFigure.Position(1)-zef.GMM.apps.ModelingOpt.UIFigure.Position(3);
else
    zef.GMM.apps.ModelingOpt.UIFigure.Position(1) = zef.GMM.apps.main.UIFigure.Position(1)+zef.GMM.apps.main.UIFigure.Position(3);
end

zef_n = length(findobj(zef.GMM.apps.main.UIFigure.Children,'Type','uilabel'));

%set up new tags
zef_props=findobj(zef.GMM.apps.ModelingOpt.UIFigure,'-property','Value');
zef_props = flip(get(zef_props,'Tag'));
if sum(strcmp(zef.GMM.parameters.Tags,'saved'))==0
    zef.GMM.parameters.Tags = [zef.GMM.parameters.Tags(1:zef_n);zef_props;zef.GMM.parameters.Tags((zef_n+length(zef_props)+1):end)];
else
    zef.GMM.parameters.Tags = [zef.GMM.parameters.Tags(1:zef_n);zef_props;zef.GMM.parameters.Tags((zef_n+length(zef_props)+1):end)];
end

%set parameters if saved in ZI:
%(Naming concept: zef.GMM.apps.main."field" = zef."field")
zef_props = properties(zef.GMM.apps.ModelingOpt);
for zef_i = 2:length(zef_props)
    if strcmp(zef.GMM.apps.ModelingOpt.(zef_props{zef_i-1}).Type,'uilabel')
        zef_n=zef_n+1;
        zef.GMM.parameters(zef_n,1)={zef.GMM.apps.ModelingOpt.(zef_props{zef_i-1}).Text};
        if ~strcmp(zef_props{zef_i},'GMM_colors')
            if ~isempty(zef.GMM.parameters.Values{zef_n})
                zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value=zef.GMM.parameters.Values{zef_n};
            end
        else
            if iscell(zef.GMM.parameters{zef_n,2}{1})
                zef_aux_str = '';
                for zef_k = 1:length(zef.GMM.parameters{zef_n,2}{1})
                    zef_aux_str = [zef_aux_str,zef.GMM.parameters{zef_n,2}{1}{zef_k},', '];
                end
                zef_aux_str = zef_aux_str(1:end-2);
                zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value=zef_aux_str;
                clear zef_k zef_aux_str
            else
                zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value=zef.GMM.parameters{zef_n,2}{1};
            end
        end
        if isfield(zef,zef_props{zef_i})
            if ~ischar(zef.(zef_props{zef_i})) && ~strcmp(zef_props{zef_i},'GMM_colors')
            zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
            elseif strcmp(zef_props{zef_i},'GMM_colors') && ~isempty(zef.GMM_colors)
                if isempty(zef.GMM_colors)
                   zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value = '';
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
                zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value = zef_aux_str(1:end-1);
                clear zef_aux_str zef_aux_mat
                end
            elseif isempty(zef.(zef_props{zef_i}))
                zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value = '';
            else
            	zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value = zef.(zef_props{zef_i});
            end
            %zef = rmfield(zef,zef_props{zef_i});
            zef.GMM.parameters{zef_n,2} = {zef.GMM.apps.ModelingOpt.(zef_props{zef_i}).Value};
        end
    end
end
zef.GMM.meta{2} = zef_n;

clear zef_props zef_i zef_j zef_n zef_temp_screen_size

if strcmp(zef.GMM.apps.ModelingOpt.GMM_initial_mode.Value,'1')
    zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = 'on';
    zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = 'off';
    zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = 'off';
elseif strcmp(zef.GMM.apps.ModelingOpt.GMM_initial_mode.Value,'2')
    zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = 'off';
    zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = 'on';
    zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = 'off';
else
    zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = 'off';
    zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = 'off';
    zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = 'on';
end

zef.GMM.apps.ModelingOpt.GMM_model_criterion.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+1,2} = {zef.GMM.apps.ModelingOpt.GMM_model_criterion.Value};';
zef.GMM.apps.ModelingOpt.GMM_initial_mode.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+2,2} = {zef.GMM.apps.ModelingOpt.GMM_initial_mode.Value}; if strcmp(zef.GMM.parameters{zef.GMM.meta{1}+2,2},''1''); zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = ''on''; zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = ''off''; zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = ''off''; elseif strcmp(zef.GMM.parameters{zef.GMM.meta{1}+2,2},''2''); zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = ''off''; zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = ''on''; zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = ''off''; else zef.GMM.apps.ModelingOpt.GMM_replicates.Enable = ''off''; zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Enable = ''off''; zef.GMM.apps.ModelingOpt.GMM_comp_prob.Enable = ''on''; end;';
zef.GMM.apps.ModelingOpt.GMM_replicates.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+3,2} = {zef.GMM.apps.ModelingOpt.GMM_replicates.Value};';
zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+4,2} = {zef.GMM.apps.ModelingOpt.GMM_logpost_threshold.Value};';
zef.GMM.apps.ModelingOpt.GMM_comp_prob.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+5,2} = {zef.GMM.apps.ModelingOpt.GMM_comp_prob.Value};';
zef.GMM.apps.ModelingOpt.GMM_smooth_std.ValueChangedFcn = 'zef.GMM.parameters{zef.GMM.meta{1}+6,2} = {zef.GMM.apps.ModelingOpt.GMM_smooth_std.Value};';
zef.GMM.apps.ModelingOpt.UIFigure.CloseRequestFcn = 'delete(zef.GMM.apps.ModelingOpt);';

%set fonts
set(findobj(zef.GMM.apps.ModelingOpt.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
