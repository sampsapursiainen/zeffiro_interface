%This is the startup script for GMModel app. One must add this as launch
%script to zeffiro_plugins file:
%GMMclustering, inverse_tools, GMModel_start

zef.GMM.apps.main = GMModelApp;

%move possible output of previous version to the GMM structure field
if isfield(zef,'GMModel')
    zef.GMM.model = zef.GMModel;
    zef.GMM.dipoles = zef.GMModelDipoles;
    zef = rmfield(zef,{'GMModel','GMModelDipoles'});
end


if ~isfield(zef.GMM,'parameters')
%_ Initial values _
zef_GMM_values = cell(26,1);

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
zef_GMM_values{7} = zef.GMM.apps.main.GMMcluster_markercolor.ItemsData{1};
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

%_ Advanced plot options initial values _
%Component plotting order
zef_GMM_values{20} = '1';
%manually seleced dipole components
zef_GMM_values{23} = '';
%manually selected ellipsoids
zef_GMM_values{24} = '';
%number of dipoles
if isfield(zef.GMM,'model')
    if iscell(zef.GMM.model)
        zef_GMM_values{21} = num2str(zef.GMM.model{find(~cellfun(@isempty,zef.GMM.model),1)}.NumComponents);
    else
        zef_GMM_values{21} = num2str(zef.GMM.model.NumComponents);
    end
else
    zef_GMM_values{21} = '3';
end

%number of ellipsoids
if isfield(zef.GMM,'model')
    if iscell(zef.GMM.model)
        zef_GMM_values{21} = num2str(zef.GMM.model{find(~cellfun(@isempty,zef.GMM.model),1)}.NumComponents);
    else
        zef_GMM_values{21} = num2str(zef.GMM.model.NumComponents);
    end
else
    zef_GMM_values{21} = '3';
end
%type of ellipsoid coloring
zef_GMM_values{25} = '1';
%manually setted colors
zef_GMM_values{26} = '';

zef_GMM_label_names = repmat({''},length(zef_GMM_values),1);
else
    zef_GMM_values = zef.GMM.parameters{:,2};
    zef_GMM_label_names = zef.GMM.parameters{:,1};
    zef_GMM_tags = zef.GMM.parameters{:,3};
end


zef_props = properties(zef.GMM.apps.main);
zef_n=0;
for zef_i = 2:length(zef_props)
    if strcmp(zef.GMM.apps.main.(zef_props{zef_i-1}).Type,'uilabel')
        zef_n=zef_n+1;
        zef_GMM_label_names{zef_n}=zef.GMM.apps.main.(zef_props{zef_i-1}).Text;
        zef.GMM.apps.main.(zef_props{zef_i}).Value = zef_GMM_values{zef_n};
        if isfield(zef,zef_props{zef_i})
            if ~ischar(zef.(zef_props{zef_i}))
            zef.GMM.apps.main.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
            zef = rmfield(zef,zef_props{zef_i});
            zef_GMM_label_names{zef_n}=zef.GMM.apps.main.(zef_props{zef_i-1}).Text;
            zef_GMM_values{zef_n}=zef.GMM.apps.main.(zef_props{zef_i}).Value;
            else
            zef.GMM.apps.main.(zef_props{zef_i}).Value = zef.(zef_props{zef_i});
            zef = rmfield(zef,zef_props{zef_i});
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
    zef_GMM_tags = [zef_GMM_tags;{'comp_ord';'dip_num';'ellip_num';'dip_comp';'ellip_comp';'ellip_coloring';'colors'}];
end

zef.GMM.parameters = table(zef_GMM_label_names,zef_GMM_values,zef_GMM_tags,'VariableNames',{'Parameter Names','Values','Tags'});

clear zef_props zef_i zef_n zef_GMM_label_names zef_GMM_values zef_GMM_tags

%_ Functions _
zef.GMM.apps.main.GMMcluster_covident.ValueChangedFcn = 'zef.GMM.parameters{4,2} = {zef.GMM.apps.main.GMMcluster_covident.Value};';
zef.GMM.apps.main.GMMcluster_covtype.ValueChangedFcn = 'zef.GMM.parameters{3,2} = {zef.GMM.apps.main.GMMcluster_covtype.Value};';
zef.GMM.apps.main.GMMcluster_MaxIter.ValueChangedFcn = 'zef.GMM.parameters{2,2} = {zef.GMM.apps.main.GMMcluster_MaxIter.Value};';
zef.GMM.apps.main.GMMcluster_threshold.ValueChangedFcn = 'zef.GMM.parameters{5,2} = {zef.GMM.apps.main.GMMcluster_threshold.Value};';
zef.GMM.apps.main.GMMcluster_reg.ValueChangedFcn = 'zef.GMM.parameters{15,2} = {zef.GMM.apps.main.GMMcluster_reg.Value};';
zef.GMM.apps.main.GMMcluster_clustnum.ValueChangedFcn = 'zef.GMM.parameters{1,2} = {zef.GMM.apps.main.GMMcluster_clustnum.Value};';
zef.GMM.apps.main.GMMcluster_alpha.ValueChangedFcn = 'zef.GMM.parameters{6,2}={zef.GMM.apps.main.GMMcluster_alpha.Value};';
zef.GMM.apps.main.GMMcluster_domain.ValueChangedFcn = 'zef.GMM.parameters{19,2} = {zef.GMM.apps.main.GMMcluster_domain.Value};';
zef.GMM.apps.main.GMMcluster_c_startframe.ValueChangedFcn = 'zef.GMM.parameters{17,2}={zef.GMM.apps.main.GMMcluster_c_startframe.Value};';
zef.GMM.apps.main.GMMcluster_c_stopframe.ValueChangedFcn = 'zef.GMM.parameters{18,2}={zef.GMM.apps.main.GMMcluster_c_stopframe.Value};';

zef.GMM.apps.main.GMMcluster_markercolor.ValueChangedFcn = 'zef.GMM.parameters{7,2}={zef.GMM.apps.main.GMMcluster_markercolor.Value};';
zef.GMM.apps.main.GMMcluster_markersize.ValueChangedFcn = 'zef.GMM.parameters{8,2}={zef.GMM.apps.main.GMMcluster_markersize.Value};';
zef.GMM.apps.main.GMMcluster_markerwidth.ValueChangedFcn = 'zef.GMM.parameters{9,2}={zef.GMM.apps.main.GMMcluster_markerwidth.Value};';
zef.GMM.apps.main.GMMcluster_headtrans.ValueChangedFcn = 'zef.GMM.parameters{10,2}={zef.GMM.apps.main.GMMcluster_headtrans.Value};';
zef.GMM.apps.main.GMMcluster_veclength.ValueChangedFcn = 'zef.GMM.parameters{16,2} = {zef.GMM.apps.main.GMMcluster_veclength.Value};';
zef.GMM.apps.main.GMMcluster_plotellip.ValueChangedFcn = 'zef.GMM.parameters{11,2}={zef.GMM.apps.main.GMMcluster_plotellip.Value};';
zef.GMM.apps.main.GMMcluster_elliptrans.ValueChangedFcn = 'zef.GMM.parameters{12,2}={zef.GMM.apps.main.GMMcluster_elliptrans.Value};';
zef.GMM.apps.main.GMMcluster_startframe.ValueChangedFcn = 'zef.GMM.parameters{13,2}={zef.GMM.apps.main.GMMcluster_startframe.Value};';
zef.GMM.apps.main.GMMcluster_stopframe.ValueChangedFcn = 'zef.GMM.parameters{14,2}={zef.GMM.apps.main.GMMcluster_stopframe.Value};';

zef.GMM.apps.main.StartButton.ButtonPushedFcn = '    [zef.GMM.model,zef.GMM.dipoles] = zef_GMModeling;';
zef.GMM.apps.main.CloseButton.ButtonPushedFcn = 'if isfield(zef.GMM.apps,''PlotOpt''); delete(zef.GMM.apps.PlotOpt); end; if isfield(zef.GMM.apps,''Export''); delete(zef.GMM.apps.Export); end; delete(zef.GMM.apps.main);';
zef.GMM.apps.main.PlotOptButton.ButtonPushedFcn = 'zef_GMMPlotOpt;';
zef.GMM.apps.main.PlotButton.ButtonPushedFcn = 'zef_update_GMMPlotOpts; zef_PlotGMModel;';
zef.GMM.apps.main.ExportButton.ButtonPushedFcn = 'zef_GMMExport_start;';
zef.GMM.apps.main.ImportButton.ButtonPushedFcn = 'if not(isempty(zef.save_file_path)) && prod(not(zef.save_file_path==0)); [zef_aux_file,zef_aux_path] = uigetfile(''*.mat'',''Select Gaussian Mixature Model'',zef.save_file_path); else; [zef_aux_file,zef_aux_path] = uigetfile(''*.mat'',''Select Gaussian Mixature Model''); end; if ~isequal(zef_aux_file,0) && ~isequal(zef_aux_path,0); zef_aux = load(fullfile(zef_aux_path,zef_aux_file)); if isfield(zef_aux,''zef_GMModel''); zef.GMM.model = zef_aux.zef_GMModel; zef.GMM.dipoles = zef_aux.zef_GMModelDipoles; elseif isfield(zef_aux,''zef_GMM''); zef_aux = zef_aux.zef_GMM; if isfield(zef_aux,''model''); zef.GMM.model = zef_aux.model; end; if isfield(zef_aux,''dipoles''); zef.GMM.dipoles = zef_aux.dipoles; end; if isfield(zef_aux,''parameters''); zef.GMM.parameters = zef_aux.parameters; zef_GMM_update; end; if isfield(zef_aux,''reconstruction''); zef.reconstruction = zef_aux.reconstruction; end; end; end; clear zef_aux zef_aux_file zef_aux_path;';

%close request function
zef.GMM.apps.main.UIFigure.CloseRequestFcn = 'if isfield(zef.GMM.apps,''PlotOpt''); delete(zef.GMM.apps.PlotOpt); end; if isfield(zef.GMM.apps,''Export''); delete(zef.GMM.apps.Export); end; delete(zef.GMM.apps.main);';

%set fonts
set(findobj(zef.GMM.apps.main.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);