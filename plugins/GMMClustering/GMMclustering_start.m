%This is the startup script for GMMclustering app. One must add this as launch
%script to zeffiro_plugins file:
%GMMclustering, inverse_tools, GMMclustering_start

zef.GMMclustering = GMMclustering_app;

%_ Initial values _

if ~isfield(zef,'GMMcluster_clustnum')
    zef.GMMcluster_clustnum = 3;
end
if ~isfield(zef,'GMMcluster_reg')
    zef.GMMcluster_reg = 0.05;
end
if ~isfield(zef,'GMMcluster_threshold')
    zef.GMMcluster_threshold = 0.25;
end
if ~isfield(zef,'GMMcluster_MaxIter')
    zef.GMMcluster_MaxIter = 1000;
end
if ~isfield(zef,'GMMcluster_alpha')
    zef.GMMcluster_alpha = 90;
end
if ~isfield(zef,'GMMcluster_covident')
    zef.GMMcluster_covident = 1;
end
if ~isfield(zef,'GMMcluster_covtype')
    zef.GMMcluster_covtype = 1;
end
if ~isfield(zef,'GMMcluster_markercolor')
    zef.GMMcluster_markercolor = zef.GMMclustering.GMMcluster_markercolor.ItemsData{1};
end
if ~isfield(zef,'GMMcluster_markersize')
    zef.GMMcluster_markersize = 16;
end
if ~isfield(zef,'GMMcluster_markerwidth')
    zef.GMMcluster_markerwidth = 4;
end
if ~isfield(zef,'GMMcluster_veclength')
    zef.GMMcluster_veclength = 3;
end
if ~isfield(zef,'GMMcluster_headtrans')
    zef.GMMcluster_headtrans = 0.4;
end
if ~isfield(zef,'GMMcluster_plotellip')
    zef.GMMcluster_plotellip = 1;
end
if ~isfield(zef,'GMMcluster_elliptrans')
    zef.GMMcluster_elliptrans = 0.3;
end
if ~isfield(zef,'GMMcluster_startframe')
    zef.GMMcluster_startframe = 1;
end
if ~isfield(zef,'GMMcluster_stopframe')
    if iscell(zef.reconstruction)
        zef.GMMcluster_stopframe = length(zef.reconstruction);
    else
        zef.GMMcluster_stopframe = 1;
    end
end

%set parameters if saved in ZI: 
%(Naming concept: zef.GMMclustering."field" = zef."field")
zef_props = properties(zef.GMMclustering);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        if ~ischar(zef.(zef_props{zef_i}))
        zef.GMMclustering.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
        else
        zef.GMMclustering.(zef_props{zef_i}).Value = zef.(zef_props{zef_i});
        end
    end
end
clear zef_props zef_i

%_ Functions _
zef.GMMclustering.GMMcluster_covident.ValueChangedFcn = 'zef.GMMcluster_covident = str2num(zef.GMMclustering.GMMcluster_covident.Value);';
zef.GMMclustering.GMMcluster_covtype.ValueChangedFcn = 'zef.GMMcluster_covtype = str2num(zef.GMMclustering.GMMcluster_covtype.Value);';
zef.GMMclustering.GMMcluster_MaxIter.ValueChangedFcn = 'zef.GMMcluster_MaxIter = str2num(zef.GMMclustering.GMMcluster_MaxIter.Value);';
zef.GMMclustering.GMMcluster_reg.ValueChangedFcn = 'zef.GMMcluster_reg = str2num(zef.GMMclustering.GMMcluster_reg.Value);';
zef.GMMclustering.GMMcluster_clustnum.ValueChangedFcn = 'zef.GMMcluster_clustnum = str2num(zef.GMMclustering.GMMcluster_clustnum.Value);';
zef.GMMclustering.GMMcluster_alpha.ValueChangedFcn = 'zef.GMMcluster_alpha=str2num(zef.GMMclustering.GMMcluster_alpha.Value);';
zef.GMMclustering.GMMcluster_markercolor.ValueChangedFcn = 'zef.GMMcluster_markercolor=zef.GMMclustering.GMMcluster_markercolor.Value;';
zef.GMMclustering.GMMcluster_markersize.ValueChangedFcn = 'zef.GMMcluster_markersize=str2num(zef.GMMclustering.GMMcluster_markersize.Value);';
zef.GMMclustering.GMMcluster_markerwidth.ValueChangedFcn = 'zef.GMMcluster_markerwidth=str2num(zef.GMMclustering.GMMcluster_markerwidth.Value);';
zef.GMMclustering.GMMcluster_headtrans.ValueChangedFcn = 'zef.GMMcluster_headtrans=str2num(zef.GMMclustering.GMMcluster_headtrans.Value);';
zef.GMMclustering.GMMcluster_veclength.ValueChangedFcn = 'zef.GMMcluster_veclength = str2num(zef.GMMclustering.GMMcluster_veclength.Value);';
zef.GMMclustering.GMMcluster_plotellip.ValueChangedFcn = 'zef.GMMcluster_plotellip=str2num(zef.GMMclustering.GMMcluster_plotellip.Value);';
zef.GMMclustering.GMMcluster_elliptrans.ValueChangedFcn = 'zef.GMMcluster_elliptrans=str2num(zef.GMMclustering.GMMcluster_elliptrans.Value);';
zef.GMMclustering.GMMcluster_startframe.ValueChangedFcn = 'zef.GMMcluster_startframe=str2num(zef.GMMclustering.GMMcluster_startframe.Value);';
zef.GMMclustering.GMMcluster_stopframe.ValueChangedFcn = 'zef.GMMcluster_stopframe=str2num(zef.GMMclustering.GMMcluster_stopframe.Value);';

zef.GMMclustering.StartButton.ButtonPushedFcn = '[zef.GMModel,zef.GMModelDipoles] = zef_GMMcluster;';
zef.GMMclustering.CloseButton.ButtonPushedFcn = 'delete(zef.GMMclustering);';
zef.GMMclustering.PlotButton.ButtonPushedFcn = 'zef_PlotGMMcluster;';

%set fonts
set(findobj(zef.GMMclustering.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);