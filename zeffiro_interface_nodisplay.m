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

zef.clear_axes1 = 0;

zef_update_compartments_nodisplay;








