function [aux_compartment_ind, aux_brain_ind, property_compartment, property_brain] = zef_get_active_compartments(varargin)

property_name = cell(0);
property_compartment = cell(0);
property_brain = [];

if not(isempty(varargin))
    property_name = varargin{1};
end

compartment_tags = evalin('base','zef.compartment_tags');

aux_compartment_ind = zeros(length(compartment_tags),1);
aux_brain_ind = zeros(length(compartment_tags),1);

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
submesh_cell = cell(0);
for k = 1 : length(compartment_tags)

        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_submesh_ind'];
        var_4 = ['zef.' compartment_tags{k} '_sources'];

on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
submesh_cell{i} = evalin('base',var_3);
aux_compartment_ind(k) = i;

if ismember(evalin('base',var_4),[1 2])
    aux_brain_ind(k) = i;
end

end

end

aux_compartment_ind = find(aux_compartment_ind);
aux_brain_ind = find(aux_brain_ind);

if not(isempty(property_name))
for i = 1 : length(aux_compartment_ind)
   property_compartment{i} = evalin('base',['zef.' compartment_tags{aux_compartment_ind(i)} '_' property_name ';']);
end
for i = 1 : length(aux_brain_ind)
   property_brain{i} = evalin('base',['zef.' compartment_tags{aux_brain_ind(i)} '_' property_name ';']);
end
end
end
