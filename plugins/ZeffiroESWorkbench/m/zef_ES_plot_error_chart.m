function zef_ES_plot_error_chart
%% Variables and parameters setup
try
    load_aux = evalin('base','zef.y_ES_interval');
catch
    if not(isfield(evalin('base','zef'),'y_ES_interval'))
        error('There are no values calculated yet...')
    end
end
[loader, sr, sc] = zef_ES_objective_function;
%% Figure and Axes
if isempty(findobj('type','figure','Name','ZEFFIRO Interface: Error chart tool'))
    f = figure('Name','ZEFFIRO Interface: Error chart tool','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
    set(f,'Position',[1396 400 1163 933]);
else
    f = findobj('type','figure','Name','ZEFFIRO Interface: Error chart tool');
    axes(f.CurrentAxes);
    clf(f.CurrentAxes);
end
% Original
%f.PaperUnits = 'inches';
%f.Units      = 'inches';
%f.Renderer   = 'zbuffer';
f.Color      = [1 1 1];
set(1,'renderer','painters')
%set(f,'Position',[14 2 14 12])
pbaspect([1 1 1])
%% Tab 1 properties
% h = uitabgroup();
% 
% tab1 = uitab(h, 'title', 'Y_ES');
% set(tab1,'BackgroundColor',[1 1 1])
% axes('parent', tab1);

fieldnames_table = fieldnames(loader);

for w = 1:4
%for w = [1,5,6]
    recon = char(evalin('base','recon'));
    method =     evalin('base','method');
    
    sp_var = cell2mat(loader{1,w});
    printing_imagesc(w, recon);
    str = regexprep(char(fieldnames_table(w)), ' +', '_');      
    %print(gcf,['imagesc_' recon '_' num2str(evalin('base','zef.ES_scoredose')) 'chn_' method '_' str],'-djpeg', '-r200')
end

% tab2 = uitab(h, 'title', 'Volumetric');
% axes('parent', tab2);
% 
% fieldnames_table = fieldnames(loader(:,[5:8]));
% for w = 1:4
%     sp_var = cell2mat(loader{1,w+4});
%     printing_imagesc(w, recon);
% end
%% Wrapping up, functions and return of variables
function printing_imagesc(w,varargin)
subplot(2,2,w)
imagesc(sp_var(:,1:end));
colormap('jet');
pbaspect([1 1 1])

fnt_sz = 40;
ax = gca;
ax.TickLabelInterpreter = 'Latex';
ax.FontSize = fnt_sz;

%ax.XLabel.String       = 'Regularization parameter';
ax.XLabel.FontSize     = fnt_sz;
ax.XLabel.FontWeight   = 'bold';

%ax.XTickLabel          = {num2str(load_aux.reg_param,'%1.2g')};
ax.XTick               = 1:length(load_aux.reg_param);
ax.XTickLabel(1)       = {num2str(load_aux.reg_param(1),'%1.0g')};
ax.XTickLabel(2:end-1) = {char(' ')};
ax.XTickLabel(13)      = {num2str(load_aux.reg_param(13),'%1.0g')};
ax.XTickLabel(end)     = {num2str(load_aux.reg_param(end),'%1.0g')};
ax.XTickLabelRotation  = 0;

if evalin('base','zef.ES_search_method') == 1
    %ax.YLabel.String = 'Optimizer tolerance';
    param_val_aux = load_aux.optimizer_tolerance;
elseif evalin('base','zef.ES_search_method') == 2
    %ax.YLabel.String = 'Weighted k-value';
    param_val_aux = load_aux.k_val;
end

ax.YLabel.FontSize     = fnt_sz;
ax.YLabel.FontWeight   = 'bold';

ax.YTick               = 1:length(param_val_aux);
%ax.YTickLabel          = {num2str(param_val_aux,'%1.2g')};
ax.YTickLabel(1)       = {'0.1'};
ax.YTickLabel(2:end-1) = {char(' ')};
ax.YTickLabel(13)      = {sprintf('%1.0g',param_val_aux(13))};
ax.YTickLabel(end)     = {'1e-10'};
ax.YTickLabelRotation  = 0;

cb                = colorbar;
cb.TickLabelInterpreter = 'Latex';
colormap(cb, jet(length(sp_var(:,1:end))-1))
if w ~= 6
    cb.Ruler.Exponent = -3;
end

% ax.XTick = [];
% ax.YTick = [];

hold on;
p = plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',32);
p = plot(sc, sr, 'yp','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',32);

lgd = legend('Location','SouthWest', 'FontName', 'FixedWidth');
lgd.Interpreter = 'Latex';
lgd.String(1) = {['$\alpha$ : ' num2str(load_aux.reg_param(sc), '%1.2g')]};
if evalin('base','zef.ES_search_method') == 1
    lgd.String(2) = {['t : ' num2str(param_val_aux(sr), '%1.2g')]};
else
    lgd.String(2) = {['k : ' num2str(param_val_aux(sr), '%1.2g')]};
end
lgd.AutoUpdate = 'off';

grid on
ax.GridAlpha = 0.3;
ax.GridColor = [0.3 0.3 0.3];
%ax.Layer = 'top';
p = plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',32);
hold off

%title(fieldnames_table(w));
end
function printing_heatmap(w)
    subplot(2,2,w)
    h_map = heatmap(num2str(load_aux.reg_param, '%1.2e'), num2str(load_aux.optimizer_tolerance, '%1.2e'), sp_var);
    if load_aux.reg_param(1) == 1
        h_map.XData(1) = cellstr('1');
    end
    colormap('jet');
    set(h_map.NodeChildren(3), 'XTickLabelRotation', 90)
    xlabel('Regularization parameter');
    ylabel('Optimizer tolerance');
    title(fieldnames_table(w));
end
end