%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%One-dimensional sampling resolution.
t_res = 20;
%One-dimensional sampling tolerance (constant c in the slides).
t_tol = 7;

if evalin('base','zef.inv_hyperprior') == 2
hypermodel = 'Gamma';
else
hypermodel = 'InverseGamma';
end

eta = beta - 1.5;
kappa = beta + 1.5;

decay_val_hyperprior = t_tol;
nbins_hyperprior = t_res;
A_aux = L;
y = f;
n_dimensions = size(A_aux,2);

x = zeros(n_dimensions,1);
x_cm = zeros(n_dimensions,1);
size_A_aux = size(A_aux,1);
size_x = size(x,1);

if length(theta0) == 1
    theta0 = theta0*ones(size_x,1);
end

if length(eta) == 1
    eta = eta*ones(size_x,1);
end

if length(kappa) == 1
    kappa= kappa*ones(size_x,1);
end


i = 0;

tic;
for i = 1 : n_iter

    inv_d = 1./theta;

    if evalin('base','zef.source_direction_mode') == 2

    sqrt_inv_d = sqrt(inv_d);
    y_2 = [y + std_lhood*randn(size(y));
    std_lhood*randn(size(x))];
    aux_0 = [A_aux*x ; std_lhood.*sqrt_inv_d.*x];
    for j = 1 : n_dimensions
    aux_1 = zeros(size_A_aux+size_x,1);
    aux_1(1:size_A_aux) = A_aux(:,j);
    aux_1(size_A_aux + j) = std_lhood*sqrt_inv_d(j);
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

x = (A_aux'*A_aux + std_lhood^2*diag(inv_d))\(A_aux'*(y + std_lhood*randn(size(y))) + std_lhood^2*sqrt(inv_d).*randn(size(x)));

    end

if strcmp(hypermodel,'Gamma')

        for j = 1 : n_dimensions
            xj = abs(x(j));
            p_max_th = theta0(j).*(eta(j) +sqrt((1./(2*theta0(j))).*xj^2 + eta(j)^2));
            thmin = eps;
            second_derivative_abs = abs(xj^2/(p_max_th^3) + eta(j)/(p_max_th^2));
            p_max_abs = abs(-0.5*(xj^2)./p_max_th - (p_max_th./theta0(j)) + eta(j)*log(p_max_th));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0(j)) + eta(j)*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0(j) + eta(j)/thmax);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0(j)) + eta(j)*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0(j) + eta(j)/thmax);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0(j)) + eta(j)*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0(j) + eta(j)/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            aux_vec = -0.5*(xj^2)./tj;
            aux_vec = aux_vec - (tj/theta0(j));
            aux_vec = aux_vec + eta(j)*log(tj);
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
            p_max_th = kappa(j)/(theta0(j)+0.5*xj^2);
            thmin = eps;
            second_derivative_abs = abs(-kappa(j)/(p_max_th^2));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0(j)*p_max_th - kappa(j)*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0(j)*thmax + kappa(j)*log(thmax))/(-0.5*xj^2 - theta0(j) + kappa(j)/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0(j)*p_max_th - kappa(j)*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0(j)*thmax + kappa(j)*log(thmax))/(-0.5*xj^2 - theta0(j) + kappa(j)/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0(j)*p_max_th - kappa(j)*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0(j)*thmax + kappa(j)*log(thmax))/(-0.5*xj^2 - theta0(j) + kappa(j)/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            p = exp(-0.5*xj^2*tj - theta0(j)*tj + (kappa(j)-2)*log(tj));
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

if i > burn_in
x_cm = x_cm + x;
end

if mod(i,floor(n_iter/50)) == 0
time_val = toc;
zef_waitbar(i/n_iter,h,['Sampling. Ready approx. ' datestr(datevec(now+(n_iter/i - 1)*time_val/86400)) '.']);
end

end

z_vec = x_cm/(n_iter - burn_in);


%z_vec = zeros(size(L,2),1);
%z_vec(roi_aux_ind) = x_cm./max(abs(x_cm(:)));

%close(h);
