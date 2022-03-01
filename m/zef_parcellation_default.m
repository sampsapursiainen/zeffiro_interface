%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [c_table,c_points] = zef_parcellation_default(void)

c_table = cell(0);
c_points = cell(0);
c_ind = 0;

submesh_ind = evalin('base','zef.submesh_ind');
if isempty(submesh_ind)
    submesh_ind = ones(size(evalin('base','zef.brain_ind')));
end

if evalin('base','zef.parcellation_merge')
c_table = evalin('base','zef.parcellation_colortable');
c_points = evalin('base','zef.parcellation_points');
else
evalin('base','zef.parcellation_selected = [];');
end

s_interp_ind = evalin('base','zef.source_interpolation_ind{1}');

t_ind = 1 + length(c_table);

c_table{t_ind}{1} = 'SG';
c_points_aux = evalin('base','zef.source_positions');
c_points_aux = [[0:size(c_points_aux,1)-1]' c_points_aux];
c_table{t_ind}{4} = zeros(size(c_points,1),1);

c_points{t_ind} = c_points_aux;

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)
        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        color_str = evalin('base',['zef.'  compartment_tags{k}  '_color']);
on_val = evalin('base',var_0);
if on_val
i = i + 1;

c_str = compartment_tags{k};

if ismember(evalin('base',['zef.' c_str '_sources']),[1 2])
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
submesh_ind_aux = unique(submesh_ind(I));
if isempty(submesh_ind_aux)
    submesh_ind_aux = 1;
end

for ell_ind = 1 : length(submesh_ind_aux)
c_ind = c_ind + 1;
I_aux = find(submesh_ind(I)==submesh_ind_aux(ell_ind));
J = unique(s_interp_ind(I(I_aux),:));
if length(submesh_ind_aux) > 1
c_table{t_ind}{2}{c_ind,1} = [evalin('base',['zef.' c_str '_name']) ' ' num2str(submesh_ind_aux(ell_ind))];
else
c_table{t_ind}{2}{c_ind,1} = [evalin('base',['zef.' c_str '_name'])];
end
c_table{t_ind}{3}(c_ind,1:3) = evalin('base',['zef.' c_str '_color']);
c_table{t_ind}{3}(c_ind,5) =  c_ind;
c_table{t_ind}{5}(c_ind,:) = [i submesh_ind_aux(ell_ind)];
c_table{t_ind}{4}(J) = c_ind;
end
end
end

end

c_table{t_ind}{3}(:,1:3) = round(255*c_table{t_ind}{3}(:,1:3));
c_table{t_ind}{4} = c_table{t_ind}{4}(:);

end

