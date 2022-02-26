function []=zef_callbackstop(src,~)

if ~src.Value
    evalin('base',['zef.stop_movie=zef.h_pause_movie.Value || ' num2str(src.Value),';'])
    set(src,'foregroundcolor',[0 0 0]);
    set(src,'string','Stop');
else
    evalin('base','zef.stop_movie=1;') ;
    set(src,'foregroundcolor',[1 0 0]);
    set(src,'string','Stopped');
end
