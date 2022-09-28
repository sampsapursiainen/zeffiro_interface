function rec_vec = zef_rec_max_diff(zef,method_name)

rec_vec = zeros(3*size(zef.source_positions,1),1);

h_waitbar = zef_waitbar(0,'Source differences');

n_sources = size(zef.source_positions,1);
zef.measurements = zeros(size(zef.L,1),3*n_sources);

for i = 1 : n_sources
 
    if mod(i,floor(n_sources/10))==0
    h_waitbar = zef_waitbar(i/n_sources,h_waitbar,'Source differences');
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
   
   zef.measurements(:,3*(i-1)+j) = zef_find_source_legacy(zef);
   
    end
end

close(h_waitbar);
   
   %zef.h_zeffiro_menu.ZefUseWaitbar = 0;
    
   eval(['z = ' method_name '(zef,''raw'');']);
   
  for i = 1 : n_sources
      for j = 1 : 3
          
   z_norm = sqrt(sum(reshape(z{3*(i-1) + j},3,size(zef.source_positions,1)).^2));
   %zef.h_zeffiro_menu.ZefUseWaitbar = visible_val;
   
   [~, I] = max(z_norm);
   rec_vec(3*(i-1) + j) = norm(zef.source_positions(i,:) - zef.source_positions(I,:),2);
   
      end
   end


%close(h_waitbar)

end