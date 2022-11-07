%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

function [min_ind] = array_min(i, xq, yq, zq, nodes_aux)
   aux_pos = [xq(i),yq(i),zq(i)];
   [min_val,min_ind] = min(sqrt(sum((nodes_aux - aux_pos(ones(size(nodes_aux,1),1),:)).^2,2)));
min_ind = gather(min_ind);
end
   
   
   