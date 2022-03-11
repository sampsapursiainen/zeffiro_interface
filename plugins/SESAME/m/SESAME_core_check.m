%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%This script checks if the core script of SESAME, 'inverse_SESAME.m', is
%already downloaded. If not, it write a .m script based on the raw form
%from the FGitHub link:
%https://raw.githubusercontent.com/i-am-sorri/SESAME_core/master/inverse_SESAME.m

function SESAME_core_check
%Step 1. Check the exsistence of the script
program_path = evalin("base","zef.program_path");

if ~isfile(fullfile(program_path,'plugins','SESAME','m','inverse_SESAME.m'))
    SESAME_script = webread("https://raw.githubusercontent.com/i-am-sorri/SESAME_core/master/inverse_SESAME.m");
    filename = fullfile(program_path,'plugins','SESAME','m','inverse_SESAME.m');
    file_id = fopen(filename,'w');
    fprintf(file_id,'%s',SESAME_script);
    fclose(file_id);
end

end
