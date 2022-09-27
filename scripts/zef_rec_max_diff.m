function rec_vec = zef_rec_max_diff(zef,method_name)

rec_vec = zeros(3*size(zef.source_positions,1),1);

h_waitbar = zef_waitbar(0,'Source differences');
visible_val = zef.h_zeffiro_menu.ZefUseWaitbar;

for i = 1 : size(zef.source_positions,1)
 
    if mod(i,floor(size(zef.source_positions,1)/10))==0
    h_waitbar = zef_waitbar(i/size(zef.source_positions,1),h_waitbar,'Source differences');
   end
    
    for j = 1 : 3

   switch j
       case 1
 zef.inv_synth_source = [zef.source_positions(i,:)     1     0     0  10     0     3     5];
       case 2
            zef.inv_synth_source = [zef.source_positions(i,:)     0     1     0  10     0     3     5];
       case 3
            zef.inv_synth_source = [zef.source_positions(i,:)     0     0     1  10     0     3     5];
   end
   
   zef.measurements = zef_find_source_legacy(zef);
   
   zef.h_zeffiro_menu.ZefUseWaitbar = 0;
    
   eval(['z = ' method_name '(zef);']);
   
   if iscell(z)
       z = z{1};
   end
   
   
   z_norm = sqrt(sum(reshape(z,3,size(zef.source_positions,1)).^2));
   zef.h_zeffiro_menu.ZefUseWaitbar = visible_val;
   
   [~, I] = max(z_norm);
   rec_vec(i+j) = norm(zef.source_positions(i,:) - zef.source_positions(I,:),2);
   
   end
end

close(h_waitbar)

end