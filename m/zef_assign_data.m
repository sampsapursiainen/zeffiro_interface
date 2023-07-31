function zef = zef_assign_data(zef, zef_data)
%zef_assign_data assigns the fields of struct zef_data as
%fields of struct zef.
%Input: struct zef, struct zef_data
%Output: struct zef.

if nargin == 0
    zef_data = evalin('base','zef_data');
    if not(isempty(evalin('base','whos(''zef'')')))
        zef = evalin('base','zef');
    else
        evalin('base','zef = struct;');
    end
end

fieldnames_aux = eval('fieldnames(zef_data)');
for zef_i = 1 : length(fieldnames_aux)
    zef.(fieldnames_aux{zef_i}) = zef_data.(fieldnames_aux{zef_i});
end

if nargout == 0
    assignin('base','zef',zef);
    evalin('base','clear zef_data;');
end

end
