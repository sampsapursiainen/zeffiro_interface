%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'lf_item_type')); 
   zef.lf_item_type = ''; 
end;

if not(isfield(zef,'lf_tag')); 
   zef.lf_tag = 'EEG'; 
end;

if not(isfield(zef,'lf_normalization')); 
   zef.lf_normalization = 1; 
end;

if not(isfield(zef,'lf_bank_storage')); 
   zef.lf_bank_storage = cell(0); 
end;

if not(isfield(zef,'lf_bank_storage')); 
zef.lf_item_list = cell(0);
end;

if not(isfield(zef,'lf_item_selected')); 
   zef.lf_item_selected = cell(0); 
end;

if isfield(zef,'h_lf_bank_tool')
    if isvalid(zef.h_lf_bank_tool)
set(zef.h_lf_tag,'Value',zef.lf_tag);
zef.aux_field = get(zef.h_lf_normalization,'items');
set(zef.h_lf_normalization,'Value',zef.aux_field(zef.lf_normalization));
    end
    end

zef_update_lf_bank_tool;