%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [shape_param, scale_param, snr_vec] = zef_find_g_hyperprior_scale(snr_val, shape_param, varargin)

source_space_size = 1;
normalize_data = 'maximum';

source_space_size = 1;
source_strength = 1E-2;
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

end

relative_noise_std = 10.^(-snr_vec/20);
scale_param = source_strength.^2 * relative_noise_std.^2 ./ (source_space_size.*shape_param);

end
