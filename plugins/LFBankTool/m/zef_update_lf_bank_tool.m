%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.lf_item_list = cell(0);
set(zef.h_lf_item_list,'string',[],'value',1,'min',1,'max',Inf);

 for zef_i = 1 : length(zef.lf_bank_storage) 
    zef.lf_item_list{zef_i} = ['<HTML><BODY>'   ' &nbsp Tag: ' zef.lf_bank_storage{zef_i}.lf_tag  ', Sources:' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ', Sensors: ' num2str(size(zef.lf_bank_storage{zef_i}.source_positions,1)) ',  Method: ' zef.lf_bank_storage{zef_i}.imaging_method '</BODY></HTML>'  ];   
 end
 
 if not(isempty(zef_i))
set(zef.h_lf_item_list,'string',zef.lf_item_list,'value',zef.lf_item_selected)
 end

if not(isempty(zef_i))
if isempty(zef.lf_item_selected) 
 set(zef.h_lf_item_list,'value',[1:length(get(zef.h_lf_item_list,'string'))]);
 zef.lf_item_selected = [1:length(get(zef.h_lf_item_list,'string'))];
end
end
clear zef_i;

zef = rmfield(zef,'lf_item_list');

zef.lf_tag = get(zef.h_lf_tag,'string');
zef.lf_normalization = get(zef.h_lf_normalization,'value');
