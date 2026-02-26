%% jansen_rit_445.m
% Implements system (4.45) from Cook et al. (2022) / arXiv:2103.10554:
%
%   Vp''   = A*a*f(Vpe - Vpi)                 - 2*a*Vp'   - a^2*Vp
%   Vpe''  = A*a*(cp_e*f(nu_e_p*Vp) + qp_e(t)) - 2*a*Vpe'  - a^2*Vpe
%   Vpi''  = B*b*(cp_i*f(nu_i_p*Vp))           - 2*b*Vpi'  - b^2*Vpi
%
% State choice: x = [Vp; Vp_dot; Vpe; Vpe_dot; Vpi; Vpi_dot].


%% Parameters (reasonable defaults; adjust as needed)
par.A      = 3.25;     % excitatory synaptic gain  (A)
par.B      = 22.0;     % inhibitory synaptic gain  (B)
par.a      =  50;      % excitatory rate constant  (a = 1/mu_e)
par.b      =  75;       % inhibitory rate constant  (b = 1/mu_i)

% Couplings in (4.45) z(often written as scaled by a global C in the paper text)
par.cp_e   = 135;      % c_{p,e}
par.cp_i   = 33.75;    % c_{p,i}
par.nu_e_p = 108;      % nu_{e,p}
par.nu_i_p = 27;       % nu_{i,p}

% Sigmoid (wave-to-pulse) parameters: f(v) = 2e0/(1+exp(r*(v0 - v)))
par.e0 = 2.5;          % [s^-1]
par.v0 = 6;            % [mV]
par.r  = 0.56;         % [mV^-1]

%% External input q_{p,e}(t)
% Example: constant drive + a brief pulse
par.q0        =  80;    % baseline input
par.pulseAmp  = 80;     % pulse amplitude
par.pulseT0   = 0.10;   % pulse start time (s)
par.pulseDur  = 0.5   % pulse duration (s)


%qp_e = @(t) par.q0 + par.pulseAmp * double(t >= par.pulseT0 & t <= par.pulseT0 + par.pulseDur);
qp_e = @(t) par.q0 + par.pulseAmp * sin(2*pi*3*t/par.pulseDur).*double(t >= par.pulseT0 & t <= par.pulseT0 + par.pulseDur);

%% Simulation time and initial condition
tspan = [0, 1.0];  % seconds

% Initial conditions: [Vp, Vp_dot, Vpe, Vpe_dot, Vpi, Vpi_dot]
x0 = zeros(6,1);

%% Integrate
opts = odeset('RelTol',1e-7,'AbsTol',1e-9);
rhs  = @(t,x) jr445_rhs(t, x, par, qp_e);

[t, x] = ode45(rhs, tspan, x0, opts);

Vp  = x(:,1);
Vpe = x(:,3);
Vpi = x(:,5);

% Model "EEG-like" output often taken as u_p(t) = Vpe - Vpi
up = Vpe - Vpi;

%% Plot
figure;
plot(t, up, 'LineWidth', 1.2);
xlabel('t (s)'); ylabel('u_p(t) = V_{p,e}(t) - V_{p,i}(t)');
title('System (4.45) simulation output');
grid on;

figure;
plot(t, [Vp, Vpe, Vpi], 'LineWidth', 1.2);
xlabel('t (s)'); ylabel('Potentials (mV)');
legend('V_p','V_{p,e}','V_{p,i}','Location','best');
title('State variables');
grid on;

%% --- Local functions ---
function dx = jr445_rhs(t, x, par, qp_e)
    % Unpack
    Vp    = x(1);  Vp_d  = x(2);
    Vpe   = x(3);  Vpe_d = x(4);
    Vpi   = x(5);  Vpi_d = x(6);

    % Sigmoid firing rate
    f1 = sigmoid(Vpe - Vpi, par);          % f(Vpe - Vpi)
    f2 = sigmoid(par.nu_e_p * Vp, par);    % f(nu_e_p * Vp)
    f3 = sigmoid(par.nu_i_p * Vp, par);    % f(nu_i_p * Vp)

    % Second derivatives from (4.45)
    Vp_dd  = par.A*par.a*f1 - 2*par.a*Vp_d  - (par.a^2)*Vp;
    Vpe_dd = par.A*par.a*(par.cp_e*f2 + qp_e(t)) - 2*par.a*Vpe_d - (par.a^2)*Vpe;
    Vpi_dd = par.B*par.b*(par.cp_i*f3) - 2*par.b*Vpi_d - (par.b^2)*Vpi;

    % First-order form
    dx = zeros(6,1);
    dx(1) = Vp_d;
    dx(2) = Vp_dd;
    dx(3) = Vpe_d;
    dx(4) = Vpe_dd;
    dx(5) = Vpi_d;
    dx(6) = Vpi_dd;
end

function y = sigmoid(v, par)
    % Standard Jansen–Rit sigmoid: 2e0 / (1 + exp(r*(v0 - v)))
    y = (2*par.e0) ./ (1 + exp(par.r*(par.v0 - v)));
end
