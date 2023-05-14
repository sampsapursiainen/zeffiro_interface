function x = zef_KDMD(x,K,M,D,use_gpu)

if use_gpu 
    x = gpuArray(x);
    K = gpuArray(K);
    M = gpuArray(M);
    D = gpuArray(D);
end

y = D*x; 
y = M*y;
y = D*y;
x = K*x + y;  

end