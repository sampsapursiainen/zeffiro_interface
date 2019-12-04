%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
set(zef.h_lf_item_list,'Value',cell(0),'Items',cell(0),'Multiselect','on');

 for zef_i = 1 : length(zef.lf_bank_storage) 
    zef.lf_item_list{zef_i} = ['Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sources: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method ];   
 end
 
 if not(isempty(zef_i))
set(zef.h_lf_item_list,'Items',zef.lf_item_list,'Value',zef.lf_item_selected,'Multiselect','on');
 end

if not(isempty(zef_i))
if isempty(zef.lf_item_selected) 
 zef.lf_item_selected = zef.lf_item_list;
 set(zef.h_lf_item_list,'Items',zef.lf_item_list,'Value',zef.lf_item_selected,'Multiselect','on');
end
end
clear zef_i;


zef.lf_tag = get(zef.h_lf_tag,'value');
