%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [scale_param, snr_vec] = zef_find_gaussian_prior(snr_val, varargin)

L = [];

source_space_size = 1;
normalize_data = 'maximum';
balance_snr = 1;
w_param = 0.5;

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

if length(varargin) > 4
if balance_snr
w_param = 0.5 - 0.05*(varargin{5}-1);
end
end

if isempty(L)
    snr_vec = snr_val;
    snr_vec_limited = snr_vec;
    source_strength = 1e-2;
else
   if isequal(normalize_data,'maximum')
   source_strength = mean(1./((max(abs(L))').^w_param));
else
   source_strength = mean(1./(sqrt(sum(L.^2)').^w_param));
end

if balance_snr
if isequal(normalize_data,'maximum')
   signal_strength = (size(L,2)*(max(abs(L))')./sum(max(abs(L))')).^(w_param);
else
   signal_strength = (size(L,2).*(sqrt(sum(L.^2))')./sum(sqrt(sum(L.^2))')).^(w_param);
end
snr_vec = snr_val + db(signal_strength);
else
snr_vec = snr_val;
end

snr_vec_limited = max(1,snr_vec);

end

relative_noise_std = 10.^(-snr_vec_limited/20);

scale_param = source_strength.^2 .* relative_noise_std.^2 ./ (source_space_size);

end
