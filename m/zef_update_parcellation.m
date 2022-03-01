%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
set(zef.h_parcellation_name,'string',zef.parcellation_name);
set(zef.h_parcellation_tolerance,'string',zef.parcellation_tolerance);
zef.parcellation_list = cell(0);

zef_k = 0;
zef.parcellation_status = [];
zef.parcellation_colormap = [100 100 100]/255;
 for zef_j = 1 : length(zef.parcellation_colortable)
     zef.parcellation_colormap = [zef.parcellation_colormap ; double(zef.parcellation_colortable{zef_j}{3}(:,1:3))/255];
for zef_i = 1 : size(zef.parcellation_colortable{zef_j}{2},1)
    zef_k = zef_k + 1;
    if not(isempty(find(ismember(zef.parcellation_colortable{zef_j}{4},zef.parcellation_colortable{zef_j}{3}(zef_i,5)))))
   if length(zef.parcellation_interp_ind) >= zef_k
       if not(isempty(zef.parcellation_interp_ind{zef_k}))
    zef.parcellation_list{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,1)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,2)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp <SPAN style="color:green">V</SPAN> &nbsp ' [zef.parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ' '  ': ' zef.parcellation_colortable{zef_j}{2}{zef_i}] '</BODY></HTML>'  ];
     zef.parcellation_status(zef_k) = 2;
       else
             zef.parcellation_list{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,1)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,2)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp <SPAN style="color:orange">V</SPAN> &nbsp ' [zef.parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ' '  ': ' zef.parcellation_colortable{zef_j}{2}{zef_i}] '</BODY></HTML>'  ];
      zef.parcellation_status(zef_k) = 1;
       end
   else
        zef.parcellation_list{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,1)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,2)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp <SPAN style="color:orange">V</SPAN> &nbsp ' [zef.parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ' '  ': ' zef.parcellation_colortable{zef_j}{2}{zef_i}] '</BODY></HTML>'  ];
   zef.parcellation_status(zef_k) = 1;
   end
       else
    zef.parcellation_list{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,1)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,2)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp <SPAN style="color:red">X</SPAN> &nbsp ' [zef.parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ' '  ': ' zef.parcellation_colortable{zef_j}{2}{zef_i}] '</BODY></HTML>'  ];
  zef.parcellation_status(zef_k) = 0;
    end
    end
 end
 if isempty(zef.parcellation_list)
     zef.parcellation_list = 1;
 end
 set(zef.h_parcellation_list,'string',zef.parcellation_list,'value',zef.parcellation_selected,'max',zef_k,'min',1)
clear zef_i zef_j zef_k;

set(zef.h_use_parcellation,'value',zef.use_parcellation);
set(zef.h_parcellation_plot_type,'value',zef.parcellation_plot_type);
set(zef.h_parcellation_segment,'string',zef.parcellation_segment);
%set(zef.h_parcellation_merge,'value',zef.parcellation_merge);

if zef.use_parcellation == 0;
    set(zef.h_use_parcellation,'foregroundcolor',[0 0 0]);
    %set(zef.h_parcellation_list,'enable','on');
    set(zef.h_use_parcellation,'string','Activate');
else
    set(zef.h_use_parcellation,'foregroundcolor',[1 0 0]);
    %set(zef.h_parcellation_list,'enable','off');
    set(zef.h_use_parcellation,'string','Active');
end

zef.parcellation_colormap = 0.5*zef.parcellation_colormap;

if  isempty(evalin('base','zef.parcellation_colortable'))
    set(evalin('base','zef.h_import_parcellation_colortable'),'foregroundcolor',[1 0 0]);
else
set(evalin('base','zef.h_import_parcellation_colortable'),'foregroundcolor',[0 0 0]);
end;

if  isempty(evalin('base','zef.parcellation_points'))
    set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[1 0 0]);
else
set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[0 0 0]);
end;

if isempty(zef.parcellation_selected) && not(isempty(zef.parcellation_list))
 set(zef.h_parcellation_list,'value',[1:length(get(zef.h_parcellation_list,'string'))]);
 zef.parcellation_selected = [1:length(get(zef.h_parcellation_list,'string'))];
end

if isfield(zef,'parcellation_status')

if not(isempty(zef.parcellation_status))
if ismember(1,zef.parcellation_status(zef.parcellation_selected))
    set(zef.h_parcellation_interpolation,'foregroundcolor',[1 0.5 0]);
end
end

end

if isfield(zef,'parcellation_list')
zef = rmfield(zef,'parcellation_list');
end

if isfield(zef,'parcellation_status')
zef = rmfield(zef,'parcellation_status');
end
