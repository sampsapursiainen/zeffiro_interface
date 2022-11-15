function x = zef_QinvMQ(x,Q_1,Q_2,Q_3,M,tol,maxit,DM,use_gpu)

if use_gpu 
    x = gpuArray(x);
    Q_1 = gpuArray(Q_1);
    Q_2 = gpuArray(Q_2);
    Q_3 = gpuArray(Q_3);
    M = gpuArray(M);
    DM = gpuArray(DM);
end

x_1 = Q_1*x;
x_2 = Q_2*x;
x_3 = Q_3*x;

if use_gpu
[x_1] = pcg_iteration_gpu(M,x_1,tol,maxit,DM,x_1);
else
[x_1] = pcg_iteration(M,x_1,tol,maxit,DM,x_1);
end

if use_gpu 
[x_2] = pcg_iteration_gpu(M,x_2,tol,maxit,DM,x_2);
else
[x_2] = pcg_iteration(M,x_2,tol,maxit,DM,x_2);    
end

if use_gpu
[x_3] = pcg_iteration_gpu(M,x_3,tol,maxit,DM,x_3);
else
[x_3] = pcg_iteration(M,x_3,tol,maxit,DM,x_3);    
end

x_1 = Q_1*x_1;
x_2 = Q_2*x_2;
x_3 = Q_3*x_3;

x = x_1 + x_2 + x_3;

end