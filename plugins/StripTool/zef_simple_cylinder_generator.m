function [T, P] = zef_simple_cylinder_generator(R,N,L)

d_r = 2*pi*R/N;
M = ceil(R/d_r);
d_r_aux = R/M;
K = ceil(L/d_r);
P = [];

Z_aux = linspace(-L/2,L/2,K)';

for i = 1 : M

R_aux = i*d_r_aux;
S = ceil(2*pi*R_aux/d_r);
t = linspace(0,2*pi,S+1);
X = R_aux*cos(t(1:end-1));
Y = R_aux*sin(t(1:end-1));

if i == 1
X = [ 0 X ];
Y = [ 0 Y];
end

X = repmat(X,K,1);
Y = repmat(Y,K,1);

if i == 1
Z = repmat(Z_aux,1,S+1);
else
Z = repmat(Z_aux,1,S);
end

P = [P ; [X(:), Y(:), Z(:)]];

end

T = delaunay(P);
TR = triangulation(T,P);
T = freeBoundary(TR);

P_aux = zeros(size(P,1),1);
[U,I] = unique(T);
P_aux(U) = [1:length(U)]';
P = P(U,:);
T = P_aux(T);
T = T(:,[1 2 3]);

end