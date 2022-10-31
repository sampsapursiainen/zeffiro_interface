function zef = zef_exp_app_start(zef)
    zef.EXP.app = exp_app;
    if ~isfield(zef.EXP,'parameters')
        zef.EXP.parameters = [];
    end
    %Script piece for either loading values from zef structure or
    %substitute them there if the app is launched first time
    props = properties(zef.EXP.app);
    for n = 1:length(props)
        if contains(zef.EXP.app.(props{n}).Type,'editfield')
            if isfield(zef,props{n})    %load values from zef
                if isnumeric(zef.EXP.app.(props{n}).Value)
                    zef.EXP.app.(props{n}).Value = zef.(props{n});
                    %move the value to EXP.parameters
                    if startsWith(props{n},'exp')       %'exp' is the field name tag for the variables only EXP tool uses
                        zef.EXP.parameters.(props{n}) = zef.(props{n});
                        zef = rmfield(zef,props{n});
                    end
                else
                    zef.EXP.app.(props{n}).Value = num2str(zef.(props{n}));                    
                    if startsWith(props{n},'exp')
                       zef.EXP.parameters.(props{n}) = str2double(zef.EXP.app.(props{n}).Value);
                    end
                end
            elseif isfield(zef.EXP.parameters,props{n})     %if the parameters field exists and have the values
                if isnumeric(zef.EXP.app.(props{n}).Value)
                    zef.EXP.app.(props{n}).Value = zef.EXP.parameters.(props{n});
                else
                    zef.EXP.app.(props{n}).Value = num2str(zef.EXP.parameters.(props{n}));                    
                end
            else        %Initialize values to zef
                if startsWith(props{n},'exp')
                    if isnumeric(zef.EXP.app.(props{n}).Value)
                        zef.EXP.parameters.(props{n}) = zef.EXP.app.(props{n}).Value;
                    else
                        zef.EXP.parameters.(props{n}) = str2double(zef.EXP.app.(props{n}).Value);
                    end
                else
                    if isnumeric(zef.EXP.app.(props{n}).Value)
                        zef.(props{n}) = zef.EXP.app.(props{n}).Value;
                    else
                        zef.(props{n}) = str2double(zef.EXP.app.(props{n}).Value);
                    end
                end
            end
    
            %set functions accordingly
            if startsWith(props{n},'exp')  
                if isnumeric(zef.EXP.app.(props{n}).Value)
                    zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.EXP.parameters.',props{n},'=zef.EXP.app.',props{n},'.Value;'];
                else
                    zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.EXP.parameters.',props{n},'=num2double(zef.EXP.app.',props{n},'.Value);'];
                end
            else        %old school inv_* fields
                if isnumeric(zef.EXP.app.(props{n}).Value)
                    zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.',props{n},'=zef.EXP.app.',props{n},'.Value;'];
                else
                    zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.',props{n},'=str2double(zef.EXP.app.',props{n},'.Value);'];
                end
            end

        elseif strcmp(zef.EXP.app.(props{n}).Type,'uidropdown')
            if isfield(zef,props{n})    %load values from zef
                zef.EXP.app.(props{n}).Value = num2str(zef.(props{n}));
                %move the value to EXP.parameters
                if startsWith(props{n},'exp')
                    zef.EXP.parameters.(props{n}) = zef.(props{n});
                    zef = rmfield(zef,props{n});
                end
            else        %Initialize values to zef
                if startsWith(props{n},'exp')
                    zef.EXP.parameters.(props{n}) = str2num(zef.EXP.app.(props{n}).Value);
                else
                    zef.(props{n}) = str2num(zef.EXP.app.(props{n}).Value);
                end
            end

            %set functions accordingly
            if startsWith(props{n},'exp')  
                zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.EXP.parameters.',props{n},'=str2num(zef.EXP.app.',props{n},'.Value);'];
            else        %old school inv_* fields
                zef.EXP.app.(props{n}).ValueChangedFcn = ['zef.',props{n},'=str2num(zef.EXP.app.',props{n},'.Value);'];
            end
        end
    end

%-----------------------------------------------------------------------------------------------------------------------------------------------
%__ Other functionalities and buttons
if ~isfield(zef.EXP.parameters,'exp_use_multires')
    zef.EXP.parameters.exp_use_multires = false;
else
    if zef.EXP.parameters.exp_use_multires
        zef.EXP.app.exp_multires_n_levels.Enable='on';
        zef.EXP.app.exp_multires_sparsity_factor.Enable='on';
        zef.EXP.app.exp_multires_n_decompositions.Enable='on';
        zef.EXP.app.CreateDecButton.Enable = 'on';
    end
end

if zef.EXP.parameters.exp_hypermode < 3
    zef.EXP.app.exp_beta.Enable='off'; 
    zef.EXP.app.exp_theta0.Enable='off'; 
else 
    zef.EXP.app.exp_beta.Enable='on'; 
    zef.EXP.app.exp_theta0.Enable='on'; 
end

zef.EXP.app.exp_hypermode.ValueChangedFcn = [zef.EXP.app.exp_hypermode.ValueChangedFcn,'if zef.EXP.parameters.exp_hypermode < 3; zef.EXP.app.exp_beta.Enable=''off''; zef.EXP.app.exp_theta0.Enable=''off''; else zef.EXP.app.exp_beta.Enable=''on''; zef.EXP.app.exp_theta0.Enable=''on''; end;'];
zef.EXP.app.UseMultiresolutionButton.ValueChangedFcn = ['zef.EXP.parameters.exp_use_multires = zef.EXP.app.UseMultiresolutionButton.Value; if zef.EXP.parameters.exp_use_multires; zef.EXP.app.exp_multires_n_levels.Enable=''on''; zef.EXP.app.exp_multires_sparsity_factor.Enable=''on''; zef.EXP.app.exp_multires_n_decompositions.Enable=''on''; zef.EXP.app.CreateDecButton.Enable = ''on'';' ...
    ' else zef.EXP.app.exp_multires_n_levels.Enable=''off''; zef.EXP.app.exp_multires_sparsity_factor.Enable=''off''; zef.EXP.app.exp_multires_n_decompositions.Enable=''off''; zef.EXP.app.CreateDecButton.Enable = ''off''; end;'];
zef.EXP.app.CreateDecButton.ButtonPushedFcn = '[zef.EXP.parameters.exp_multires_dec, zef.EXP.parameters.exp_multires_ind, zef.EXP.parameters.exp_multires_count] = exp_make_multires_dec;';
zef.EXP.app.StartButton.ButtonPushedFcn = '[zef.reconstruction,zef.reconstruction_information] = exp_iteration(zef);';
zef.EXP.app.ApplyButton.ButtonPushedFcn = 'zef_exp_init;';
zef.EXP.app.CloseButton.ButtonPushedFcn = 'delete(zef.EXP.app); zef.EXP = rmfield(zef.EXP,''app'');';
zef.EXP.app.UIFigure.CloseRequestFcn = 'delete(zef.EXP.app); zef.EXP = rmfield(zef.EXP,''app'');';

%set fonts
set(findobj(zef.EXP.app.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);