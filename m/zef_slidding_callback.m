function []=zef_slidding_callback

if evalin('base','zef.store_cdata')
zef_play_cdata(1,get(gcbo,'Value'));
else
l_r = evalin('base','(zef.frame_stop-zef.frame_start+zef.frame_step)/zef.frame_step')
evalin('base',['zef.frame_start=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
evalin('base',['zef.frame_stop=' ,num2str(ceil(l_r*evalin('base','zef.h_slider.Value'))),';']);
if isequal(evalin('base','zef.visualization_type'),2)
evalin('base','zef_visualize_volume');
elseif isequal(evalin('base','zef.visualization_type'),3)
evalin('base','zef_visualize_surfaces');
end

end

end

