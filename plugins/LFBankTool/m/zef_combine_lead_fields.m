%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.lf_item_selected = get(zef.h_lf_item_list,'value');
zef.L = [];
zef.measurements = [];
zef.source_positions = [];
zef.source_directions = [];

zef.lf_n_aux = 0;
zef.lf_size_aux = 0;
for zef_i = zef.lf_item_selected
if zef.lf_normalization == 1
zef.measurements = [zef.measurements ; zef.lf_bank_storage{zef_i}.measurements];
zef.L = [zef.L ; zef.lf_bank_storage{zef_i}.L];
elseif zef.lf_normalization == 2
zef.lf_n_aux = zef.lf_n_aux + norm(zef.lf_bank_storage{zef_i}.L,'fro').^2; 
zef.lf_size_aux = zef.lf_size_aux + size(zef.lf_bank_storage{zef_i}.L,1); 
zef.measurements = [zef.measurements ; sqrt(size(zef.lf_bank_storage{zef_i}.L,1))*zef.lf_bank_storage{zef_i}.measurements/norm(zef.lf_bank_storage{zef_i}.L,'fro')];
zef.L = [zef.L ; sqrt(size(zef.lf_bank_storage{zef_i}.L,1))*zef.lf_bank_storage{zef_i}.L/norm(zef.lf_bank_storage{zef_i}.L,'fro')];
end
if isempty(zef.source_positions)
zef.source_positions = [zef.lf_bank_storage{zef_i}.source_positions];
end
if isempty(zef.source_directions)
zef.source_directions = [zef.lf_bank_storage{zef_i}.source_directions];
end
end
if zef.lf_normalization == 2
zef.measurements = sqrt(zef.lf_n_aux)*zef.measurements/sqrt(zef.lf_size_aux);
zef.L = sqrt(zef.lf_n_aux)*zef.L/sqrt(zef.lf_size_aux);
end
zef = rmfield(zef,'lf_n_aux');
zef = rmfield(zef,'lf_size_aux');

clear zef_i;