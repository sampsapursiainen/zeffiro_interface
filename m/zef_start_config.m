warning off;
if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep '/external/SDPT3/']); end
if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep '/external/SeDuMi/']); end
if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep '/external/CVX/']); end
if isequal(zef.zeffiro_restart, 0), evalc('cvx_startup'); end
if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep '/external/fieldtrip/']); end
if isequal(zef.zeffiro_restart, 0), evalc('ft_defaults'); end
if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep '/external/spm12/']); end
 warning on;