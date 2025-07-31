%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [c_table,c_points] = zef_parcellation_default(zef)

c_table = cell(0);
c_points = cell(0);
c_ind = 0;

submesh_ind = eval('zef.submesh_ind');
if isempty(submesh_ind)
    submesh_ind = ones(size(eval('zef.active_compartment_ind')));
end

if eval('zef.parcellation_merge')
    c_table = eval('zef.parcellation_colortable');
    c_points = eval('zef.parcellation_points');
else
    eval('zef.parcellation_selected = [];');
end

s_interp_ind = eval('zef.source_interpolation_ind{1}');

t_ind = 1 + length(c_table);

c_table{t_ind}{1} = 'SG';
c_points_aux = zef.source_positions';
c_points_aux = [[0:size(c_points_aux,1)-1]' c_points_aux];
c_table{t_ind}{4} = zeros(size(c_points_aux,1),1);

c_points{t_ind} = c_points_aux;

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_active_compartment_ind = [];
compartment_tags = eval('zef.compartment_tags');
for k = 1 : length(compartment_tags)
    var_0 = ['zef.' compartment_tags{k} '_on'];
    var_1 = ['zef.' compartment_tags{k} '_sigma'];
    var_2 = ['zef.' compartment_tags{k} '_priority'];
    var_3 = ['zef.' compartment_tags{k} '_visible'];
    color_str = eval(['zef.'  compartment_tags{k}  '_color']);
    on_val = eval(var_0);
    if on_val
        i = i + 1;

        c_str = compartment_tags{k};

        if ismember(eval(['zef.' c_str '_sources']),[1 2])
            I = find(eval('zef.domain_labels(zef.active_compartment_ind)')==i);
            submesh_ind_aux = unique(submesh_ind(I));
            if isempty(submesh_ind_aux)
                submesh_ind_aux = 1;
            end

            for ell_ind = 1 : length(submesh_ind_aux)
                c_ind = c_ind + 1;
                I_aux = find(submesh_ind(I)==submesh_ind_aux(ell_ind));
                J = unique(s_interp_ind(I(I_aux),:));
                if length(submesh_ind_aux) > 1
                    c_table{t_ind}{2}{c_ind,1} = [eval(['zef.' c_str '_name']) ' ' num2str(submesh_ind_aux(ell_ind))];
                else
                    c_table{t_ind}{2}{c_ind,1} = [eval(['zef.' c_str '_name'])];
                end
                c_table{t_ind}{3}(c_ind,1:3) = eval(['zef.' c_str '_color']);
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
