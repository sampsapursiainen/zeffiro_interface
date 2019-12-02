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

if not(isfield(zef,'lf_item_selected')); 
   zef.lf_item_selected = []; 
end;

set(zef.h_lf_tag,'string',zef.lf_tag);

zef_update_lf_bank_tool;