function []=slidding_callback

if iscell(evalin('base','zef.reconstruction'))
l_r = evalin('base','length(zef.reconstruction)');
else
l_r = 1;
end

evalin('base',['zef.frame_start=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
evalin('base',['zef.frame_stop=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
evalin('base','zef_visualize_surfaces')
end

