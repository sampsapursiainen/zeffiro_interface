%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_make_butterfly_plot(varargin)

f = zef_getFilteredData('bf');
[f,t] = zef_getTimeStep(f,1,false,'bf'); 

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'),'reset');
hold(evalin('base','zef.h_axes1'),'off');
h_plot = plot(t',f');
set(h_plot,'linewidth',0.5);
set(gca,'xlim',[t(1) t(end)]);
f_range = max(f(:))-min(f(:));
set(gca,'ylim',[min(f(:))-0.05*f_range max(f(:))+0.05*f_range]);
set(evalin('base','zef.h_axes1'),'ygrid','on');
set(evalin('base','zef.h_axes1'),'xgrid','on');
set(evalin('base','zef.h_axes1'),'fontsize',14);
set(evalin('base','zef.h_axes1'),'linewidth',0.5);
set(gca,'box','on');
end
