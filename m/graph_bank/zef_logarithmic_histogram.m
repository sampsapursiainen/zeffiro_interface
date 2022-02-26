function zef_logarithmic_distribution(parameter_vec)
%Logarithmic histogram
axes(evalin('base','zef.h_axes1'));

h_axes = evalin('base','zef.h_axes1');
cla(h_axes,'reset');

h_hist = histogram(log10(parameter_vec),200);
h_hist.FaceColor = [0.5 0.5 0.5];

hist_y = (h_hist.Values);
hist_x = 0.5*(h_hist.BinEdges(1:end-1)+h_hist.BinEdges(2:end));

set(gca,'xlim',[min(hist_x) max(hist_x)]);
set(gca,'ylim',[min(hist_y) max(hist_y)]);
set(gca,'xgrid','on');
set(gca,'ygrid','on');
set(gca,'yscale','log');
end