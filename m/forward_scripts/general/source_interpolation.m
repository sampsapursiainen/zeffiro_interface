
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [source_interpolation_ind] = source_interpolation(void)

    if evalin('base','isequal(size(zef.L,2),size(zef.source_directions,1))')
    evalin('base','zef.source_directions=zef.source_directions(find(not(isnan(sum(abs(zef.L),1)))),:);');
    elseif evalin('base','isequal(size(zef.L,2),3*size(zef.source_directions,1))')
    evalin('base','zef.source_directions=zef.source_directions(find(not(isnan(sum(abs(zef.L(:,1:3:end)),1)))),:);');
    end
    if evalin('base','isequal(size(zef.L,2),size(zef.source_positions,1))')
    evalin('base','zef.source_positions=zef.source_positions(find(not(isnan(sum(abs(zef.L),1)))),:);');
        evalin('base','zef.L=zef.L(:,find(not(isnan(sum(abs(zef.L),1)))))');
    elseif evalin('base','isequal(size(zef.L,2),3*size(zef.source_positions,1))')
          evalin('base','zef.source_positions=zef.source_positions(find(not(isnan(sum(abs(zef.L(:,1:3:end)),1)))),:);');
        evalin('base','zef.L=zef.L(:,find(not(isnan(sum(abs(zef.L),1)))));');
    end

source_interpolation_ind = [];
brain_ind = evalin('base','zef.brain_ind');
source_positions = evalin('base','zef.source_positions');
nodes = evalin('base','zef.nodes');
tetra = evalin('base','zef.tetra');

if not(isempty(brain_ind)) && not(isempty(source_positions)) && not(isempty(nodes)) && not(isempty(tetra))

    h = waitbar(0,['Interpolation 1.']);

if evalin('base','zef.location_unit_current') == 2
source_positions = 10*source_positions;
end

if evalin('base','zef.location_unit_current') == 3
zef.source_positions = 1000*source_positions;
end

[center_points I center_points_ind] = unique(tetra(brain_ind,:));
source_interpolation_ind{1} = zeros(length(center_points),1);
source_interpolation_aux = source_interpolation_ind{1};
center_points = nodes(center_points,:);

MdlKDT = KDTreeSearcher(source_positions);
source_interpolation_ind{1} = knnsearch(MdlKDT,center_points);
source_interpolation_ind{1} = reshape(source_interpolation_ind{1}(center_points_ind), length(brain_ind), 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
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
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
    aux_brain_ind = [aux_brain_ind i];
end

end
end

source_positions_aux = source_positions;

for ab_ind = 1 : length(aux_brain_ind)

    waitbar((ab_ind+1)/(length(aux_brain_ind)+2),h,['Interpolation 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '.' ]);

aux_point_ind = unique(gather(source_interpolation_ind{1}));
source_positions = source_positions_aux(aux_point_ind,:);

s_ind_1{ab_ind} = aux_point_ind;

center_points = evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']);

MdlKDT = KDTreeSearcher(source_positions);
source_interpolation_aux = knnsearch(MdlKDT,center_points);

source_interpolation_ind{2}{ab_ind} = (s_ind_1{ab_ind}(source_interpolation_aux));

triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}']);
source_interpolation_ind{2}{ab_ind} = source_interpolation_ind{2}{ab_ind}(triangles);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

waitbar(1,h,['Interpolation 3.']);

aux_p = [];
aux_t = [];

for ab_ind = 1 : length(aux_brain_ind)

aux_t = [aux_t ; size(aux_p,1) + evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
aux_p = [aux_p ; evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];

end

center_points = (1/3)*(aux_p(aux_t(:,1),:) + aux_p(aux_t(:,2),:) + aux_p(aux_t(:,3),:));

MdlKDT = KDTreeSearcher(center_points);
source_interpolation_ind{3} = knnsearch(MdlKDT,source_positions);

if nargout == 0
assignin('base','zef_data', source_interpolation_ind);
evalin('base','zef.source_interpolation_ind = zef_data; clear zef_data;');
end

close(h)

end

end

