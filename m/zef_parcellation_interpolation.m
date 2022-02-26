%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [parcellation_interpolation_ind] = zef_parcellation_interpolation(void)

domain_labels = evalin('base','zef.domain_labels(zef.brain_ind)');
submesh_ind_vec = evalin('base','zef.submesh_ind');
parcellation_compartment = evalin('base','zef.parcellation_compartment');

cortex_ind_aux = [];
cortex_surface_ind_aux = [];
i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
submesh_cell = cell(0);
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);

on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = evalin('base',var_4);
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
    aux_brain_ind = [aux_brain_ind i];
end

if sum(ismember(parcellation_compartment(1), compartment_tags{k}))
    cortex_ind_aux = [cortex_ind_aux i];
end

if sum(ismember(parcellation_compartment, compartment_tags{k}))
    cortex_surface_ind_aux = [cortex_surface_ind_aux i];
end

end
end

p_colortable = evalin('base','zef.parcellation_colortable');
p_points = evalin('base','zef.parcellation_points');
p_tolerance = evalin('base','zef.parcellation_tolerance');
p_selected = evalin('base','zef.parcellation_selected');

p_length = 0;
c_length = 1;
c_max = [];
p_colormap = [];
p_points_ind_aux = [];
parcellation_p = [];
p_compartment = [];
p_cortex = [];
for i = 1 : length(p_points)
    min_aux = min(p_colortable{i}{4});
    c_ind_aux_1 = [1: size(p_colortable{i}{3},1)]' + c_length;
    c_length = c_length + size(p_colortable{i}{3},1);
    c_ind_aux_2 = zeros(max(p_colortable{i}{4})+1,1);
    c_ind_aux_2(p_colortable{i}{3}(:,5)+1) = c_ind_aux_1;
    p_colortable_aux = c_ind_aux_2(p_colortable{i}{4}+1);
    p_points_ind_aux = [p_points_ind_aux ; p_colortable_aux(p_points{i}(:,1)+1)];
    parcellation_p = [parcellation_p ; p_points{i}(:,2:4)];
    if length(p_colortable{i}) > 4
        p_compartment= [p_compartment ; p_colortable{i}{5}];
        p_cortex = [p_cortex ; zeros(length(p_colortable{i}{3}(:,5)),1)];
    else
    p_compartment = [p_compartment ; [cortex_ind_aux(1)*ones(length(p_colortable{i}{3}(:,5)),1) ones(length(p_colortable{i}{3}(:,5)),1)]];
    p_cortex = [p_cortex ; ones(length(p_colortable{i}{3}(:,5)),1)];
    end
end

brain_ind = evalin('base','zef.brain_ind');
nodes = evalin('base','zef.nodes');
tetra = evalin('base','zef.tetra');

if evalin('base','zef.location_unit_current') == 2
parcellation_p = 10*parcellation_p;
end

if evalin('base','zef.location_unit_current') == 3
zef.parcellation_p = 1000*parcellation_p;
end

I_compartment = find(ismember(evalin('base','zef.sigma(:,2)'),cortex_ind_aux(1)));
brain_cortex_ind = find(ismember(brain_ind,I_compartment));
cortex_ind = brain_ind(brain_cortex_ind);

[center_points I center_points_ind] = unique(tetra(cortex_ind,:));
center_points = nodes(center_points,:);
size_center_points = size(center_points,1);

h = waitbar(i/size_center_points,['Interp. 1.']);
p_counter = 0;
for p_ind = p_selected + 1
p_counter = p_counter + 1;
source_positions = parcellation_p(find(p_points_ind_aux == p_ind),:);
parcellation_interpolation_ind{p_ind-1}{1} = [];

if not(p_cortex(p_ind-1) == 1)

sigma_ind = find(domain_labels==p_compartment(p_ind-1,1));
parcellation_interpolation_ind{p_ind-1}{1} = sigma_ind(find(submesh_ind_vec(sigma_ind)==p_compartment(p_ind-1,2)));

else

if not(isempty(source_positions))

MdlKDT = KDTreeSearcher(source_positions);
source_interpolation_ind = knnsearch(MdlKDT,center_points);

waitbar(p_counter/length(p_selected),h,['Interp. 1. ' num2str(p_counter) '/' num2str(length(p_selected))  '.' ]);

source_interpolation_ind = source_interpolation_ind(:);

distance_vec = sum((source_positions(source_interpolation_ind,:)-center_points).^2,2);

%if not(isempty(rand_perm_aux))
%source_interpolation_ind{1} = rand_perm_aux(source_interpolation_ind{1});
%end
parcellation_interpolation_ind{p_ind-1}{1} =  find(mean(sqrt(reshape(distance_vec(center_points_ind), length(cortex_ind), 4)),2)<p_tolerance);
parcellation_interpolation_ind{p_ind-1}{1} = brain_cortex_ind(parcellation_interpolation_ind{p_ind-1}{1});

end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ab_ind = 1 : length(aux_brain_ind)

p_counter = 0;
for p_ind = p_selected + 1
p_counter = p_counter + 1;

parcellation_interpolation_ind{p_ind-1}{2}{ab_ind} = [];
triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}']);
if not(p_cortex(p_ind-1) == 1)
    if aux_brain_ind(ab_ind) == p_compartment(p_ind-1,1)
    if isempty(submesh_cell{aux_brain_ind(ab_ind)})
    submesh_ind_aux_1 = 0;
    submesh_ind_aux_2 = size(triangles,1);
    elseif p_compartment(p_ind-1,2) == 1
    submesh_ind_aux_1 = 0;
    submesh_ind_aux_2 = submesh_cell{aux_brain_ind(ab_ind)}(1);
    else
    submesh_ind_aux_1 = submesh_cell{aux_brain_ind(ab_ind)}(p_compartment(p_ind-2,2));
    submesh_ind_aux_2 = submesh_cell{aux_brain_ind(ab_ind)}(p_compartment(p_ind-1,2));
    end
    parcellation_interpolation_ind{p_ind-1}{2}{ab_ind} = [submesh_ind_aux_1+1:submesh_ind_aux_2]';
    end

else

if ismember(aux_brain_ind(ab_ind),cortex_surface_ind_aux)

source_positions = parcellation_p(find(p_points_ind_aux == p_ind),:);

if not(isempty(source_positions))

%aux_point_ind = unique(gather(source_interpolation_ind{1}));
%source_positions = source_positions_aux(:,aux_point_ind);

%s_ind_1{ab_ind} = aux_point_ind;

center_points = evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']);

size_center_points = size(center_points,2);

tic;

MdlKDT = KDTreeSearcher(source_positions);
source_interpolation_ind = knnsearch(MdlKDT,center_points);

waitbar(p_counter/length(p_selected),h,['Interp. 2: ' num2str(p_counter) '/' num2str(length(p_selected))  ',' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '.']);

source_interpolation_ind = source_interpolation_ind(:);

distance_vec = sum((source_positions(source_interpolation_ind,:)-center_points).^2,2);

%if not(isempty(rand_perm_aux))
%source_interpolation_ind{2}{ab_ind} = rand_perm_aux(source_interpolation_ind{2});
%end
parcellation_interpolation_ind{p_ind-1}{2}{ab_ind} = find(mean(sqrt(distance_vec(triangles)),2)<p_tolerance);

waitbar(1,h,['Interp. 2: ' num2str(p_counter) '/' num2str(length(p_selected)) '.']);

end
end
end
end
end

close(h)

end

