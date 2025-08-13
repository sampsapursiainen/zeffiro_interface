function [z_inverse] = ext_sL(timeSteps,P_store,L,R, number_of_frames, smoothing, sL,standardization_exponent)
h = zef_waitbar(0,1, 'Filtering');
z_inverse = cell(0);

L_zero=zeros(size(L,1),size(L,2));

L2=cell2mat({L,L_zero});
L3=cell2mat({L,L_zero,L_zero});

I1=eye(size(L,2),size(L,2)*sL);


for f_ind = 1: number_of_frames
    zef_waitbar(f_ind,number_of_frames,h,...
        ['Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    m = timeSteps{f_ind};
    P = P_store{f_ind};

    if sL==1
        P_sqrtm = sqrtm(P(1:size(L,2)*1,1:size(L,2)*1));
        B = L * P_sqrtm;
    elseif sL==2
        P_sqrtm = sqrtm(P(1:size(L,2)*2,1:size(L,2)*2));
        B = L2 * P_sqrtm;
    else
        P_sqrtm = sqrtm(P);
        B = L3 * P_sqrtm;
    end
    G = B' / (B * B' + R);
    w_t = 1 ./ (sum(G.' .* B, 1)').^standardization_exponent;
    D = w_t .* inv(P_sqrtm);
    
    
    x_hat=I1*D*m;
    
    z_inverse{f_ind} = gather(x_hat);
end
close(h);
end