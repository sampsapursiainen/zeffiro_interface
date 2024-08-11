function [y, dy] = zef_nse_balloon_model_solver(time_vec, blood_flow_signal_decay_rate, flow_dependent_elimination_constant, neural_activity_impulse, relative_mollification,t_min, t_max)

if nargin < 5
relative_mollification = 0;
end

if nargin < 6
t_min = time_vec(1);
t_max = time_vec(end);
end

f = 1; 
df = 0; 

if relative_mollification > 0
[f, df] = zef_nse_mollifier(relative_mollification,time_vec,t_min,t_max);
end

a = blood_flow_signal_decay_rate;
b = flow_dependent_elimination_constant;
g = neural_activity_impulse;
t = time_vec;

r1 = (-a + sqrt(a^2 - 4*b)) / 2;
r2 = (-a - sqrt(a^2 - 4*b)) / 2;

C1 = g / ( r1 - r2 );
C2 = -g / ( r1 - r2 );

y = C1 * exp(r1 * t) + C2 * exp(r2 * t);
dy = C1 * r1 * exp(r1 * t) + C2 * r2 * exp(r2 * t);

y = y.*f;
dy = y.*df + dy.*f;

end