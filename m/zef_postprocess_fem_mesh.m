%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [domain_labels,brain_ind,non_source_ind,nodes,tetra,surface_triangles,submesh_ind] = zef_postprocess_fem_mesh(varargin)

h = waitbar(0,'Mesh post-processing');

parameter_profile = evalin('base','zef.parameter_profile');

for zef_j = 1 : size(parameter_profile,1)
    if isequal(parameter_profile{zef_j,8},'Segmentation') && isequal(parameter_profile{zef_j,3},'Scalar') && isequal(parameter_profile{zef_j,6},'On')
eval([parameter_profile{zef_j,2} '_vec = [];']);
    end
end

tetra = [];
prisms = [];
sigma_prisms = [];
non_source_ind = [];

optimizer_flag = 1;

if evalin('base','zef.sigma_bypass')

   sigma = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   non_source_ind = evalin('base','zef.non_source_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');
   sigma_prisms = evalin('base','zef.sigma_prisms');
   prisms = evalin('base','zef.prisms');
   submesh_ind = evalin('base','zef.submesh_ind');

else

thresh_val = evalin('base','zef.mesh_optimization_parameter');
compartment_tags = evalin('base','zef.compartment_tags');
aux_compartment_ind = zeros(1,length(compartment_tags));

if evalin('base','zef.import_mode')

   sigma = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');

else

sigma = [];
i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
pml_vec = [];
aux_brain_ind = [];
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

for zef_j = 1 : size(parameter_profile,1)
    if isequal(parameter_profile{zef_j,8},'Segmentation') && isequal(parameter_profile{zef_j,3},'Scalar') && isequal(parameter_profile{zef_j,6},'On')
        eval([parameter_profile{zef_j,2} '_vec(' num2str(i) ',1) =' num2str(evalin('base',['zef.' compartment_tags{k} '_' parameter_profile{zef_j,2}])) ';']);
    end
end

sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
submesh_cell{i} = evalin('base',var_3);
aux_compartment_ind(k) = i;
if not(isequal(evalin('base',var_4),-1))
pml_vec(i,1) = 0 ;
else
    pml_vec(i,1) = 1;
end
if ismember(evalin('base',var_4),[1 2])
aux_brain_ind(i,1) = 1 ;
end


end
end

pml_ind_aux = find(pml_vec,1);

reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');

n_compartments = 0;
for k = 1 : evalin('base','length(zef.reuna_p)')
n_compartments = n_compartments + max(1,length(submesh_cell{k}));
end

priority_vec_aux = zeros(n_compartments,1);
compartment_counter = 0;
submesh_ind_1 = ones(n_compartments,1);
submesh_ind_2 = ones(n_compartments,1);

for i = 1 :  evalin('base','length(zef.reuna_p)')
for k = 1 : max(1,length(submesh_cell{i}))

compartment_counter = compartment_counter + 1;
priority_vec_aux(compartment_counter) = priority_vec(i);
submesh_ind_1(compartment_counter) = i;
submesh_ind_2(compartment_counter) = k;

end
end

domain_labels = double(evalin('base','zef.domain_labels_raw'));
[priority_val priority_ind] = min(priority_vec_aux(domain_labels),[],2);
priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);
[domain_labels] = submesh_ind_1(domain_labels(priority_ind));


nodes = evalin('base','zef.nodes_raw');
tetra_aux = evalin('base','zef.tetra_raw');
tetra = tetra_aux;
N = size(nodes, 1);

zef_smoothing_step;

refinement_flag = 2;

surface_refinement_on = evalin('base','zef.refinement_surface_on_2');
n_surface_refinement = evalin('base','zef.refinement_surface_number_2');

if surface_refinement_on

    if length(n_surface_refinement) == 1

for i_surface_refinement = 1 : n_surface_refinement

zef_refinement_step;

% if evalin('base','zef.mesh_relabeling')
% pml_ind = [];
% label_ind = uint32(tetra);
% labeling_flag = 2;
% zef_mesh_labeling_step;
% end

end

    else

 for j_surface_refinement = 1 : length(n_surface_refinement)
 for i_surface_refinement = 1 : n_surface_refinement(j_surface_refinement)

zef_refinement_step;

% if evalin('base','zef.mesh_relabeling')
%
% pml_ind = [];
% label_ind = uint32(tetra);
% labeling_flag = 2;
% zef_mesh_labeling_step;
%
% end

 end
        end

    end
end

if evalin('base','zef.refinement_volume_on_2');
waitbar(0,h,'Volume refinement.');
n_refinement = evalin('base','zef.refinement_volume_number_2');
refinement_compartments_aux = evalin('base','zef.refinement_volume_compartments_2');

refinement_compartments = [];
if ismember(1,refinement_compartments_aux)
refinement_compartments = aux_brain_ind(:);
end

refinement_compartments_aux = setdiff(refinement_compartments_aux,1)-1;
refinement_compartments = [refinement_compartments ; refinement_compartments_aux(:)];

for i = 1 : n_refinement

[nodes,tetra,domain_labels] = zef_mesh_refinement(nodes,tetra,domain_labels,refinement_compartments);
waitbar(i/n_refinement,h,'Volume refinement.');

end

%[tetra, optimizer_flag] = zef_tetra_turn(nodes, tetra, thresh_val);

% if evalin('base','zef.mesh_relabeling')
%
% pml_ind = [];
% label_ind = uint32(tetra);
% labeling_flag = 2;
% zef_mesh_labeling_step;
%
% end

max_domain_labels = max(domain_labels);
I_5 = 0;
while not(isempty(I_5))
I_3 = find(domain_labels<max_domain_labels);
[~,~,I_4] = zef_surface_mesh(tetra(I_3,:));
I_4 = accumarray(I_4,ones(size(I_4)),[size(I_3,1) 1]);
I_4 = find(I_4 < 3);
I_5 = setdiff([1:size(I_3,1)]',I_4);
domain_labels(I_3(I_5)) = max_domain_labels;
end

end


[nodes,optimizer_flag] = zef_fix_negatives(nodes, tetra);
if optimizer_flag == 1
[tetra, optimizer_flag] = zef_tetra_turn(nodes, tetra, thresh_val);
end

%  if evalin('base','zef.mesh_relabeling')
%
%  pml_ind = [];
%  label_ind = uint32(tetra);
%  labeling_flag = 2;
%  zef_mesh_labeling_step;
%
%  end


brain_ind = [];
for k = 1 : length(compartment_tags)
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0 && not(evalin('base',['zef.' compartment_tags{k} '_sources'])==3)
if not(aux_compartment_ind(k)==0)
[brain_ind]= [brain_ind ; find(domain_labels==aux_compartment_ind(k))];
end
end
end

if sum(aux_compartment_ind) == 0
brain_ind = find(domain_labels);
end

brain_ind = brain_ind(:);

submesh_ind = submesh_ind_2(domain_labels);
submesh_ind = submesh_ind(brain_ind);

if evalin('base','zef.exclude_box')

I = find(not(ismember(domain_labels,find(pml_vec,1))));
I_2 = zeros(size(tetra,1),1);
I_2(I) = [1:length(I)];
brain_ind = I_2(brain_ind);
brain_ind = brain_ind(find(brain_ind));
non_source_ind = I_2(non_source_ind);
non_source_ind = non_source_ind(find(non_source_ind));
domain_labels = domain_labels(I,:);
[unique_vec_1, ~, unique_vec_3] = unique(tetra(I,:));
tetra = reshape(unique_vec_3,length(I),4);
nodes = nodes(unique_vec_1,:);
end

I_aux = find(not(ismember(domain_labels,find(pml_vec,1))));
surface_triangles = zef_surface_mesh(tetra(I_aux,:));

for zef_j = 1 : size(parameter_profile,1)
    if isequal(parameter_profile{zef_j,8},'Segmentation') && isequal(parameter_profile{zef_j,3},'Scalar') && isequal(parameter_profile{zef_j,6},'On')
eval([parameter_profile{zef_j,2} '=[' parameter_profile{zef_j,2} '_vec(domain_labels) domain_labels];']);
    end
end


J = unique(zef_surface_mesh(tetra));
tetra_vec = sum(ismember(tetra,J),2);
non_source_ind = find(tetra_vec > 2);
clear tetra_vec;

end



%brain_ind = single(brain_ind);
%tetra = single(tetra);





end


condition_number = zef_condition_number(nodes,tetra);

close(h);

active_compartment_ind = brain_ind;

aux_struct = struct(...
'domain_labels',domain_labels, ...
'brain_ind',brain_ind,...
'active_compartment_ind',active_compartment_ind,...
'non_source_ind',non_source_ind,...
'nodes',nodes,...
'tetra',tetra,...
'surface_triangles',surface_triangles,...
'submesh_ind',submesh_ind,...
'condition_number',condition_number);

for zef_j = 1 : size(parameter_profile,1)
    if isequal(parameter_profile{zef_j,8},'Segmentation') && isequal(parameter_profile{zef_j,3},'Scalar') && isequal(parameter_profile{zef_j,6},'On')
eval(['aux_struct.' parameter_profile{zef_j,2} '=' parameter_profile{zef_j,2} ';']);
    end
end

if nargout == 0
assignin('base','zef_data',aux_struct);
evalin('base','zef_assign_data');
end

end






