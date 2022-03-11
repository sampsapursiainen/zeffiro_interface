function [X, Y, Z, pml_ind] = zef_pml_mesh(inner_radius,outer_radius,lattice_size,max_size)

growth_param = 1 + 1e-15;

convergence_value = Inf;

while convergence_value > 1e-5

extra_layers = round(log(((outer_radius-inner_radius)*(growth_param - 1))/(lattice_size*growth_param) + 1)/log(growth_param));

growth_param_new = exp(log(max_size/lattice_size)/extra_layers);

convergence_value = abs(max_size - lattice_size*growth_param^extra_layers)/max_size;

growth_param = growth_param_new;

end

extra_layers = round(log(((outer_radius-inner_radius)*(growth_param - 1))/(lattice_size*growth_param) + 1)/log(growth_param));

intermediate_radius = extra_layers*lattice_size + inner_radius;

[X,Y,Z] = meshgrid([-intermediate_radius:2*intermediate_radius/(round(2*intermediate_radius/lattice_size)):intermediate_radius]);

I_X = find(abs(X) > inner_radius);
I_Y = find(abs(Y) > inner_radius);
I_Z = find(abs(Z) > inner_radius);
pml_ind = unique([I_X(:); I_Y(:) ; I_Z(:)]);

R_aux = max(abs([X(pml_ind) Y(pml_ind) Z(pml_ind)]),[],2);
N = round((R_aux - inner_radius)/lattice_size);

X_inner = inner_radius.*X(pml_ind)./R_aux;
Y_inner = inner_radius.*Y(pml_ind)./R_aux;
Z_inner = inner_radius.*Z(pml_ind)./R_aux;

R_new = inner_radius + lattice_size.*growth_param*(1-growth_param.^N)./(1-growth_param);
R_old = inner_radius + N*lattice_size;

X(pml_ind) = R_new.*X(pml_ind)./R_old;
Y(pml_ind) = R_new.*Y(pml_ind)./R_old;
Z(pml_ind) = R_new.*Z(pml_ind)./R_old;

s = max(abs([X(:) ; Y(:); Z(:)]));
X = outer_radius*X/s;
Y = outer_radius*Y/s;
Z = outer_radius*Z/s;

%figure(1); clf;
%scatter3(X(:),Y(:),Z(:));
%axis equal

end
