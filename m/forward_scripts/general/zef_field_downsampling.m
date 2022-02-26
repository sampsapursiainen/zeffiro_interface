
if isfield(zef,'source_positions_original_field')
if isempty(zef.source_positions_original_field)

zef.source_positions_original_field = zef.source_positions;
zef.source_directions_original_field = zef.source_directions;
zef.L_original_field = zef.L;
zef.source_interpolation_ind_original_field = zef.source_interpolation_ind;

else

zef.source_positions = zef.source_positions_original_field;
zef.source_directions = zef.source_directions_original_field;
zef.L = zef.L_original_field;
zef.source_interpolation_ind = zef.source_interpolation_ind_original_field;
end

else

zef.source_positions_original_field = zef.source_positions;
zef.source_directions_original_field = zef.source_directions;
zef.L_original_field = zef.L;
zef.source_interpolation_ind_original_field = zef.source_interpolation_ind;

end

if zef.n_sources < size(zef.source_positions,1)

zef.rand_vec_aux = randperm(size(zef.source_positions,1));
zef.rand_vec_aux = zef.rand_vec_aux(1:zef.n_sources);
zef.source_positions = zef.source_positions(zef.rand_vec_aux,:);

if ismember(zef.source_direction_mode,2)
zef.rand_vec_aux = 3*(zef.rand_vec_aux(:)'-1);
zef.rand_vec_aux = [zef.rand_vec_aux + 1; zef.rand_vec_aux + 2; zef.rand_vec_aux + 3];
zef.rand_vec_aux = zef.rand_vec_aux(:);
zef.L = zef.L(:,zef.rand_vec_aux);
elseif ismember(zef.source_direction_mode,[1 3])
zef.L = zef.L(:,zef.rand_vec_aux);
if not(isempty(zef.source_directions))
zef.source_directions = zef.source_directions(zef.rand_vec_aux,:);
end
end

[zef.source_interpolation_ind] = source_interpolation([]);

zef = rmfield(zef,'rand_vec_aux');

end

