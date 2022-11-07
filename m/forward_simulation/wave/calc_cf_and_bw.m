function [cf, bw, hf] = calc_cf_and_bw(t_vec, pulse_vec,varargin)

if isempty(varargin)
    signal_threshold = -20;
elseif length(varargin)>0
    signal_threshold = -abs(varargin{1});
end

f_vec = 1:ceil((length(pulse_vec)-1)/2);
s_fft = fft(real(pulse_vec));
db_vec = db(abs(s_fft(2:1+ceil((length(pulse_vec)-1)/2))));
db_vec = db_vec - max(db_vec);
db_I = find(db_vec>=-3);
cf = (1/max(t_vec))*(f_vec(db_I(end))+f_vec(db_I(1)))/2; 
bw = (1/max(t_vec))*(1+f_vec(db_I(end))-f_vec(db_I(1)));
db_I = find(db_vec>=signal_threshold);
hf = (1/max(t_vec))*f_vec(db_I(end));

end
