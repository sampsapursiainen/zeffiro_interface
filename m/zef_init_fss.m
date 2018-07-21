%Copyright © 2018, Sampsa Pursiainen
if not(isfield(zef,'inv_synth_source')); 
    zef.inv_synth_source = [0 0 0 1 0 0 10 0 3 1]; 
end; 

set(zef.h_inv_synth_source_1 ,'string',num2str(zef.inv_synth_source(:,1)'));
set(zef.h_inv_synth_source_2 ,'string',num2str(zef.inv_synth_source(:,2)'));
set(zef.h_inv_synth_source_3 ,'string',num2str(zef.inv_synth_source(:,3)'));
set(zef.h_inv_synth_source_4 ,'string',num2str(zef.inv_synth_source(:,4)'));
set(zef.h_inv_synth_source_5 ,'string',num2str(zef.inv_synth_source(:,5)'));
set(zef.h_inv_synth_source_6 ,'string',num2str(zef.inv_synth_source(:,6)'));
set(zef.h_inv_synth_source_7 ,'string',num2str(zef.inv_synth_source(:,7)'));
set(zef.h_inv_synth_source_8 ,'string',num2str(zef.inv_synth_source(1,8)));
set(zef.h_inv_synth_source_9 ,'string',num2str(zef.inv_synth_source(1,9)));
set(zef.h_inv_synth_source_10 ,'value',zef.inv_synth_source(1,10));
