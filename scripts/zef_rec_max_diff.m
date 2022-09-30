function [dist_vec,angle_vec] = zef_rec_max_diff(zef,method_name)

dist_vec = zeros(3*size(zef.source_positions,1),1);
angle_vec = zeros(3*size(zef.source_positions,1),1);

h_waitbar = zef_waitbar(0,'Creating synthetic measurements');

n_sources = size(zef.source_positions,1);
zef.measurements = zeros(size(zef.L,1),3*n_sources);

zef.inv_synth_source = [ 0 0 0 0 0 0 10   0    3    5];
dir_mat = eye(3);

for i = 1 : n_sources
 
    if mod(i,floor(n_sources/10))==0
    h_waitbar = zef_waitbar(i/n_sources,h_waitbar,'Creating synthetic measurements');
   end
    
    for j = 1 : 3


 zef.inv_synth_source(1:6) = [zef.source_positions(i,:)     dir_mat(j,:) ];
   
   zef.measurements(:,3*(i-1)+j) = zef_find_source_legacy(zef);
   
    end
end

zef.inv_data_mode = 'raw';

close(h_waitbar);
   eval(['z = ' method_name '(zef);']);
   
  for i = 1 : n_sources
      for j = 1 : 3
          
   z_norm = sqrt(sum(reshape(z{3*(i-1) + j},3,size(zef.source_positions,1)).^2));
   [~, I] = max(z_norm);
   
   dir_vec_rec = z{3*(i-1) + j}(3*(I-1)+1:3*(I-1)+3);
   dir_vec_rec = dir_vec_rec/norm(dir_vec_rec,2);
   dir_vec_source = dir_mat(:,j);
    dir_vec_source = dir_vec_source/norm(dir_vec_source,2);
  
   dist_vec(3*(i-1) + j) = (1/sqrt(3))*sqrt(sum((zef.source_positions(i,:) - zef.source_positions(I,:)).^2,2));
   angle_vec(3*(i-1) + j) = acosd(dot(dir_vec_rec,dir_vec_source));
   
   
      end
  end

end