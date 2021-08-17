function []=slidding_callback

l_r = evalin('base','(zef.frame_stop-zef.frame_start+zef.frame_step)/zef.frame_step');
evalin('base',['zef.frame_start=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
evalin('base',['zef.frame_stop=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
evalin('base','zef_visualize_surfaces');

end

