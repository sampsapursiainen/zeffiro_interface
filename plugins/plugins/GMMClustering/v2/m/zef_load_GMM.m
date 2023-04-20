function zef_load_GMM(struct)

if evalin('base','isfield(zef,''GMM'')')
    GMM = evalin('base','zef.GMM');
    if strcmp(GMM.parameters.Tags{end},'saved')
        n_params = 36;
    else
        n_params = 35;
    end
else
    if isfield(struct,'parameters')
    GMM_Tags ={'clustnum','MaxIter','covtype','covident','threshold',...
                'alpha','markercolor','markersize','markerwidth','headtrans',...
                'plotellip','elliptrans','startframe','stopframe','reg','veclength','c_startframe',...
                'c_stopframe','domain','ampframe','amptype','estimate','model_criterion','initial_mode','replicates',...
                'logpost_threshold','comp_prob','smooth_std','comp_ord','dip_num','ellip_num',...
                'dip_comp','ellip_comp','ellip_coloring','colors','saved'}';
    n_params = length(GMM_Tags);
    GMM.parameters = table('Size',[length(GMM_Tags),3],'VariableTypes',{'string','cell','string'},'VariableNames',{'Parameter Names','Values','Tags'});
    GMM.parameters.Tags = GMM_Tags;
    end
end

if isfield(struct,'model')
    GMM.model = struct.model;
end
if isfield(struct,'dipoles')
    GMM.dipoles = struct.dipoles;
end
if isfield(struct,'reconstruction')
    reconstruction = struct.reconstruction;
    assignin('base','zef_rec',reconstruction);
    evalin('base','zef.reconstruction = zef_rec; clear zef_rec;')
end
if isfield(struct,'time_variables')
    GMM.time_variables = struct.time_variables;
end
if isfield(struct,'amplitudes')
    GMM.amplitudes = struct.amplitudes;
end
if isfield(struct,'parameters')
    if size(struct.parameters,1) == n_params
        GMM.parameters = struct.parameters;
    else
        GMM_Tags ={'clustnum','MaxIter','covtype','covident','threshold',...
                'alpha','markercolor','markersize','markerwidth','headtrans',...
                'plotellip','elliptrans','startframe','stopframe','reg','veclength','c_startframe',...
                'c_stopframe','domain','ampframe','amptype','estimate','model_criterion','initial_mode','replicates',...
                'logpost_threshold','comp_prob','smooth_std','comp_ord','dip_num','ellip_num',...
                'dip_comp','ellip_comp','ellip_coloring','colors','saved'}';
        GMM.parameters = table('Size',[length(GMM_Tags),3],'VariableTypes',{'string','cell','string'},'VariableNames',{'Parameter Names','Values','Tags'});
        GMM.parameters.Tags = GMM_Tags;
        n = 1;

        for i = 1:length(GMM_Tags)
            if strcmp(struct.parameters.Tags{n},GMM_Tags{i})
                GMM.parameters(i,:) = struct.parameters(n,:);
                n=min(n+1,size(struct.parameters,1));
            end
        end
        GMM.meta{1} = 22;
        GMM.meta{2} = 28;

    end

end
assignin('base','zef_GMM',GMM);
evalin('base','zef.GMM = zef_GMM; clear zef_GMM;')
end
