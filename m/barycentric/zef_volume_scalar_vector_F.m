function v = zef_volume_scalar_vector_F(nodes, tetra, scalar_field)
%
% zef_volume_scalar_vector_F
%
% TODO: Sampsa should document this.
%
% Inputs:
%
% - nodes
%
%   TODO: explanation.
%
% - tetra
%
%   TODO: explanation.
%
% - scalar_field
%
%   TODO: explanation.
%
% Outputs:
%
% - v
%
%   TODO: explanation.
%

N = size(nodes,1);

if nargin < 3
scalar_field = ones(size(tetra,1),1);
end

weight_param = 1/4;

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

v = zeros(N,1);

for i = 1 : 4

        v_part = sparse(tetra(:,i),ones(size(tetra,1),1),weight_param.*scalar_field.*volume,N,1);
        v = v + full(v_part);

end

end
