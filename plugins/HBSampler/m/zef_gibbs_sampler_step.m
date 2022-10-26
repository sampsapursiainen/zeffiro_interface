%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [x, theta] = zef_gibbs_sampler_step(L, y, x, theta, theta0, beta, std_lhood, hypermodel, decay_val_hyperprior, nbins_hyperprior, source_direction_mode)
%One-dimensional sampling resolution.

if nargin < 8
hypermodel = 'InverseGamma';
end 

if nargin < 9
decay_val_hyperprior = 7;
end

if nargin < 10
nbins_hyperprior = 20;
end

if nargin < 11
source_direction_mode = 1;
end

%One-dimensional sampling tolerance (constant c in the slides).

if isempty(x)
x = zeros(size(L,2),1);
end

if length(theta0) == 1
is_vec_theta0 = 0;
theta0j = theta0;
else
is_vec_theta0 = 1;
end

if length(beta) == 1
is_vec_beta = 0;
etaj = beta - 1.5;
kappaj = beta + 1.5;
else
is_vec_beta = 1;
end

if isempty(theta)
    if is_vec_theta0
        theta = theta0; 
    else
theta = theta0*ones(size(L,2),1);
    end
end

n_dimensions = size(L,2);
size_L = size(L,1);
size_x = size(x,1);

    inv_d = 1./theta;

    if source_direction_mode == 2

    sqrt_inv_d = sqrt(inv_d);
    y_2 = [y + std_lhood*randn(size(y));
    std_lhood*randn(size(x))];
    aux_0 = [L*x ; std_lhood.*sqrt_inv_d.*x];
    for j = 1 : n_dimensions
    aux_1 = zeros(size_L+size_x,1);
    aux_1(1:size_L) = L(:,j);
    aux_1(size_L + j) = std_lhood*sqrt_inv_d(j);
    x_old = x(j);
    aux_ind_2 = find(aux_1);
    aux_1 = full(aux_1(aux_ind_2));
    y_aux = y_2(aux_ind_2) - aux_0(aux_ind_2) + aux_1*x_old;
    t_max = sum(y_aux.*aux_1)/sum(aux_1.*aux_1);
    t_int = std_lhood*sqrt(2*t_tol/sum(aux_1.^2));
    if t_max >= 0
    d_1 = max(0,t_max - t_int);
    d_2 = t_max + t_int;
    aux_2 = (y_aux - aux_1*t_max);
    aux_2 = (1/(2*std_lhood.^2))*sum(aux_2.*aux_2);
    else
    d_1 = 0;
    d_2 = t_max + sqrt(t_max^2 + 2*std_lhood^2*t_tol/sum(aux_1.^2));
    aux_2 = y_aux;
    aux_2 = (1/(2*std_lhood.^2))*sum(aux_2.*aux_2);
    end
    t = [d_1 : (d_2 - d_1)/(t_res-1) : d_2];
    y_aux = y_aux(:,ones(1,t_res));
    aux_3 = y_aux - aux_1(:,ones(t_res,1)).*t(ones(size(aux_ind_2)),:);
    p = exp(aux_2 -(1/(2*std_lhood^2))*sum(aux_3.*aux_3));
    Phi = cumsum(p);
    tau = Phi(end)*rand;
    rand_ind = find( Phi > tau, 1);
    if isempty(rand_ind)
    rand_ind = 1;
    end
    x(j) = t(rand_ind);
    aux_0(aux_ind_2) = aux_0(aux_ind_2) + aux_1*(x(j)-x_old);
    end

else

x = (L'*L + std_lhood^2*diag(inv_d))\(L'*(y + std_lhood*randn(size(y))) + std_lhood^2*sqrt(inv_d).*randn(size(x)));

    end

if strcmp(hypermodel,'Gamma')

        for j = 1 : n_dimensions
            xj = abs(x(j));
            if is_vec_theta0
                theta0j = theta0(j);
            end
            if is_vec_beta
            etaj = beta(j)-1.5;
            kappaj = beta(j)+1.5;
            end
            p_max_th = theta0j.*(etaj +sqrt((1./(2*theta0j)).*xj^2 + etaj^2));
            thmin = eps;
            second_derivative_abs = abs(xj^2/(p_max_th^3) + etaj/(p_max_th^2));
            p_max_abs = abs(-0.5*(xj^2)./p_max_th - (p_max_th./theta0j) + etaj*log(p_max_th));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0j) + etaj*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0j + etaj/thmax);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0j) + etaj*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0j + etaj/thmax);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0j) + etaj*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0j + etaj/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            aux_vec = -0.5*(xj^2)./tj;
            aux_vec = aux_vec - (tj/theta0j);
            aux_vec = aux_vec + etaj*log(tj);
            p = exp(aux_vec);
             Phi = cumsum(p);
%              figure(2); clf; plot(tj,p/Phi(end),'linewidth',5);set(gca,'box','on');
%              set(gca,'linewidth',5); set(gca,'fontsize',35);
%              print(2,'-r300','-dpng','pic_0.png'); pause;
%             pause(0.2);
            tau = Phi(end)*rand;
            aux_ind = find(Phi>=tau);
            indj = aux_ind(1);
            theta(j) = tj(indj);

        end

    elseif strcmp(hypermodel,'InverseGamma')

        for j = 1 : n_dimensions
            
            xj = abs(x(j));
            if is_vec_theta0
            theta0j = theta0(j);
            end
            if is_vec_beta
            etaj = beta(j)-1.5;
            kappaj = beta(j)+1.5;
            end
            p_max_th = kappaj/(theta0j+0.5*xj^2);
            thmin = eps;
            second_derivative_abs = abs(-kappaj/(p_max_th^2));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0j*p_max_th - kappaj*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0j*thmax + kappaj*log(thmax))/(-0.5*xj^2 - theta0j + kappaj/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0j*p_max_th - kappaj*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0j*thmax + kappaj*log(thmax))/(-0.5*xj^2 - theta0j + kappaj/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0j*p_max_th - kappaj*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0j*thmax + kappaj*log(thmax))/(-0.5*xj^2 - theta0j + kappaj/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            p = exp(-0.5*xj^2*tj - theta0j*tj + (kappaj-2)*log(tj));
            Phi = cumsum(p);
            tau = Phi(end)*rand;
            aux_ind = find(Phi>=tau);
            indj = aux_ind(1);
            theta(j) = 1./tj(indj);
%             figure(2); clf; plot(tj,p/Phi(end),'linewidth',5);set(gca,'box','on');
%             set(gca,'linewidth',5); set(gca,'fontsize',35);
%             print(2,'-r300','-dpng','pic_0.png'); pause;
%               pause(0.2);
        end
end


