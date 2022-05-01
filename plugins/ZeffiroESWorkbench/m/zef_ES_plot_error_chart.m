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
if isempty(findobj('type','figure','Name','ZEFFIRO Interface: ES error chart'))
    f = figure('Name','ZEFFIRO Interface: Error chart','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
   set(f,'Position',[800 400 800 600]);
else
    f = findobj('type','figure','Name','ZEFFIRO Interface: ES error chart');
    figure(f);
    clf(f);
    axes(f.CurrentAxes);
end
%f.Color      = [1 1 1];
%set(1,'renderer','painters')
pbaspect([1 1 1])
%% Tab properties
h = uitabgroup();
tab1 = uitab(h, 'title', 'Current pattern');
set(tab1,'BackgroundColor',[1 1 1])
axes('parent', tab1);
fieldnames_table = fieldnames(loader);
w_ind = [1 2 3 4];
for w = 1:4
    sp_var = cell2mat(loader{1,w_ind(w)});
    printing_imagesc(w);
end

tab2 = uitab(h, 'title', 'Volume current');
set(tab2,'BackgroundColor',[1 1 1])
axes('parent', tab2);
w_ind = [5 6 19 8];
fieldnames_table = fieldnames(loader(:,w_ind));
for w = 1:4
    sp_var = cell2mat(loader{1,w_ind(w)});
    printing_imagesc(w);
end
%% Wrapping up, functions and return of variables
function printing_imagesc(w,varargin)
subplot(2,2,w)
imagesc(sp_var(:,1:end));
colormap(gca, turbo(64));
pbaspect([1 1 1])

fnt_sz = 12;
ax = gca;
%ax.FontSize = fnt_sz;

ax.XLabel.String       = 'Alpha parameter';
ax.XLabel.FontSize     = fnt_sz-2;
ax.XLabel.FontWeight   = 'bold';

ax.XTickLabel          = {num2str(db(load_aux.alpha),'%1.0f')};
ax.XTick               = 1:length(load_aux.alpha);
ax.XTickLabelRotation  = 90;

if evalin('base','zef.ES_search_method') == 1
    ax.YLabel.String = 'Off-field weight (dB)';
    param_val_aux = load_aux.beta;
elseif evalin('base','zef.ES_search_method') == 2
    ax.YLabel.String = 'Off-field weight (dB)';
    param_val_aux = load_aux.kval;
end

ax.YLabel.FontSize     = fnt_sz-2;
ax.YLabel.FontWeight   = 'bold';

ax.YTick               = 1:length(param_val_aux);
ax.YTickLabel          = {num2str(db(param_val_aux),'%1.0f')};
ax.YTickLabelRotation  = 0;

cb = colorbar;
colormap(cb, turbo(64))

if ismember(w,[1,3])
    cb.Ruler.Exponent = -3;
end

hold on;
p = plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
p = plot(sc, sr, 'yp','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',12);

lgd = legend('Location','SouthWest', 'FontName', 'FixedWidth');
lgd.String(1) = {['\alpha : ' num2str(load_aux.alpha(sc), '%1.0f')]};
if evalin('base','zef.ES_search_method') == 1
    lgd.String(2) = {['t : ' num2str(param_val_aux(sr), '%1.0g')]};
else
    lgd.String(2) = {['k : ' num2str(param_val_aux(sr), '%1.0f')]};
end
lgd.AutoUpdate = 'off';

grid on
ax.GridAlpha = 0.3;
ax.GridColor = [0.3 0.3 0.3];
p = plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
hold off

title(fieldnames_table(w));
end
end