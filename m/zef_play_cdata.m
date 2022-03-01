function zef_play_cdata(varargin)

warning('off');

show_frame_number = 0;
loop_count = 1;
if not(isempty(varargin))
    loop_count = varargin{1};
    if length(varargin) > 1
        show_frame_number =  varargin{2};
    end
end

movie_fps = evalin('base','zef.movie_fps');
h_fig = gcf;
h_axes = findobj(h_fig.Children,'Tag','axes1');
h_time_text = findobj(h_fig.Children,'Tag','time_text');
h_c = h_axes.Children;

for j = 1 : loop_count

last_frame = 0;
f_ind = 0;

while not(last_frame)

    details_set = 0;
f_ind = f_ind + 1;
if not(isequal(show_frame_number,0))
    last_frame = 1;
end

for i = 1 : length(h_c)

    if find(ismember(properties(h_c(i)),'CData'))

         number_of_frames = h_c(i).UserData(f_ind).number_of_frames;
         if not(isequal(show_frame_number,0))
            f_ind = min(max(1,round(show_frame_number*number_of_frames)),10);
         end
        frame_step = h_c(i).UserData(f_ind).frame_step;
        frame_stop = h_c(i).UserData(f_ind).frame_stop;
        frame_start = h_c(i).UserData(f_ind).frame_start;
        h_c(i).CData = h_c(i).UserData(f_ind).CData;
        if not(details_set)
        set(h_time_text,'String',h_c(i).UserData(f_ind).time_string);
        if isequal(show_frame_number,0)
        evalin('base',['zef.h_slider.Value=' num2str(min(max(0,f_ind/number_of_frames),1)) ';']);
        end
        details_set = 1;
        end
        pause(0.01)
        stop_movie = evalin('base','zef.stop_movie');
                pause(0.01);
                if stop_movie
                    if get(evalin('base','zef.h_pause_movie'),'value') == 1
                        waitfor(evalin('base','zef.h_pause_movie'),'value');
                    else
                        return;
                    end
                end

     if isequal(f_ind, length(h_c(i).UserData))
            last_frame = 1;
        end

    end

end

if isequal(last_frame,0)
           camorbit(h_axes,frame_step*evalin('base','zef.orbit_1')/movie_fps,frame_step*evalin('base','zef.orbit_2')/movie_fps);
end

end

end

warning('on');
end
