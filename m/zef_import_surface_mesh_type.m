function [file, file_path, mesh_type] = zef_surface_mesh_type

selection_cell = {'stl','points','triangles'};

    d = dialog('Position',[300 300 350 150],'Name','Select One','Resize','on');
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[72 70 210 40],...
           'String','Choose mesh item for importing.');
       
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[80 60 200 25],...
           'String',{'Full mesh (STL)';'Points (DAT)';'Triangles (DAT)'},...
           'Callback',@popup_callback);
       
    mesh_type = 1;
       
    uiwait(d);
   
       function popup_callback(popup,event)
          mesh_type = popup.Value;
          close(d)
       end
   
   if ismember(mesh_type,[1])
   [file file_path] = uigetfile('*.stl');
   elseif ismember(mesh_type,[2 3])
       [file file_path] = uigetfile('*.dat');
   end
   
   mesh_type = selection_cell{mesh_type};
   
end