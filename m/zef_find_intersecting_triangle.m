function [tri_ind, lambda_1, lambda_2, lambda_3] = zef_find_intersecting_triangle(p_1, p_2,sign_val,tri_ref,nodes_tri_ref,varargin)

search_type = 'convex';

if not(isempty(varargin))
    search_type = varargin{1};
end

tri_ind = [];
lambda_1 = [];
lambda_2 = [];
lambda_3 = [];

vec_1_aux = p_2 - p_1;
ones_vec_tri = ones(size(tri_ref,1),1);
vec_1 = vec_1_aux(ones_vec_tri,:);
d_vec = p_1(ones_vec_tri,:)  - nodes_tri_ref(tri_ref(:,1),:);
vec_2 = nodes_tri_ref(tri_ref(:,2),:) - nodes_tri_ref(tri_ref(:,1),:);
vec_3 = nodes_tri_ref(tri_ref(:,3),:) - nodes_tri_ref(tri_ref(:,1),:);

sign_vec = sign(dot(cross(vec_2',vec_3'),vec_1'));

[lambda_1, lambda_2, lambda_3] = zef_3by3_solver(vec_1, vec_2, vec_3, d_vec);
if isequal(search_type,'convex')
I = find(sign_val*sign_vec(:) >= 0 &lambda_1<0 & lambda_1 > -1 & lambda_2 >0 & lambda_2<1 & lambda_3>0 & lambda_3 <1);
elseif isequal(search_type,'nonconvex')
I = find(sign_val*sign_vec(:) >= 0  & lambda_2 >0 & lambda_2<1 & lambda_3>0 & lambda_3 <1);
end

if not(isempty(I))
[~, min_ind] = min(abs(lambda_1(I)));

tri_ind = I(min_ind);
lambda_1 = lambda_1(tri_ind);
lambda_2 = lambda_2(tri_ind);
lambda_3 = lambda_3(tri_ind);

else
   tri_ind = [];
lambda_1 = [];
lambda_2 = [];
lambda_3 = [];

end

end