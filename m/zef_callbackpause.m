function []=zef_callbackpause(src,~)

if ~src.Value
    evalin('base',['zef.stop_movie=zef.h_stop_movie.Value || ' num2str(src.Value),';'])
    set(src,'foregroundcolor',[0 0 0]);
    set(src,'string','Pause');
else
    evalin('base','zef.stop_movie=1;') ;
    set(src,'foregroundcolor',[1 0 0]);
    set(src,'string','Paused');
end
