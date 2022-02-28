%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [johtavuus,brain_ind,non_source_ind,nodes,tetra,johtavuus_prisms,prisms,submesh_ind] = zef_sigma(void)

tetra = [];
prisms = [];
johtavuus_prisms = [];
non_source_ind = [];

optimizer_flag = 1;

if evalin('base','zef.sigma_bypass')

   johtavuus = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   non_source_ind = evalin('base','zef.non_source_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');
   johtavuus_prisms = evalin('base','zef.sigma_prisms');
   prisms = evalin('base','zef.prisms');
   submesh_ind = evalin('base','zef.submesh_ind');

else

thresh_val = evalin('base','zef.mesh_optimization_parameter');

compartment_tags = evalin('base','zef.compartment_tags');

aux_compartment_ind = zeros(1,length(compartment_tags));

if evalin('base','zef.import_mode')

   johtavuus = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');

else

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

on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
submesh_cell{i} = evalin('base',var_3);
aux_compartment_ind(k) = i;

end
end

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

sigma_anisotropy = double(evalin('base','zef.sigma_anisotropy'));
johtavuus_ind = double(evalin('base','zef.sigma_ind'));
[priority_val priority_ind] = min(priority_vec_aux(johtavuus_ind),[],2);
priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
[johtavuus] = johtavuus_ind(priority_ind);

submesh_ind = submesh_ind_2(johtavuus);
johtavuus = submesh_ind_1(johtavuus);

johtavuus_aux = johtavuus;

brain_ind = [];
for k = 1 : length(compartment_tags)
if evalin('base',['zef.' compartment_tags{k} '_sources']) && not(evalin('base',['zef.' compartment_tags{k} '_sources'])==3)
if not(aux_compartment_ind(k)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_compartment_ind(k))];
end
end
end

if sum(aux_compartment_ind) == 0
brain_ind = find(johtavuus);
end

brain_ind = brain_ind(:);
submesh_ind = submesh_ind(brain_ind);
johtavuus = sigma_vec(johtavuus);
johtavuus = johtavuus(:);

clear johtavuus_ind priority_ind;

nodes = evalin('base','zef.nodes_b');
tetra_aux = evalin('base','zef.tetra_aux');
tetra = tetra_aux;
N = size(nodes, 1);

zef_smoothing_step;
zef_refinement_step

if not(isempty(sigma_anisotropy))
johtavuus = [johtavuus(:) johtavuus_aux(:) sigma_anisotropy] ;
else
    johtavuus = [johtavuus(:) johtavuus_aux(:)] ;
end

end

%brain_ind = single(brain_ind);
%tetra = single(tetra);

end

end

