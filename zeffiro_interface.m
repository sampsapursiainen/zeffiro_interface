
if not(exist('zef'))
    zef = [];
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)
        error('Another instance of Zeffiro interface already open.')
    end
end
clear zef;
zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
gpuDeviceCount = 0;
end
zef = rmfield(zef, 'ver');
zef.program_path = cd; 
if not(isdeployed)
zef.code_path = '/m';
addpath(genpath([zef.program_path '/m']));
addpath(genpath([zef.program_path '/mlapp']));
addpath([zef.program_path '/fig']);  
addpath([zef.program_path zef.code_path]); 
addpath(genpath([zef.program_path '/plugins']));
end;
zef.ini_cell = readcell('zeffiro_interface.ini','FileType','text');
for zef_i = 1 : size(zef.ini_cell,1)
     if isequal(zef.ini_cell{zef_i,4},'number')
         if isstring(zef.ini_cell{zef_i,2})
      zef.ini_cell{zef_i,2} = str2num(zef.ini_cell{zef_i,2});  
         end
    end
evalin('base',['zef.' zef.ini_cell{zef_i,3} '= evalin(''base'',''zef.ini_cell{zef_i,2}'');']);
end
zef = rmfield(zef,'ini_cell');

if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end

zef.mlapp = 1;

zef_init;
if zef.mlapp == 1
zeffiro_interface_segmentation_tool; 
else
zef.h_zeffiro_window_main = open('zeffiro_interface_segmentation_tool.fig');
end
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontSize'),'FontSize',zef.font_size);


zef.h_temp = findobj(zef.h_zeffiro_window_main,{'parent',zef.h_menu_forward_tools,'-or','parent',zef.h_menu_inverse_tools,'-or','parent',zef.h_menu_multi_tools});
zef.menu_accelerator_vec = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

for zef_k = 1 : length(zef.h_temp); 
if zef_k <= length(zef.menu_accelerator_vec)
    set(zef.h_temp(zef_k),'accelerator',char(zef.menu_accelerator_vec(zef_k))); 
end
end
zef_plugin;
zef.h_temp = findobj(zef.h_zeffiro_window_main,{'parent',zef.h_menu_forward_tools,'-or','parent',zef.h_menu_inverse_tools,'-or','parent',zef.h_menu_multi_tools},'accelerator','');
for zef_j = 1 : length(zef.h_temp); 
if zef_k + zef_j <= length(zef.menu_accelerator_vec)
    set(zef.h_temp(zef_j),'accelerator',char(zef.menu_accelerator_vec(zef_k+zef_j))); 
end
end
clear zef_j zef_k
zef = rmfield(zef,'h_temp');
zef = rmfield(zef,'menu_accelerator_vec');

zef.o_h = findall(zef.h_zeffiro_window_main);
%zef.h_axes2 = findobj(zef.o_h,'Type','Axes');
%zef.h_axes2  = zef.h_axes2(1); 
zef=rmfield(zef,'o_h');
zef.clear_axes1 = 0;

if not(isequal(zef.mlapp,1))
    
set(zef.h_pushbutton2,'Callback',[get(zef.h_pushbutton2,'Callback') 'if zef.w_merge; zef.w_submesh_ind = [zef.w_submesh_ind size(zef.w_triangles,1)]; else zef.w_submesh_ind = [size(zef.w_triangles,1)]; end;']);
set(zef.h_pushbutton4,'Callback',[get(zef.h_pushbutton4,'Callback') 'if zef.g_merge; zef.g_submesh_ind = [zef.g_submesh_ind size(zef.g_triangles,1)]; else zef.g_submesh_ind = [size(zef.g_triangles,1)]; end;']);
set(zef.h_pushbutton6,'Callback',[get(zef.h_pushbutton6,'Callback') 'if zef.c_merge; zef.c_submesh_ind = [zef.c_submesh_ind size(zef.c_triangles,1)]; else zef.c_submesh_ind = [size(zef.c_triangles,1)]; end;']);
set(zef.h_pushbutton8,'Callback',[get(zef.h_pushbutton8,'Callback') 'if zef.sk_merge; zef.sk_submesh_ind = [zef.sk_submesh_ind size(zef.sk_triangles,1)]; else zef.sk_submesh_ind = [size(zef.sk_triangles,1)]; end;']);
set(zef.h_pushbutton10,'Callback',[get(zef.h_pushbutton10,'Callback') 'if zef.sc_merge; zef.sc_submesh_ind = [zef.sc_submesh_ind size(zef.sc_triangles,1)]; else zef.sc_submesh_ind = [size(zef.sc_triangles,1)]; end;']);
set(zef.h_pushbutton102,'Callback',[get(zef.h_pushbutton102,'Callback') 'if zef.d1_merge; zef.d1_submesh_ind = [zef.d1_submesh_ind size(zef.d1_triangles,1)]; else zef.d1_submesh_ind = [size(zef.d1_triangles,1)]; end;']);
set(zef.h_pushbutton202,'Callback',[get(zef.h_pushbutton202,'Callback') 'if zef.d2_merge; zef.d2_submesh_ind = [zef.d2_submesh_ind size(zef.d2_triangles,1)]; else zef.d2_submesh_ind = [size(zef.d2_triangles,1)]; end;']);
set(zef.h_pushbutton302,'Callback',[get(zef.h_pushbutton302,'Callback') 'if zef.d3_merge; zef.d3_submesh_ind = [zef.d3_submesh_ind size(zef.d3_triangles,1)]; else zef.d3_submesh_ind = [size(zef.d3_triangles,1)]; end;']);
set(zef.h_pushbutton402,'Callback',[get(zef.h_pushbutton402,'Callback') 'if zef.d4_merge; zef.d4_submesh_ind = [zef.d4_submesh_ind size(zef.d4_triangles,1)]; else zef.d4_submesh_ind = [size(zef.d4_triangles,1)]; end;']);
set(zef.h_d5_button_2,'Callback',[get(zef.h_d5_button_2,'Callback') 'if zef.d5_merge; zef.d5_submesh_ind = [zef.d5_submesh_ind size(zef.d5_triangles,1)]; else zef.d5_submesh_ind = [size(zef.d5_triangles,1)]; end;']);
set(zef.h_d6_button_2,'Callback',[get(zef.h_d6_button_2,'Callback') 'if zef.d6_merge; zef.d6_submesh_ind = [zef.d6_submesh_ind size(zef.d6_triangles,1)]; else zef.d6_submesh_ind = [size(zef.d6_triangles,1)]; end;']);
set(zef.h_d7_button_2,'Callback',[get(zef.h_d7_button_2,'Callback') 'if zef.d7_merge; zef.d7_submesh_ind = [zef.d7_submesh_ind size(zef.d7_triangles,1)]; else zef.d7_submesh_ind = [size(zef.d7_triangles,1)]; end;']);
set(zef.h_d8_button_2,'Callback',[get(zef.h_d8_button_2,'Callback') 'if zef.d8_merge; zef.d8_submesh_ind = [zef.d8_submesh_ind size(zef.d8_triangles,1)]; else zef.d8_submesh_ind = [size(zef.d8_triangles,1)]; end;']);
set(zef.h_d9_button_2,'Callback',[get(zef.h_d9_button_2,'Callback') 'if zef.d9_merge; zef.d9_submesh_ind = [zef.d9_submesh_ind size(zef.d9_triangles,1)]; else zef.d9_submesh_ind = [size(zef.d9_triangles,1)]; end;']);
set(zef.h_d10_button_2,'Callback',[get(zef.h_d10_button_2,'Callback') 'if zef.d10_merge; zef.d10_submesh_ind = [zef.d10_submesh_ind size(zef.d10_triangles,1)]; else zef.d10_submesh_ind = [size(zef.d10_triangles,1)]; end;']);
set(zef.h_d11_button_2,'Callback',[get(zef.h_d11_button_2,'Callback') 'if zef.d11_merge; zef.d11_submesh_ind = [zef.d11_submesh_ind size(zef.d11_triangles,1)]; else zef.d11_submesh_ind = [size(zef.d11_triangles,1)]; end;']);
set(zef.h_d12_button_2,'Callback',[get(zef.h_d12_button_2,'Callback') 'if zef.d12_merge; zef.d12_submesh_ind = [zef.d12_submesh_ind size(zef.d12_triangles,1)]; else zef.d12_submesh_ind = [size(zef.d12_triangles,1)]; end;']);
set(zef.h_d13_button_2,'Callback',[get(zef.h_d13_button_2,'Callback') 'if zef.d13_merge; zef.d13_submesh_ind = [zef.d13_submesh_ind size(zef.d13_triangles,1)]; else zef.d13_submesh_ind = [size(zef.d13_triangles,1)]; end;']);
set(zef.h_d14_button_2,'Callback',[get(zef.h_d14_button_2,'Callback') 'if zef.d14_merge; zef.d14_submesh_ind = [zef.d14_submesh_ind size(zef.d14_triangles,1)]; else zef.d14_submesh_ind = [size(zef.d14_triangles,1)]; end;']);
set(zef.h_d15_button_2,'Callback',[get(zef.h_d15_button_2,'Callback') 'if zef.d15_merge; zef.d15_submesh_ind = [zef.d15_submesh_ind size(zef.d15_triangles,1)]; else zef.d15_submesh_ind = [size(zef.d15_triangles,1)]; end;']);
set(zef.h_d16_button_2,'Callback',[get(zef.h_d16_button_2,'Callback') 'if zef.d16_merge; zef.d16_submesh_ind = [zef.d16_submesh_ind size(zef.d16_triangles,1)]; else zef.d16_submesh_ind = [size(zef.d16_triangles,1)]; end;']);
set(zef.h_d17_button_2,'Callback',[get(zef.h_d17_button_2,'Callback') 'if zef.d17_merge; zef.d17_submesh_ind = [zef.d17_submesh_ind size(zef.d17_triangles,1)]; else zef.d17_submesh_ind = [size(zef.d17_triangles,1)]; end;']);
set(zef.h_d18_button_2,'Callback',[get(zef.h_d18_button_2,'Callback') 'if zef.d18_merge; zef.d18_submesh_ind = [zef.d18_submesh_ind size(zef.d18_triangles,1)]; else zef.d18_submesh_ind = [size(zef.d18_triangles,1)]; end;']);
set(zef.h_d19_button_2,'Callback',[get(zef.h_d19_button_2,'Callback') 'if zef.d19_merge; zef.d19_submesh_ind = [zef.d19_submesh_ind size(zef.d19_triangles,1)]; else zef.d19_submesh_ind = [size(zef.d19_triangles,1)]; end;']);
set(zef.h_d20_button_2,'Callback',[get(zef.h_d20_button_2,'Callback') 'if zef.d20_merge; zef.d20_submesh_ind = [zef.d20_submesh_ind size(zef.d20_triangles,1)]; else zef.d20_submesh_ind = [size(zef.d20_triangles,1)]; end;']);
set(zef.h_d21_button_2,'Callback',[get(zef.h_d21_button_2,'Callback') 'if zef.d21_merge; zef.d21_submesh_ind = [zef.d21_submesh_ind size(zef.d21_triangles,1)]; else zef.d21_submesh_ind = [size(zef.d21_triangles,1)]; end;']);
set(zef.h_d22_button_2,'Callback',[get(zef.h_d22_button_2,'Callback') 'if zef.d22_merge; zef.d22_submesh_ind = [zef.d22_submesh_ind size(zef.d22_triangles,1)]; else zef.d22_submesh_ind = [size(zef.d22_triangles,1)]; end;']);
    
end

zef_figure_tool;
zef_mesh_tool;
zeffiro_interface_mesh_visualization_tool;
zef_update;


