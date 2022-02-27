function zef_assign_data(varargin)

field_extension = [];
if not(isempty(varargin))
field_extension = varargin{1};
end

fieldnames_aux = evalin('base','fieldnames(zef_data)');
for zef_i = 1 : length(fieldnames_aux)
    if isempty(field_extension)
evalin('base',['zef.' fieldnames_aux{zef_i} ' = zef_data.' fieldnames_aux{zef_i} ';' ]);
    else
evalin('base',['zef.' field_extension  fieldnames_aux{zef_i} ' = zef_data.' fieldnames_aux{zef_i} ';']);
    end
end

evalin('base','clear zef_data;');

end