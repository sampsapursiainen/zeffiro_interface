function zef_store_cdata(varargin)
%ZEF_STORE_CDATA  Append current axes1 CData onto each child's UserData.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   zef_store_cdata()
%   zef_store_cdata(data_status)
%   zef_store_cdata(data_status, cdata_info)
%
%   Called from zef_plot_volume / zef_plot_meshes while drawing a frame.
%   Finds zef.h_zeffiro axes1 children with CData. data_status==1 (default)
%   clears UserData first. If zef.store_cdata is true, appends a struct
%   with CData, inv_time_1/2/3, frame_start/stop/step, frame_vec,
%   number_of_frames, and time_text.String. zef_play_cdata reads that
%   stack. System INI Store CData maps to zef.store_cdata.
%
%   See also zef_play_cdata, zef_plot_volume.
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
h_axes = zef_ui_axes(h_fig);
h_time_text = zef_ui_control(h_fig, 'time_text');
h_c = h_axes.Children;

for i = 1 : length(h_c)

    if find(ismember(properties(h_c(i)),'CData'))
        if isequal(data_status,1)
            h_c(i).UserData = [];
        end

        data_ind = length(h_c(i).UserData)+1;

        if evalin('base','zef.store_cdata')

            h_c(i).UserData(data_ind).CData = local_face_cdata(h_c(i));
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

function c = local_face_cdata(h)
% Same array as the patch CData getter when FaceVertexCData is one scalar
% per vertex: each column is that scalar at the face's three vertices.
% The getter gathers this on the graphics thread; indexing matches it.

if isprop(h,'FaceVertexCData') && isprop(h,'Faces') && isprop(h,'Vertices')
    fv = h.FaceVertexCData;
    f = h.Faces;
    nv = size(h.Vertices,1);
    if ~isempty(f) && size(fv,1) == nv && size(fv,2) == 1 && size(f,2) == 3
        fmax = max(f(:));
        fmin = min(f(:));
        if ~isempty(fmax) && fmin >= 1 && fmax <= nv
            c = fv(f.');
            return
        end
    end
end
c = h.CData;

end
