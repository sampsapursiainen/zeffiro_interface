set(zef.h_parcellation_name,'string',zef.parcellation_name);
set(zef.h_parcellation_tolerance,'string',zef.parcellation_tolerance);
if size(zef.parcellation_colortable,1) > 0
zef_k = 0; 
zef.parcellation_aux = cell(0);
zef.parcellation_colormap = [100 100 100]/255;
%zef.parcellation_aux{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colormap(1)) ',' num2str(zef.parcellation_colormap(2)) ',' num2str(zef.parcellation_colormap(3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp BG ' num2str(0,'%03d') ': Background </BODY></HTML>'  ];
%zef.parcellation_colormap = zef.parcellation_colormap/255;
 for zef_j = 1 : length(zef.parcellation_colortable)
     zef.parcellation_colormap = [zef.parcellation_colormap ; double(zef.parcellation_colortable{zef_j}{3}(:,1:3))/255];
for zef_i = 1 : size(zef.parcellation_colortable{zef_j}{2},1)
    zef_k = zef_k + 1; 
 zef.parcellation_aux{zef_k} = ['<HTML><BODY>'   '&nbsp <SPAN bgcolor="rgb(' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,1)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,2)) ',' num2str(zef.parcellation_colortable{zef_j}{3}(zef_i,3))  ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp  ' [zef.parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ' '  ': ' zef.parcellation_colortable{zef_j}{2}{zef_i}] '</BODY></HTML>'  ];
end
end
set(zef.h_parcellation_list,'string',zef.parcellation_aux,'value',zef.parcellation_selected,'max',zef_k,'min',1)
clear zef_i zef_j zef_k;
else
set(zef.h_parcellation_list, 'string', '','max',10,'min',1)
end
set(zef.h_use_parcellation,'value',zef.use_parcellation);
set(zef.h_parcellation_segment,'string',zef.parcellation_segment);
set(zef.h_parcellation_merge,'value',zef.parcellation_merge);

if zef.use_parcellation == 0; 
    set(zef.h_use_parcellation,'foregroundcolor',[0 0 0]); 
    set(zef.h_parcellation_list,'enable','on');
    set(zef.h_use_parcellation,'string','Inactive');
else
    set(zef.h_use_parcellation,'foregroundcolor',[1 0 0]); 
    set(zef.h_parcellation_list,'enable','off'); 
    set(zef.h_use_parcellation,'string','Active');
end

if isfield(zef,'parcellation_aux')
rmfield(zef,'parcellation_aux');
end