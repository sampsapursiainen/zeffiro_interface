%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if isfield(zef,'h_lf_bank_tool')
        if isvalid(zef.h_lf_bank_tool)
set(zef.h_lf_item_list,'Value',cell(0),'Items',cell(0),'Multiselect','on');
        end
end

 for zef_i = 1 : length(zef.lf_bank_storage)
    if isfield(zef,'lf_item_list')
        if zef_i <= length(zef.lf_item_list)
     if ismember(zef.lf_item_list{zef_i},zef.lf_item_selected)
        zef_j = find(ismember(zef.lf_item_selected,zef.lf_item_list{zef_i}));
    zef.lf_item_list{zef_i} = ['Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.sensors,1)) ', Sources: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method ];   
zef.lf_item_selected{zef_j} = zef.lf_item_list{zef_i};
     else
    zef.lf_item_list{zef_i} = ['Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.sensors,1)) ', Sources: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method ];              
     end
        else
           zef.lf_item_list{zef_i} = ['Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.sensors,1)) ', Sources: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method ];   
        end
    else
     zef.lf_item_list{zef_i} = ['Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.sensors,1)) ', Sources: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method ];       
    end
     end
 
 if isfield(zef,'h_lf_bank_tool')
         if isvalid(zef.h_lf_bank_tool)
 if not(isempty(zef_i))
     zef.lf_item_selected = zef.lf_item_list;
set(zef.h_lf_item_list,'Items',zef.lf_item_list,'Value',zef.lf_item_selected,'Multiselect','on');
 end
         end
 end

if not(isempty(zef_i))
if isempty(zef.lf_item_selected) 
 zef.lf_item_selected = zef.lf_item_list;
 if isfield(zef,'h_lf_bank_tool')
         if isvalid(zef.h_lf_bank_tool)
 set(zef.h_lf_item_list,'Items',zef.lf_item_list,'Value',zef.lf_item_selected,'Multiselect','on');
         end
         end
 end
end
clear zef_i zef_j;

if isfield(zef,'h_lf_bank_tool')
        if isvalid(zef.h_lf_bank_tool)
zef.lf_tag = get(zef.h_lf_tag,'value');
        end
end