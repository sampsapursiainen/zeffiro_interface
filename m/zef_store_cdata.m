function zef_store_cdata(varargin)

data_status = 1;
cdata_info.frame_start = evalin('base','zef.frame_start');
cdata_info.frame_stop = evalin('base','zef.frame_stop');
cdata_info.frame_step = evalin('base','zef.frame_step');

if not(isempty(varargin))
data_status = varargin{1};
if length(varargin)>1
cdata_info = struct(varargin{2});
end
end

h_fig = evalin('base','zef.h_zeffiro');
h_axes = findobj(h_fig.Children,'Tag','axes1');
h_time_text = findobj(h_fig.Children,'Tag','time_text');
h_c = h_axes.Children;

for i = 1 : length(h_c)

    if find(ismember(properties(h_c(i)),'CData'))
        if isequal(data_status,1)
            h_c(i).UserData = [];
        end

        data_ind = length(h_c(i).UserData)+1;

        if evalin('base','zef.store_cdata')

        h_c(i).UserData(data_ind).CData = h_c(i).CData;
        h_c(i).UserData(data_ind).inv_time_1 = evalin('base','zef.inv_time_1');
        h_c(i).UserData(data_ind).inv_time_2 = evalin('base','zef.inv_time_2');
        h_c(i).UserData(data_ind).inv_time_3 = evalin('base','zef.inv_time_3');
        h_c(i).UserData(data_ind).frame_start = cdata_info.frame_start;
        h_c(i).UserData(data_ind).frame_stop = cdata_info.frame_stop;
        h_c(i).UserData(data_ind).frame_step = cdata_info.frame_step;
        frame_vec = [cdata_info.frame_start : cdata_info.frame_step : cdata_info.frame_stop];
        h_c(i).UserData(data_ind).frame_vec = frame_vec;
        h_c(i).UserData(data_ind).number_of_frames = length(frame_vec);
        if isvalid(h_time_text)
        h_c(i).UserData(data_ind).time_string = h_time_text.String;
        end

        end
        end

end

end