%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [shape_param, scale_param, snr_vec] = zef_find_ig_hyperprior(snr_val, varargin)

L = [];

source_space_size = 1;
normalize_data = 'maximum';
eps_val = 1e-9;
delta_val = 0.1;

balance_snr = 1;

if length(varargin) > 0
L = varargin{1};
source_space_size = size(L,2);
end

if length(varargin) > 1
source_space_size = varargin{2};
end

if length(varargin) > 2
normalize_data = varargin{3};
end

if length(varargin) > 3
balance_snr = varargin{4};
end

if isempty(L)
    snr_vec = snr_val;
    snr_vec_limited = snr_vec;
    source_strength = 1e-2;
else

if isequal(normalize_data,'maximum')
   signal_strength = size(L,2)*max(abs(L))'./sum(max(abs(L))');
else
   signal_strength = size(L,2).*sqrt(sum(L.^2))'./sum(sqrt(sum(L.^2))');
end
   source_strength = size(L,2)./sum(max(abs(L))');

if balance_snr
snr_vec = snr_val + db(signal_strength);
else
snr_vec = snr_val;
end

snr_vec_limited = max(1,snr_vec);

end

shape_param = zeros(size(snr_vec));
scale_param = zeros(size(snr_vec));

relative_noise_std = 10.^(-snr_vec_limited/20);

a = 1*ones(size(relative_noise_std));
b = 200*ones(size(relative_noise_std));

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
    relative_noise_std = gpuArray(relative_noise_std);
    a = gpuArray(a);
    b = gpuArray(b);
end

for j = 1 : 10

shape_param_vec = a + (b-a).*[0:delta_val:1];

p_val_vec = zef_inverse_gamma_gpu(1,shape_param_vec,relative_noise_std(:, ones(size(shape_param_vec,2),1)).^2 .* (shape_param_vec - 1));

[m_aux,i_aux] = min(abs(p_val_vec - eps_val), [], 2);

i_aux = min(size(p_val_vec,2)-1,i_aux);
i_aux = max(2,i_aux);

b = shape_param_vec((i_aux-1)*size(p_val_vec,1)+[1:size(p_val_vec,1)]');
a = shape_param_vec((i_aux-2)*size(p_val_vec,1)+[1:size(p_val_vec,1)]');

end

shape_param = (a+b)/2;
scale_param = source_strength.^2 * relative_noise_std.^2 ./ (source_space_size*shape_param);

end
