% function []=slidding_callback (src,event)
% %Todo : plot corrsponding figure
%         % modify frame index
%         %link max value to number frame
%         
% val=event.AffectedObject.Value;
% frame=round(val);
% event.AffectedObject.Value=frame;
% 
% disp(zef.h_slider.Value)

    
evalin('base',['zef.frame_start=' ,num2str(round(zef.h_slider.Value)),';']);
evalin('base',['zef.frame_stop=' ,num2str(round(zef.h_slider.Value)),';']);
evalin('base','zef_visualize_surfaces')

% disp(evalin('base',num2str(zef.h_slider.Value)))