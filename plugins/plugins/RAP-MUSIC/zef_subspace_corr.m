function [S_C,orj] = zef_subspace_corr(A,B,chararcter)

[U_A,S_A,V_A]=svd(A,'econ');
U_A = U_A(:,abs(diag(S_A))>0);
V_A = V_A(:,abs(diag(S_A))>0);
S_A = S_A(abs(diag(S_A))>0,abs(diag(S_A))>0);
[U_B,S_B,V_B]=svd(B,'econ');
U_B = U_B(:,abs(diag(S_B))>0);
V_B = V_B(:,abs(diag(S_B))>0);
S_B = S_B(abs(diag(S_B))>0,abs(diag(S_B))>0);

C = U_A'*U_B;
[U_C,S_C,V_C] = svd(C);

U_a = U_A*U_C;
U_b = U_B*V_C;

X = V_A*(S_A\U_C);
Y = V_B*(S_B\V_C);

orj = X(:,1)/norm(X(:,1));
S_C = diag(S_C);

if strcmp(chararcter,'max')
    S_C = max(S_C);
end

end
