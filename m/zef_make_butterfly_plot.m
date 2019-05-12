%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_make_butterfly_plot(void)


sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');

if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.inv_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:)).^2); 
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max((sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
data_norm = sum((sum(abs(f).^2)))/size(f,2);
%std_lhood = std_lhood^2;
end;
f = f/data_norm;

filter_order = 3;
if size(f,2) > 0 && low_pass > 0
[lp_f_1,lp_f_2] = ellip(filter_order,3,60,low_pass/(sampling_freq/2));
f = filter(lp_f_1,lp_f_2,[zeros(size(f)) f zeros(size(f))]')';
f = f(:,size(f,2)/3+1:2*size(f,2)/3);
end
if size(f,2) > 0 && high_pass > 0
[hp_f_1,hp_f_2] = ellip(filter_order,3,60,high_pass/(sampling_freq/2),'high');
f = filter(hp_f_1,hp_f_2,[zeros(size(f)) f zeros(size(f))]')';
f = f(:,size(f,2)/3+1:2*size(f,2)/3);
end

if size(f,2) > 1  
if evalin('base','zef.inv_time_2') >=0 0 && evalin('base','zef.inv_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size(f,2);
t_vec = [max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1'))): min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))))];
f = f(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1'))): min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')))));
t_vec = (double(t_vec)-1)./sampling_freq;
t = [1:size(f,2)];
%gaussian_window = blackmanharris(length(t))';
%f = f.*gaussian_window;
end
end

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
h_plot = plot(t_vec',f');
set(h_plot,'linewidth',1.5);
set(gca,'xlim',[t_vec(1) t_vec(end)]);
f_range = max(f(:))-min(f(:));
set(gca,'ylim',[min(f(:))-0.05*f_range max(f(:))+0.05*f_range]);
set(evalin('base','zef.h_axes1'),'ygrid','on'); 
set(evalin('base','zef.h_axes1'),'xgrid','on');
set(evalin('base','zef.h_axes1'),'fontsize',14);
set(evalin('base','zef.h_axes1'),'linewidth',2);
end
