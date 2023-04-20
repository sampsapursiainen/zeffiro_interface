%This is the startup script for GMModel app. One must add this as launch
%script to zeffiro_plugins file:
%GMMing, inverse_tools, GMModel_start

%don't allow to open multiple app window because it cause ether App
%Designer or app's functionalities to crash or both of them
if isfield(zef,'GMM.apps')
if isfield(zef.GMM.apps,'main')
    if isvalid(zef.GMM.apps.main)
        eval(zef.GMM.apps.main.UIFigure.CloseRequestFcn);
    end
end
end
zef.GMM.apps.main = GMModelApp;

if ~isfield(zef.GMM,'parameters')
%_ Initial values _
zef_GMM_values = cell(2,1);

%maximum number of components
zef_GMM_values{1} = '3';
%regularization value
zef_GMM_values{15} = '0.01';
%reconstruction threshold
zef_GMM_values{5} = '0.25';
%maximum iterations
zef_GMM_values{2} = '1000';
%confidence level
zef_GMM_values{6} = '90';
%identity of covariance
zef_GMM_values{4} = '1';
%covariance type
zef_GMM_values{3} = '1';
%target domain
zef_GMM_values{19} = '1';
%centroid marker (color)
zef_GMM_values{7} = zef.GMM.apps.main.GMM_markercolor.ItemsData{1};
%centroid marker size
zef_GMM_values{8} = '8';
%centroid marker line width
zef_GMM_values{9} = '4';
%visual dipole vector length
zef_GMM_values{16} = '3';
%head model transparency
zef_GMM_values{10} = '0.4';
%plot confidence ellipsoids
zef_GMM_values{11} = '1';
%ellipsoid transparency
zef_GMM_values{12} = '0.3';
%start frame
zef_GMM_values{13} = '1';
%stop frame
if iscell(zef.reconstruction)
    zef_GMM_values{14} = num2str(length(zef.reconstruction));
else
    zef_GMM_values{14} = '1';
end
%start frame for calculation
zef_GMM_values{17} = '1';
%stop frame for calculation
if iscell(zef.reconstruction)
    zef_GMM_values{18} = num2str(length(zef.reconstruction));
else
    zef_GMM_values{18} = '1';
end
%time point for amplitude bar plot
zef_GMM_values{20} = '';
%amplitude estimation type
zef_GMM_values{21} = '1';
%Parameters to estimate via GMM
zef_GMM_values{22} = '1';

zef_i = length(zef_GMM_values);
zef.GMM.meta{1} = zef_i;

%_ Advanced modeling options initial values _
%model fitness criterion
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '2';
%initialization approach
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '1';
%number of replicates for k++
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '1';
%log-posterior threshold
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '6';    %log-post = 10^(-db/20)
%Mixture component probability for Mahalanobis distance approach
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '0.95';
%reconstruction smoothing std
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '0';

zef.GMM.meta{2} = zef_i;

%_ Advanced plot options initial values _
%component plotting order
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '1';
%number of dipoles
zef_i = zef_i+1;
if isfield(zef.GMM,'model')
    if iscell(zef.GMM.model)
        zef_GMM_values{zef_i} = num2str(zef.GMM.model{find(~cellfun(@isempty,zef.GMM.model),1)}.NumComponents);
    else
        zef_GMM_values{zef_i} = num2str(zef.GMM.model.NumComponents);
    end
else
    zef_GMM_values{zef_i} = '3';
end
%number of ellipsoids
zef_i = zef_i+1;
if isfield(zef.GMM,'model')
    if iscell(zef.GMM.model)
        zef_GMM_values{zef_i} = num2str(zef.GMM.model{find(~cellfun(@isempty,zef.GMM.model),1)}.NumComponents);
    else
        zef_GMM_values{zef_i} = num2str(zef.GMM.model.NumComponents);
    end
else
    zef_GMM_values{zef_i} = '3';
end
%manually seleced dipole components
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '';
%manually selected ellipsoids
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '';
%type of ellipsoid coloring
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '1';
%manually setted colors
zef_i = zef_i+1;
zef_GMM_values{zef_i} = '';

zef.GMM.meta{3} = zef_i;

zef_GMM_label_names = repmat({''},length(zef_GMM_values),1);
else
    zef_load_GMM(zef.GMM);
    zef_GMM_update;
    zef_GMM_values = zef.GMM.parameters{:,2};
    zef_GMM_label_names = zef.GMM.parameters{:,1};
    zef_GMM_tags = zef.GMM.parameters{:,3};
    zef.GMM.meta{1} = length(findobj(zef.GMM.apps.main.UIFigure,{'Type','uieditfield','-or','Type','uidropdown'}));
end

zef_props = properties(zef.GMM.apps.main);
zef_n=0;
for zef_i = 2:length(zef_props)
    if strcmp(zef.GMM.apps.main.(zef_props{zef_i-1}).Type,'uilabel')
        zef_n=zef_n+1;
        zef_GMM_label_names{zef_n}=zef.GMM.apps.main.(zef_props{zef_i-1}).Text;
        if ~isempty(zef_GMM_values{zef_n}) || ~strcmp(zef.GMM.apps.main.(zef_props{zef_i}).Type,'uidropdown')
        zef.GMM.apps.main.(zef_props{zef_i}).Value = zef_GMM_values{zef_n};
        end
        if isfield(zef,zef_props{zef_i})
            if ~ischar(zef.(zef_props{zef_i}))
            zef.GMM.apps.main.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
            %zef = rmfield(zef,zef_props{zef_i});
            zef_GMM_label_names{zef_n}=zef.GMM.apps.main.(zef_props{zef_i-1}).Text;
            zef_GMM_values{zef_n}=zef.GMM.apps.main.(zef_props{zef_i}).Value;
            else
            zef.GMM.apps.main.(zef_props{zef_i}).Value = zef.(zef_props{zef_i});
            %zef = rmfield(zef,zef_props{zef_i});
            zef_GMM_label_names{zef_n}=zef.GMM.apps.main.(zef_props{zef_i-1}).Text;
            zef_GMM_values{zef_n}=zef.GMM.apps.main.(zef_props{zef_i}).Value;
            end
        end
    end
end

%set up parameters table
if ~isfield(zef.GMM,'parameters')
    zef_GMM_tags=findobj(zef.GMM.apps.main.UIFigure,'-property','Value');
    zef_GMM_tags = flip(get(zef_GMM_tags,'Tag'));
    zef_GMM_tags = [zef_GMM_tags;{'model_criterion';'initial_mode';'replicates';'logpost_threshold';'comp_prob';'smooth_std'}];
    zef_GMM_tags = [zef_GMM_tags;{'comp_ord';'dip_num';'ellip_num';'dip_comp';'ellip_comp';'ellip_coloring';'colors'}];
end

zef.GMM.parameters = table(zef_GMM_label_names,zef_GMM_values,zef_GMM_tags,'VariableNames',{'Parameter Names','Values','Tags'});

clear zef_props zef_i zef_n zef_GMM_label_names zef_GMM_values zef_GMM_tags

%_ Functions _
zef.GMM.apps.main.GMM_covident.ValueChangedFcn = 'zef.GMM.parameters{4,2} = {zef.GMM.apps.main.GMM_covident.Value};';
zef.GMM.apps.main.GMM_covtype.ValueChangedFcn = 'zef.GMM.parameters{3,2} = {zef.GMM.apps.main.GMM_covtype.Value};';
zef.GMM.apps.main.GMM_MaxIter.ValueChangedFcn = 'zef.GMM.parameters{2,2} = {zef.GMM.apps.main.GMM_MaxIter.Value};';
zef.GMM.apps.main.GMM_threshold.ValueChangedFcn = 'zef.GMM.parameters{5,2} = {zef.GMM.apps.main.GMM_threshold.Value};';
zef.GMM.apps.main.GMM_reg.ValueChangedFcn = 'zef.GMM.parameters{15,2} = {zef.GMM.apps.main.GMM_reg.Value};';
zef.GMM.apps.main.GMM_clustnum.ValueChangedFcn = 'zef.GMM.parameters{1,2} = {zef.GMM.apps.main.GMM_clustnum.Value};';
zef.GMM.apps.main.GMM_alpha.ValueChangedFcn = 'zef.GMM.parameters{6,2}={zef.GMM.apps.main.GMM_alpha.Value};';
zef.GMM.apps.main.GMM_domain.ValueChangedFcn = 'zef.GMM.parameters{19,2} = {zef.GMM.apps.main.GMM_domain.Value};';
zef.GMM.apps.main.GMM_c_startframe.ValueChangedFcn = 'zef.GMM.parameters{17,2}={zef.GMM.apps.main.GMM_c_startframe.Value};';
zef.GMM.apps.main.GMM_c_stopframe.ValueChangedFcn = 'zef.GMM.parameters{18,2}={zef.GMM.apps.main.GMM_c_stopframe.Value};';
zef.GMM.apps.main.GMM_ampframe.ValueChangedFcn = 'zef.GMM.parameters{20,2}={zef.GMM.apps.main.GMM_ampframe.Value};';
zef.GMM.apps.main.GMM_amptype.ValueChangedFcn = 'zef.GMM.parameters{21,2} = {zef.GMM.apps.main.GMM_amptype.Value};';
zef.GMM.apps.main.GMM_estimate.ValueChangedFcn = 'zef.GMM.parameters{22,2} = {zef.GMM.apps.main.GMM_estimate.Value};';

zef.GMM.apps.main.GMM_markercolor.ValueChangedFcn = 'zef.GMM.parameters{7,2}={zef.GMM.apps.main.GMM_markercolor.Value};';
zef.GMM.apps.main.GMM_markersize.ValueChangedFcn = 'zef.GMM.parameters{8,2}={zef.GMM.apps.main.GMM_markersize.Value};';
zef.GMM.apps.main.GMM_markerwidth.ValueChangedFcn = 'zef.GMM.parameters{9,2}={zef.GMM.apps.main.GMM_markerwidth.Value};';
zef.GMM.apps.main.GMM_headtrans.ValueChangedFcn = 'zef.GMM.parameters{10,2}={zef.GMM.apps.main.GMM_headtrans.Value};';
zef.GMM.apps.main.GMM_veclength.ValueChangedFcn = 'zef.GMM.parameters{16,2} = {zef.GMM.apps.main.GMM_veclength.Value};';
zef.GMM.apps.main.GMM_plotellip.ValueChangedFcn = 'zef.GMM.parameters{11,2}={zef.GMM.apps.main.GMM_plotellip.Value};';
zef.GMM.apps.main.GMM_elliptrans.ValueChangedFcn = 'zef.GMM.parameters{12,2}={zef.GMM.apps.main.GMM_elliptrans.Value};';
zef.GMM.apps.main.GMM_startframe.ValueChangedFcn = 'zef.GMM.parameters{13,2}={zef.GMM.apps.main.GMM_startframe.Value};';
zef.GMM.apps.main.GMM_stopframe.ValueChangedFcn = 'zef.GMM.parameters{14,2}={zef.GMM.apps.main.GMM_stopframe.Value};';

zef.GMM.apps.main.StartButton.ButtonPushedFcn = 'if ~strcmp(zef.GMM.parameters.Values{zef.GMM.meta{1}+1},''1'') || ~strcmp(zef.GMM.parameters.Values{zef.GMM.meta{1}+2},''1''); [zef.GMM.model,zef.GMM.dipoles,zef.GMM.amplitudes,zef.GMM.time_variables] = zef_GMModeling; else [zef.GMM.model,zef.GMM.dipoles,zef.GMM.amplitudes,zef.GMM.time_variables] = zef_GMModeling_K; end;';
zef.GMM.apps.main.CloseButton.ButtonPushedFcn = 'if isfield(zef.GMM.apps,''PlotOpt''); delete(zef.GMM.apps.PlotOpt); end; if isfield(zef.GMM.apps,''Export''); delete(zef.GMM.apps.Export); end; delete(zef.GMM.apps.main);';
zef.GMM.apps.main.PlotOptMenu.MenuSelectedFcn = 'zef_GMMPlotOpt;';
zef.GMM.apps.main.ModelingOptMenu.MenuSelectedFcn = 'zef_GMM_AdvModelingOpt;';
zef.GMM.apps.main.PlotModelButton.ButtonPushedFcn = 'zef_update_GMMPlotOpts; zef_PlotGMModel;';
zef.GMM.apps.main.PlotAmpButton.ButtonPushedFcn = 'zef_update_GMMPlotOpts; zef_plot_GMM_amplitudes;';
zef.GMM.apps.main.ExportMenu.MenuSelectedFcn = 'zef_GMMExport_start;';
zef.GMM.apps.main.ImportMenu.MenuSelectedFcn = 'if not(isempty(zef.save_file_path)) && prod(not(zef.save_file_path==0)); [zef_aux_file,zef_aux_path] = uigetfile(''*.mat'',''Select Gaussian Mixature Model'',zef.save_file_path); else; [zef_aux_file,zef_aux_path] = uigetfile(''*.mat'',''Select Gaussian Mixature Model''); end; if ~isequal(zef_aux_file,0) && ~isequal(zef_aux_path,0); zef_aux = load(fullfile(zef_aux_path,zef_aux_file)); if isfield(zef_aux,''zef_GMModel''); zef.GMM.model = zef_aux.zef_GMModel; zef.GMM.dipoles = zef_aux.zef_GMModelDipoles; elseif isfield(zef_aux,''zef_GMM''); zef_load_GMM(zef_aux.zef_GMM); zef_GMM_update; end; end; clear zef_aux zef_aux_file zef_aux_path;';

%close request function
zef.GMM.apps.main.UIFigure.CloseRequestFcn = 'if isfield(zef.GMM.apps,''ModelingOpt''); delete(zef.GMM.apps.ModelingOpt); end; if isfield(zef.GMM.apps,''PlotOpt''); delete(zef.GMM.apps.PlotOpt); end; if isfield(zef.GMM.apps,''Export''); delete(zef.GMM.apps.Export); end; delete(zef.GMM.apps.main);';

%set fonts
set(findobj(zef.GMM.apps.main.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
