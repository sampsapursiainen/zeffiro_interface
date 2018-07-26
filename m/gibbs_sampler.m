%Copyright © 2018, Sampsa Pursiainen
%Region of interest (ROI):
r_roi = roi_sphere(:,4); 
c_roi = roi_sphere(:,1:3)';
%source_threshold = 0.2;
%Total iterations.
n_iter = n_sampler;
%Burn-in sequence.
burn_in = n_burn_in;
%Sources tracked.
pixel_ind_vec = [];
%One-dimensional sampling resolution.
t_res = 20;
%One-dimensional sampling tolerance (constant c in the slides).
t_tol = 7;

I_aux = [];
roi_ind_vec = [];

if roi_mode == 1

    
for j = 1 : size(roi_sphere,1)

r_aux = find(sqrt(sum((source_positions'-c_roi(:,j*ones(1,size(source_positions,1)))).^2))<=r_roi(j));
I_aux = [I_aux r_aux];
roi_ind_vec = [roi_ind_vec j*ones(1,size(r_aux,2))];

end
roi_ind_vec = roi_ind_vec(:);
end

if roi_mode == 2
reconstruction = evalin('base','zef.reconstruction');
reconstruction = reconstruction(s_ind_1);
reconstruction = reshape(reconstruction,length(reconstruction)/3,3);
reconstruction = sqrt(sum(reconstruction.^2,2));
reconstruction = reconstruction/max(reconstruction(:));
I_aux = find(reconstruction >= roi_threshold);
end

if source_direction_mode == 1
roi_aux_ind = [I_aux(:) ; n_interp + I_aux(:) ; 2*n_interp + I_aux(:)];
else
roi_aux_ind = I_aux(:);
end
roi_aux_ind = roi_aux_ind(:);

if evalin('base','zef.inv_hyperprior') == 1
hypermodel = 'Gamma';
else
hypermodel = 'InverseGamma';
end

eta = beta - 1.5;
kappa = beta + 1.5;

decay_val_hyperprior = t_tol;
nbins_hyperprior = t_res;
A_aux = L(:,roi_aux_ind);
y = f;
n_dimensions = size(A_aux,2);

%x = y;
x = zeros(n_dimensions,1);
%x(ind_vec) = image_exact(ind_vec);
x_cm = zeros(n_dimensions,1);
x_history = zeros(length(pixel_ind_vec), n_iter);
theta = theta0*ones(size(x));
size_A_aux = size(A_aux,1);
size_x = size(x,1);

i = 0;
h = waitbar(i/n_iter,['Sampling.']); 

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
            p_max_th = theta0*(eta +sqrt((1/(2*theta0))*xj^2 + eta^2));
            thmin = eps;
            second_derivative_abs = abs(xj^2/(p_max_th^3) + eta/(p_max_th^2));
            p_max_abs = abs(-0.5*(xj^2)./p_max_th - (p_max_th/theta0) + eta*log(p_max_th));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            aux_vec = -0.5*(xj^2)./tj; 
            aux_vec = aux_vec - (tj/theta0);  
            aux_vec = aux_vec + eta*log(tj);
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
            p_max_th = kappa/(theta0+0.5*xj^2);
            thmin = eps;
            second_derivative_abs = abs(-kappa/(p_max_th^2));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            p = exp(-0.5*xj^2*tj - theta0*tj + (kappa-2)*log(tj));
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
x_history(:,i) = x(pixel_ind_vec);

if mod(i,floor(n_iter/50)) == 0
time_val = toc;
waitbar(i/n_iter,h,['Sampling. Ready approx. ' datestr(datevec(now+(n_iter/i - 1)*time_val/86400)) '.']);
end

end

x_history_burn_in = x_history(:,1:burn_in);
x_history = x_history(:,burn_in+1:end);
x_cm = x_cm/(n_iter - burn_in);
z_vec = x_cm;

if source_direction_mode == 2 || source_direction_mode == 3
z_vec = [z_vec.*source_directions(roi_aux_ind,1); z_vec.*source_directions(roi_aux_ind,2);  z_vec.*source_directions(roi_aux_ind,3)];
%z_vec = z_vec(:);
end


if roi_mode == 1

rec_size = length(roi_ind_vec);
for j = 1 : size(roi_sphere,1)
    r_aux = find(roi_ind_vec==j);
    w_vec = (sum([z_vec(r_aux) z_vec(rec_size+r_aux) z_vec(2*rec_size +r_aux)].^2,2));
    rec_pos = [w_vec.*source_positions(roi_aux_ind(r_aux),1) w_vec.*source_positions(roi_aux_ind(r_aux),2) w_vec.*source_positions(roi_aux_ind(r_aux),3)];
    rec_pos = sum(rec_pos)./sum([w_vec w_vec w_vec]);
    rec_dir =  1e3*sum([z_vec(r_aux) z_vec(rec_size+r_aux) z_vec(2*rec_size +r_aux)]);
    rec_norm = norm(rec_dir); 
    rec_dir = rec_dir/rec_norm;
rec_source(j,1:7) = [rec_pos rec_dir rec_norm];
end

end

z_vec = zeros(size(L,2),1);
z_vec(roi_aux_ind) = x_cm./max(abs(x_cm(:)));

close(h);
