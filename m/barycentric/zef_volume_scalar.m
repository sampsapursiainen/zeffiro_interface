function M = zef_volume_scalar(nodes, tetra, scalar_field, weighting, basis)

N = size(nodes,1);
K = size(tetra,1);

if nargin < 4
weighting = 1;    
end

if nargin < 5
basis = [{'linear'} {'linear'}];
end

if nargin < 3
scalar_field = ones(size(tetra,1),1);
end

if length(weighting)==1
weight_param = weighting([1 1]);
else
weight_param = weighting;
end

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

if isequal(basis{1},'linear')
D1 = N;
elseif isequal(basis{1},'constant')
D1 = K;
end

if isequal(basis{2},'linear')
D2 = N;
elseif isequal(basis{2},'constant')
D2 = K;
end

M = spalloc(D1,D2,0);

for i = 1 : 4
    for j = i : 4
        
        if i == j
        entry_vec = volume*weight_param(1);
        else
        entry_vec = volume*weight_param(2);
        end
        
        if isequal(basis{1},'linear')
        
        M_part =  sparse(tetra(:,i),tetra(:,j),scalar_field.*entry_vec,N,N);
        
        end
        
        if i == j
        M = M + M_part;
        else
        M = M + M_part;
        M = M + M_part';
        end
        
    end
end

end