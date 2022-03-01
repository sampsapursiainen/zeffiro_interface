%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_plot_hyperprior

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));

tail_length = evalin('base','zef.inv_hyperprior_tail_length_db');
snr_val = evalin('base','zef.inv_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_snr_val = pm_val;
pm_val = pm_val - amplitude_db;
snr_val = max(1,snr_val);

min_amp_exp = 10;
max_amp_exp = 10;
dt = 0.01;
eps_val = 1e-12;
max_val = 1E6;
t = 10.^[-min_amp_exp:dt:max_amp_exp];
if evalin('base','zef.inv_hyperprior') == 1
[a,b] = zef_find_ig_hyperprior(snr_val,tail_length);
[~,d] = zef_find_ig_hyperprior(snr_val-pm_val,tail_length);
plot_vec = zef_inverse_gamma_gpu(t,a,b*1e4);
plot_vec(isnan(plot_vec)) = -Inf;
plot_vec(plot_vec==Inf) = -Inf;
mean_val = sqrt(b*1e4/(a-1));
elseif evalin('base','zef.inv_hyperprior') == 2
[a,b] = zef_find_g_hyperprior(snr_val,tail_length);
[~,d] = zef_find_g_hyperprior(snr_val-pm_val,tail_length);
plot_vec = zef_gamma_gpu(t,a,b*1e4);
plot_vec(isnan(plot_vec)) = -Inf;
plot_vec(plot_vec==Inf) = -Inf;
mean_val = sqrt(b*1e4*a);
end
tail_val = mean_val.*10.^(max(1,tail_length)/20);
amplitude_val = 10.^(-(pm_val + amplitude_db)/20);

h_loglog = loglog(evalin('base','zef.h_axes1'),sqrt(t),plot_vec,'k');
set(h_loglog,'linewidth',2);
%y_lim_vec = [eps_val eps_val*(plot_vec/eps_val).^(1.05)];
x_lim_vec = [10.^(-min_amp_exp/2) 10.^(max_amp_exp/2) ];
y_lim_vec = [eps_val max_val];

%y_lim_vec = double(y_lim_vec);
%x_lim_vec = double(x_lim_vec);

set(evalin('base','zef.h_axes1'),'xgrid','on');
set(evalin('base','zef.h_axes1'),'ygrid','on');
hold(evalin('base','zef.h_axes1'),'on');
h_line = line(evalin('base','zef.h_axes1'),[mean_val mean_val],y_lim_vec);
set(h_line,'color',0.7*[1 1 1],'linewidth',2,'linestyle','-');
h_line = line(evalin('base','zef.h_axes1'),[tail_val tail_val],y_lim_vec);
set(h_line,'color',0.7*[1 1 1],'linewidth',2,'linestyle','-.');
h_line = line(evalin('base','zef.h_axes1'),[amplitude_val amplitude_val],y_lim_vec);
set(h_line,'color',[0 0 0],'linewidth',2,'linestyle',':');
[min_val,min_ind] = min(abs(sqrt(t)-mean_val));
h_line = line(evalin('base','zef.h_axes1'),x_lim_vec,[plot_vec(min_ind) plot_vec(min_ind)]);
set(h_line,'color',0.7*[1 1 1],'linewidth',2,'linestyle','-');
[min_val,min_ind] = min(abs(sqrt(t)-tail_val));
h_line = line(evalin('base','zef.h_axes1'),x_lim_vec,[plot_vec(min_ind) plot_vec(min_ind)]);
set(h_line,'color',0.7*[1 1 1],'linewidth',2,'linestyle','-.');
[min_val,min_ind] = min(abs(sqrt(t)-pm_val));
h_line = line(evalin('base','zef.h_axes1'),x_lim_vec,[plot_vec(min_ind) plot_vec(min_ind)]);
set(h_line,'color',[0 0 0],'linewidth',2,'linestyle',':');
hold(evalin('base','zef.h_axes1'),'off');
legend(evalin('base','zef.h_axes1'),{'Hyperprior density','Mean','Tail reference','Amplitude reference'},'Location','SouthWest');
%set(evalin('base','zef.h_axes1'),'fontsize',evalin('base','zef.font_size'))

h_text = text(x_lim_vec(1)*10.^(0.7*(log10(x_lim_vec(2))-log10(x_lim_vec(1)))),...
y_lim_vec(1)*10.^(0.10*(log10(y_lim_vec(2))-log10(y_lim_vec(1)))),...
['SNR = ' num2str(snr_val) ' dB']);
set(h_text,'fontsize',get(evalin('base','zef.h_axes1'),'FontSize'));
h_text = text(x_lim_vec(1)*10.^(0.7*(log10(x_lim_vec(2))-log10(x_lim_vec(1)))),...
y_lim_vec(1)*10.^(0.15*(log10(y_lim_vec(2))-log10(y_lim_vec(1)))),...
['PM-SNR = ' num2str(pm_snr_val) ' dB']);
set(h_text,'fontsize',get(evalin('base','zef.h_axes1'),'FontSize'));
h_text = text(x_lim_vec(1)*10.^(0.7*(log10(x_lim_vec(2))-log10(x_lim_vec(1)))),...
y_lim_vec(1)*10.^(0.20*(log10(y_lim_vec(2))-log10(y_lim_vec(1)))),...
['Tail reference = ' num2str(tail_length) ' dB']);
set(h_text,'fontsize',get(evalin('base','zef.h_axes1'),'FontSize'));
h_text = text(x_lim_vec(1)*10.^(0.7*(log10(x_lim_vec(2))-log10(x_lim_vec(1)))),...
y_lim_vec(1)*10.^(0.25*(log10(y_lim_vec(2))-log10(y_lim_vec(1)))),...
['Shape = ' num2str(a)]);
set(h_text,'fontsize',get(evalin('base','zef.h_axes1'),'FontSize'));
h_text = text(x_lim_vec(1)*10.^(0.7*(log10(x_lim_vec(2))-log10(x_lim_vec(1)))),...
y_lim_vec(1)*10.^(0.30*(log10(y_lim_vec(2))-log10(y_lim_vec(1)))),...
['Scale = ' num2str(d)]);
set(h_text,'fontsize',get(evalin('base','zef.h_axes1'),'FontSize'));

hold(evalin('base','zef.h_axes1'),'off');

set(evalin('base','zef.h_axes1'),'ylim',y_lim_vec);
set(evalin('base','zef.h_axes1'),'xlim',x_lim_vec);

h_xlabel = xlabel(evalin('base','zef.h_axes1'),'Prior standard deviation (dB)');
h_ylabel = ylabel(evalin('base','zef.h_axes1'),'Hyperprior density (dB)');
h_xlabel.Position(2) = y_lim_vec(1)*10.^(0.05*(log10(y_lim_vec(2))-log10(y_lim_vec(1))));
h_ylabel.Position(1) = x_lim_vec(1)*10.^(0.035*(log10(x_lim_vec(2))-log10(x_lim_vec(1))));

h_axes = evalin('base','zef.h_axes1');
h_axes.XTickLabelMode = 'manual';
tick_label_vec = 10.^(round(20*[-min_amp_exp/2 : max_amp_exp/2])/20);
tick_label_cell = cell(0);
for i = 1 : length(tick_label_vec)
tick_label_cell{i} = num2str(db(tick_label_vec(i)));
end
h_axes.XTick = tick_label_vec;
h_axes.XTickLabel = tick_label_cell;

h_axes.YTickLabelMode = 'manual';
tick_label_vec = 10.^(round(20*[log10(eps_val): log10(eps_val*10.^(1.05*(log10(max(max_val))-log10(eps_val))))])/20);
tick_label_cell = cell(0);
for i = 1 : length(tick_label_vec)
tick_label_cell{i} = num2str(db(tick_label_vec(i)));
end
h_axes.YTick = tick_label_vec;
h_axes.YTickLabel = tick_label_cell;
