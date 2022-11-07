%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [y] = mat_vec(R,x,gpu_extended_memory)

R = gpuArray(R);
x = gpuArray(double(x));
y = R*x;

if (ismember(gpu_extended_memory,[0 2]))
y = gather(y);
end

end
