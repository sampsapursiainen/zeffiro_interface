function zef_logarithmic_distribution(parameter_vec)
%Logarithmic distribution
axes(evalin('base','zef.h_axes1'));

h_axes = evalin('base','zef.h_axes1');
cla(h_axes,'reset');

parameter_vec = max(1E-30,parameter_vec);
h_hist = histogram(log10(parameter_vec),200);

hist_y = log10(h_hist.Values);
hist_x = 0.5*(h_hist.BinEdges(1:end-1)+h_hist.BinEdges(2:end));

h_plot = plot(hist_x, hist_y,'k');
set(h_plot,'linewidth',1);

set(gca,'xlim',[min(hist_x) max(hist_x)]);
set(gca,'ylim',[min(hist_y) max(hist_y)]);
set(gca,'xgrid','on');
set(gca,'ygrid','on');

end
