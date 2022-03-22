function zef_git_push(my_key,varargin)

message = '"Regular push."';

if not(isempty(varargin))
    zef_i = 1;
    while zef_i <= length(varargin)
        aux_var = varargin {zef_i + 1};
        if isequal(varargin {zef_i},'message')
            aux_var = char(join(string(aux_var)));
        end
        eval([varargin{zef_i} '= ''' aux_var ''';']);
        zef_i = zef_i + 2;
    end
end

eval(['!git remote set-url origin https://sampsapursiainen:' my_key '@github.com/sampsapursiainen/zeffiro_interface']);

eval(['!git remote set-url origin https://sampsapursiainen:' my_key '@github.com/sampsapursiainen/zeffiro_interface'])
!git pull
!git add -A
eval(['!git commit -m "' message '"']);
!git push -u origin

end
