function [z,Var_loc] = zef_beamformer

h = waitbar(0,['Beamformer.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);
snr_val = evalin('base','zef.inv_snr');
std_lhood = 10^(-snr_val/20);
lambda_cov = evalin('base','zef.inv_cov_lambda');
lambda_L = evalin('base','zef.inv_leadfield_lambda');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
time_step = evalin('base','zef.inv_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');

if source_direction_mode == 2

[s_ind_3] = evalin('base','zef.source_interpolation_ind{3}'); 

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
for k = 1 : 27
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
        var_3 = 'zef.d1_visible';
    color_str = evalin('base','zef.d1_color');
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
        var_3 = 'zef.d2_visible';
        color_str = evalin('base','zef.d2_color');
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
        var_3 = 'zef.d3_visible';
        color_str = evalin('base','zef.d3_color');
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
        var_3 = 'zef.d4_visible';
        color_str = evalin('base','zef.d4_color');
     case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
        var_3 = 'zef.d5_visible';
    color_str = evalin('base','zef.d5_color');
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';   
        var_2 = 'zef.d6_priority';
        var_3 = 'zef.d6_visible';
        color_str = evalin('base','zef.d6_color');
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';   
        var_2 = 'zef.d7_priority';
        var_3 = 'zef.d7_visible';
        color_str = evalin('base','zef.d7_color');
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';   
        var_2 = 'zef.d8_priority';
        var_3 = 'zef.d8_visible';
        color_str = evalin('base','zef.d8_color');
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';   
        var_2 = 'zef.d9_priority';
        var_3 = 'zef.d9_visible';
        color_str = evalin('base','zef.d9_color');
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';   
        var_2 = 'zef.d10_priority';
        var_3 = 'zef.d10_visible';
        color_str = evalin('base','zef.d10_color');
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';   
        var_2 = 'zef.d11_priority';
        var_3 = 'zef.d11_visible';
        color_str = evalin('base','zef.d11_color');
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';   
        var_2 = 'zef.d12_priority';
        var_3 = 'zef.d12_visible';
        color_str = evalin('base','zef.d12_color');
     case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';   
        var_2 = 'zef.d13_priority';
        var_3 = 'zef.d13_visible';
        color_str = evalin('base','zef.d13_color');
  case 14
        var_0 = 'zef.d14_on';
        var_1 = 'zef.d14_sigma';
        var_2 = 'zef.d14_priority';
        var_3 = 'zef.d14_visible';
    color_str = evalin('base','zef.d14_color');
  case 15
        var_0 = 'zef.d15_on';
        var_1 = 'zef.d15_sigma';   
        var_2 = 'zef.d15_priority';
        var_3 = 'zef.d15_visible';
        color_str = evalin('base','zef.d15_color');
     case 16
        var_0 = 'zef.d16_on';
        var_1 = 'zef.d16_sigma';   
        var_2 = 'zef.d16_priority';
        var_3 = 'zef.d16_visible';
        color_str = evalin('base','zef.d16_color');
     case 17
        var_0 = 'zef.d17_on';
        var_1 = 'zef.d17_sigma';   
        var_2 = 'zef.d17_priority';
        var_3 = 'zef.d17_visible';
        color_str = evalin('base','zef.d17_color');
    case 18
        var_0 = 'zef.d18_on';
        var_1 = 'zef.d18_sigma';   
        var_2 = 'zef.d18_priority';
        var_3 = 'zef.d18_visible';
        color_str = evalin('base','zef.d18_color');
     case 19
        var_0 = 'zef.d19_on';
        var_1 = 'zef.d19_sigma';   
        var_2 = 'zef.d19_priority';
        var_3 = 'zef.d19_visible';
        color_str = evalin('base','zef.d19_color');
     case 20
        var_0 = 'zef.d20_on';
        var_1 = 'zef.d20_sigma';   
        var_2 = 'zef.d20_priority';
        var_3 = 'zef.d20_visible';
        color_str = evalin('base','zef.d20_color');
     case 21
        var_0 = 'zef.d21_on';
        var_1 = 'zef.d21_sigma';   
        var_2 = 'zef.d21_priority';
        var_3 = 'zef.d21_visible';
        color_str = evalin('base','zef.d21_color');
     case 22
        var_0 = 'zef.d22_on';
        var_1 = 'zef.d22_sigma';   
        var_2 = 'zef.d22_priority';
        var_3 = 'zef.d22_visible';
        color_str = evalin('base','zef.d22_color');
    case 23
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 24
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 25
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 26
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 27
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        color_str = evalin('base','zef.sc_color');
     end
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
if k == 1 && evalin('base','zef.d1_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d1_sources')-1];
end
if k == 2 && evalin('base','zef.d2_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d2_sources')-1];
end
if k == 3 && evalin('base','zef.d3_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d3_sources')-1];
end
if k == 4 && evalin('base','zef.d4_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d4_sources')-1];
end
if k == 5 && evalin('base','zef.d5_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d5_sources')-1];
end
if k == 6 && evalin('base','zef.d6_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d6_sources')-1];
end
if k == 7 && evalin('base','zef.d7_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d7_sources')-1];
end
if k == 8 && evalin('base','zef.d8_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d8_sources')-1];
end
if k == 9 && evalin('base','zef.d9_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d9_sources')-1];
end
if k == 10 && evalin('base','zef.d10_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d10_sources')-1];
end
if k == 11 && evalin('base','zef.d11_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d11_sources')-1];
end
if k == 12 && evalin('base','zef.d12_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d12_sources')-1];
end
if k == 13 && evalin('base','zef.d13_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d13_sources')-1];
end
if k == 14 && evalin('base','zef.d14_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d14_sources')-1];
end
if k == 15 && evalin('base','zef.d15_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d15_sources')-1];
end
if k == 16 && evalin('base','zef.d16_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d16_sources')-1];
end
if k == 17 && evalin('base','zef.d17_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d17_sources')-1];
end
if k == 18 && evalin('base','zef.d18_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d18_sources')-1];
end
if k == 19 && evalin('base','zef.d19_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d19_sources')-1];
end
if k == 20 && evalin('base','zef.d20_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d20_sources')-1];
end
if k == 21 && evalin('base','zef.d21_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d21_sources')-1];
end
if k == 22 && evalin('base','zef.d22_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.d22_sources')-1];
end
if k == 23 && evalin('base','zef.w_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.w_sources')-1];
end
if k == 24 && evalin('base','zef.g_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.g_sources')-1];
end
if k == 25 && evalin('base','zef.c_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.c_sources')-1];
end
if k == 26 && evalin('base','zef.sk_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.sk_sources')-1];
end
if k == 27 && evalin('base','zef.sc_sources');
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base','zef.sc_sources')-1];
end
end
end

a_d_i_vec = [];
aux_p = [];
aux_t = [];

for ab_ind = 1 : length(aux_brain_ind)

aux_t = [aux_t ; size(aux_p,1) + evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
aux_p = [aux_p ; evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];
a_d_i_vec = [a_d_i_vec ; aux_dir_mode(ab_ind)*ones(size(evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']),1),1)];

end

a_d_i_vec = a_d_i_vec(aux_t(:,1));
n_vec_aux = cross(aux_p(aux_t(:,2),:)' - aux_p(aux_t(:,1),:)', aux_p(aux_t(:,3),:)' - aux_p(aux_t(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

n_vec_aux(:,1) = smooth_field(aux_t, n_vec_aux(:,1), size(aux_p(:,1),1),7);
n_vec_aux(:,2) = smooth_field(aux_t, n_vec_aux(:,2), size(aux_p(:,1),1),7);
n_vec_aux(:,3) = smooth_field(aux_t, n_vec_aux(:,3), size(aux_p(:,1),1),7);

n_vec_aux =  - n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

s_ind_4 = find(not(a_d_i_vec(s_ind_3)));
source_directions = n_vec_aux(s_ind_3,:);

end

if source_direction_mode == 3
source_directions = source_directions(s_ind_1,:);
end

if source_direction_mode == 1  || source_direction_mode == 2
s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end
if  source_direction_mode == 3
s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end

s_ind_1 = s_ind_1(:);

L = evalin('base','zef.L');
L = L(:,s_ind_1);

if source_direction_mode == 2

L_1 = L(:,1:n_interp);
L_2 = L(:,n_interp+1:2*n_interp);
L_3 = L(:,2*n_interp+1:3*n_interp);
s_1 = source_directions(:,1)';
s_2 = source_directions(:,2)';
s_3 = source_directions(:,3)';
ones_vec = ones(size(L,1),1);
L_0 = L_1(:,s_ind_4).*s_1(ones_vec,s_ind_4) + L_2(:,s_ind_4).*s_2(ones_vec,s_ind_4) + L_3(:,s_ind_4).*s_3(ones_vec,s_ind_4);
L(:,s_ind_4) = L_0;
L(:,n_interp+s_ind_4) = L_0;
L(:,2*n_interp+s_ind_4) = L_0;
clear L_0 L_1 L_2 L_3 s_1 s_2 s_3;
end

L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));

if number_of_frames > 1
z = cell(number_of_frames,1);
Var_loc = cell(number_of_frames,1);
else
number_of_frames = 1;
end


if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.inv_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end


data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:))); 
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max(sqrt(sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
%std_lhood = std_lhood^2;
end;
f = f/data_norm;


filter_order = 3;
if size(f,2) > 1 && low_pass > 0
[lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));
f = filter(lp_f_1,lp_f_2,f')';
end
if size(f,2) > 1 && high_pass > 0
[hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');
f = filter(hp_f_1,hp_f_2,f')';
end

f_data = f;
size_f = size(f,2);


            
        


tic;
%------------------ TIME LOOP STARTS HERE ------------------------------
for f_ind = 1 : number_of_frames
time_val = toc; 
if f_ind > 1
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end


if ismember(source_direction_mode, [1,2]) 
z_aux = zeros(size(L,2),1);
Var_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3 
z_aux = zeros(3*size(L,2),1);
Var_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);
Var_vec = ones(size(L,2),1);

if size_f > 1
if evalin('base','zef.inv_time_2') >=0 && evalin('base','zef.inv_time_1') >= 0 && 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size_f;
f = f_data(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))) : min(size_f, 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))));
end
end

if f_ind == 1
waitbar(0,h,['Beamformer. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

if size_f > 1
f = mean(f,2);
end

%---------------CALCULATIONS STARTS HERE----------------------------------
%Data covariance matrix and its regularization
if evalin('base','zef.cov_type') == 1
    C = (f-mean(f,1))*(f-mean(f,1))'/size(f,2);
    C = C+lambda_cov*trace(C)*eye(size(C))/size(f,1);
elseif evalin('base','zef.cov_type') == 2
    C = (f-mean(f,1))*(f-mean(f,1))'/size(f,2);
    C = C + lambda_cov*eye(size(C));
end

if evalin('base','zef.bf_type') == 1
   %__ LCMV Beamformer __
   
    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(s_ind_1)/3;
        %L_ind = [s_ind_1(1:nn),s_ind_1(nn+(1:nn)),s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(s_ind_1);
        L_ind = transpose(1:nn);
    end
    
    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));
    
    f = sqrtm(C)\f;
    L_aux2 = sqrtm(C)\L;
    
    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1 && n_iter > 1
            time_val = toc; 
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        
        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            if ismember(L_ind(n_iter,1),s_ind_4)
                L_aux = L_aux2(:,L_ind(n_iter,1));
            else
                %Leadfield normalizations
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by 
                    %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                    %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                    %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                    %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                end
            end
        else
        %Leadfield normalizations
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by 
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
        end
        end
        
        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            invLTinvCL = inv(L_aux'*L_aux+lambda_L*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==2
            disp(0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2)))
            invLTinvCL = inv(L_aux'*L_aux+0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==3
            invLTinvCL = pinv(L_aux'*L_aux);
        end
        
        %dipole momentum estimate:
        
        z_vec(L_ind(n_iter,:)) = real(invLTinvCL*L_aux'*f);
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');
        
        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;    
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['LCMV iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end

elseif evalin('base','zef.bf_type') == 2
    %__ Sekihara's Borgiotti-Kaplan Beamformer __
%Inversion method is based on article's "Reconstructing Spatio-Temporal Activities of
%Neural Sources Using an MEG Vector Beamformer Technique1" description. 
%K. Sekihara et al., IEEE TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. 48, NO. 7, JULY 2001 
    
    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(s_ind_1)/3;
        %L_ind = [s_ind_1(1:nn),s_ind_1(nn+(1:nn)),s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(s_ind_1);
        L_ind = transpose(1:nn);
    end
    
    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));
    L_aux2 = sqrtm(C)\L;
    
    for n_iter = 1:nn 
        %Date string if one time point
        if number_of_frames == 1  && n_iter > 1
            time_val = toc; 
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end
        
        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            %=== NORMAL DIRECTIONED COMPONENTS ===
            if ismember(L_ind(n_iter,1),s_ind_4)
                L_aux = L(:,L_ind(n_iter,1));
                %Leadfield regularization
                if evalin('base','zef.L_reg_type')==1
                    lambdaI = lambda_L*eye(size(L_aux,2));
                elseif evalin('base','zef.L_reg_type')==2
                    lambdaI = 0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2));
                end
                L_aux = L_aux2(:,L_ind(n_iter,1));
                if evalin('base','zef.L_reg_type')==3
                    weights = C\pinv(L_aux)';
                else
                    weights = (C\L(:,L_ind(n_iter,1)))/(L_aux'*L_aux+lambdaI);
                end
            %Leadfield normalization can not be used with scalar beamformer and therefore need to be carefully valuated in general 
            %when norma leadfiel direction is used.
            %=== CARTESIAN DIRECTIONED COMPONENTS ===
            else
                L_aux = L(:,L_ind(n_iter,1));
                %Leadfield regularization
                if evalin('base','zef.L_reg_type')==1
                    lambdaI = lambda_L*eye(size(L_aux,2));
                elseif evalin('base','zef.L_reg_type')==2
                    lambdaI = 0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2));
                end
                %Leadfield normalization
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by 
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                      L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                      if ~ismember(evalin('base','zef.L_reg_type'),[3])
                          weights = C\L_aux;
                          weights = weights/(L_aux'*L_aux+lambdaI);
                      else
                          weights = C\pinv(L_aux)';
                      end
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                    if ~ismember(evalin('base','zef.L_reg_type'),[3])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                    if ~ismember(evalin('base','zef.L_reg_type'),[3])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                    if ~ismember(evalin('base','zef.L_reg_type'),[3])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                end
            end
        else
        L_aux = L(:,L_ind(n_iter,1));
        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            lambdaI = lambda_L*eye(size(L_aux,2));
        elseif evalin('base','zef.L_reg_type')==2
            lambdaI = 0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2));
        end
        %Leadfield normalization
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by 
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
            if ~ismember(evalin('base','zef.L_reg_type'),[3])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = weights*pinv(L_aux'*L_aux);
            end
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
            if ~ismember(evalin('base','zef.L_reg_type'),[3])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = weights*pinv(L_aux'*L_aux);
            end
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
            if ~ismember(evalin('base','zef.L_reg_type'),[3])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = C\pinv(L_aux)';
            end
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
            if ~ismember(evalin('base','zef.L_reg_type'),[3])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = C\pinv(L_aux)';
            end
        end
        end
        %Borgiotti-Kaplan steering:
        weights = weights./sqrt(sum(weights.^2,1));
        
        %dipole moment estimation:
        z_vec(L_ind(n_iter,:)) = real(weights'*f);
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');
 
        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;    
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['UNG iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end
    
elseif evalin('base','zef.bf_type') == 3
   %__ Unit-Gain constraint Beamformer __
   
    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(s_ind_1)/3;
        %L_ind = [s_ind_1(1:nn),s_ind_1(nn+(1:nn)),s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(s_ind_1);
        L_ind = transpose(1:nn);
    end
    
    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));
    
    f = sqrtm(C)\f;
    L_aux2 = sqrtm(C)\L;
    
    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1 && n_iter > 1
            time_val = toc; 
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        
        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            if ismember(L_ind(n_iter,1),s_ind_4)
                L_aux = L_aux2(:,L_ind(n_iter,1));
            else
                %Leadfield normalizations
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by 
                    %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                    %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                    %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                    %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                end
            end
        else
        %Leadfield normalizations
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by 
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
        end
        end
        
        %Find optiomal orienation via Rayleigh-Ritz formula
        [opt_orientation ,~] = eigs(L_aux'*L_aux,1,'smallestabs');
        opt_orientation = opt_orientation/norm(opt_orientation);
        L_aux = L_aux*opt_orientation;
        
        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            invLTinvCL = inv(L_aux'*L_aux+lambda_L*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==2
            disp(0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2)))
            invLTinvCL = inv(L_aux'*L_aux+0.5*max(mean(L_aux'*L_aux,'all'),min(abs(L_aux'*L_aux),[],'all'))*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==3
            invLTinvCL = pinv(L_aux'*L_aux);
        end
        
        %dipole momentum estimate:
        
        z_vec(L_ind(n_iter,:)) = real(invLTinvCL*L_aux'*f)*opt_orientation;
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');
        
        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;    
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['LCMV iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end

end
% %location estimation:
% current_vec = [z_vec(ind(:,1)),z_vec(ind(:,2)),z_vec(ind(:,3))];
% Var_vec(ind(:,1)) = sum((current_vec-mean(current_vec,1)).^2,2);
% Var_vec(ind(:,2)) = Var_vec(ind(:,1));
% Var_vec(ind(:,3)) = Var_vec(ind(:,1));

%------------------------------------------------------------------

if ismember(source_direction_mode,[2])
z_vec_aux = (z_vec(s_ind_4) + z_vec(n_interp+s_ind_4) + z_vec(2*n_interp+s_ind_4))/3;
z_vec(s_ind_4) = z_vec_aux.*source_directions(s_ind_4,1); 
z_vec(n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,2); 
z_vec(2*n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,3); 

Var_loc_aux = (Var_vec(s_ind_4) + Var_vec(n_interp+s_ind_4) + Var_vec(2*n_interp+s_ind_4))/3;
Var_vec(s_ind_4) = Var_loc_aux.*source_directions(s_ind_4,1); 
Var_vec(n_interp+s_ind_4) = Var_loc_aux.*source_directions(s_ind_4,2); 
Var_vec(2*n_interp+s_ind_4) = Var_loc_aux.*source_directions(s_ind_4,3);
end

if ismember(source_direction_mode,[3])
z_vec = [z_vec.*source_directions(:,1); z_vec.*source_directions(:,2); z_vec.*source_directions(:,3)];
Var_vec = [Var_vec.*source_directions(:,1); Var_vec.*source_directions(:,2); Var_vec.*source_directions(:,3)];
end

if ismember(source_direction_mode,[1 2])
z_aux(s_ind_1) = z_vec;
Var_aux(s_ind_1) = Var_vec;
end
if ismember(source_direction_mode,[3])
z_aux(s_ind_2) = z_vec;
Var_aux(s_ind_2) = Var_vec;
end

if number_of_frames > 1;
z{f_ind} = z_aux;
Var_loc{f_ind} = Var_aux;
else
z = z_aux;
Var_loc = Var_aux;
end;
end;
if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;    
aux_norm_vec = max(sqrt(sum(reshape(z{f_ind}, 3, length(z{f_ind})/3).^2)),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
z{f_ind} = z{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = sqrt(sum(reshape(z, 3, length(z)/3).^2)); 
z = z./max(aux_norm_vec);
end;

if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;    
aux_norm_vec = max(sqrt(sum(reshape(Var_loc{f_ind}, 3, length(Var_loc{f_ind})/3).^2)),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
Var_loc{f_ind} = Var_loc{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = sqrt(sum(reshape(Var_loc, 3, length(Var_loc)/3).^2)); 
Var_loc = Var_loc./max(aux_norm_vec);
end;

close(h);

end