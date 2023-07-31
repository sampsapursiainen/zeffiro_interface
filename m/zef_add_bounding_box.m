function zef = zef_add_bounding_box(zef,name_str)

if nargin == 0
    zef = evalin('base','zef');
end

if nargin < 2
    name_str = 'Box';
end

zef = zef_add_compartment(zef);
eval(['zef.' zef.compartment_tags{1} '_name = ''' name_str ''';']);
eval(['zef.' zef.compartment_tags{1} '_sources = -1;']);
eval(['zef.' zef.compartment_tags{1} '_visible = 0;']);
zef.compartment_tags = [zef.compartment_tags(2:end) zef.compartment_tags(1)];
zef = zef_build_compartment_table(zef);

if nargout == 0
    assignin('base','zef',zef);
end

end
