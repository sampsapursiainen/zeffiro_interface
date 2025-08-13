function [P_store, z_inverse] = triple_kf_sL(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing, sL,standardization_exponent,burn_in)
P_store = cell(0);
z_inverse = cell(0);
h = zef_waitbar(0,1, 'Filtering');

zero_m=zeros(size(A,1));

A=cell2mat({A,(1/number_of_frames)*A,(1/2)*((1/number_of_frames)^2)*A;zero_m,A,(1/number_of_frames)*A;zero_m,zero_m,A});
P=cell2mat({P,zero_m,zero_m;zero_m,P,zero_m;zero_m,zero_m,P});
Q=cell2mat({zero_m,zero_m,zero_m;zero_m,zero_m,zero_m;zero_m,zero_m,(1/((1/2)*((1/number_of_frames)^2)))*Q});
L2=cell2mat({L,zeros(size(L,1),size(L,2)*(sL-1))});
L3=cell2mat({L,zeros(size(L,1),size(L,2)*2)});

I1=eye(size(L,2)*max(sL,smoothing-1),size(L,2)*3);
if smoothing>1
    I2=eye(size(L,2)*min(sL,smoothing-1),size(L,2)*max(sL,smoothing-1));
else
    I2=eye(size(L,2),size(L,2)*sL);
end
m=cell2mat({m;m;m});

zero=zeros(size(R,1),1);


for i =1:burn_in
    [m,P] = kf_predict(m,P, A, Q);
    [m, P, ~] = kf_update(m, P, zero, L3, R);
end

for f_ind = 1: number_of_frames
    zef_waitbar(f_ind,number_of_frames,h,...
        ['Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    f = timeSteps{f_ind};
    
    % Prediction
    [m,P] = kf_predict(m, P, A, Q);
    
    %sLORETA
    
    if sL+1>=smoothing
        P_sqrtm = sqrtm(P(1:size(L,2)*sL,1:size(L,2)*sL));
        B = L2 * P_sqrtm;
        G = B' / (B * B' + R);
        w_t = 1 ./ (sum(G.' .* B, 1)').^standardization_exponent;
        D = w_t .* inv(P_sqrtm);
    end
    
    %update
    [m, P, ~] = kf_update(m, P, f, L3, R);
    
    if sL+1>=smoothing
        x_hat=I2*D*I1*m;
    else
        x_hat=I1*m;
    end
    
    z_inverse{f_ind} = gather(x_hat);
    if (smoothing > 1)
        P_store{f_ind} = gather(P(1:size(L,2)*(smoothing-1),1:size(L,2)*(smoothing-1)));
    end
end
close(h);
end