function x = zef_l2_l1_optimizer(L, y, reg_param, options)

H = [ L'*L zeros(size(L,2), size(L,2)) ; zeros(size(L,2), 2*size(L,2)) ];
f = [ - L'*y ; reg_param ];

A = [ eye(size(L,2)) -eye(size(L,2)); -eye(size(L,2)) eye(size(L,2)); zeros(size(L,2)) -eye(size(L,2))];
b = [ zeros(3*size(L,2),1) ];

x = quadprog(H, f, A, b, [], [], [], [], [], options);
x = x(1:size(L,2));

end