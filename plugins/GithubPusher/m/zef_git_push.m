function zef_git_push(my_key,varargin)

message = '"Regular push."';


if not(isempty(varargin))
    zef_i = 1;
    while zef_i <= length(varargin)
         varargin{zef_i+1}
        eval([varargin{zef_i} '= ''"' varargin{zef_i+1} '"'';']);
        zef_i = zef_i + 2;
    end
end



eval(['!git remote set-url origin https://sampsapursiainen:' my_key '@github.com/sampsapursiainen/zeffiro_interface'])
!git add -A
eval(['!git commit -m ' message])
!git push -u origin

end