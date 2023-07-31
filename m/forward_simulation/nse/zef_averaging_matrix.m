function M = zef_averaging_matrix(nodes,tetra,I)

if nargin < 3

    I = [];

end


if not(isempty(I))
    [F,~] = find(ismember(tetra,I));
    tetra = tetra(F,:);
end

M = spalloc(size(nodes,1),size(nodes,1),0);

dist_aux = zeros(size(tetra,1),4,4);

for i = 1 : 4
    for j = i + 1 : 4

        dist_aux(:,i,j) = sqrt(sum((nodes(tetra(:,i),:)-nodes(tetra(:,j),:)).^2,2));
        dist_aux(:,j,i) = dist_aux(:,i,j);

    end
end

for i = 1 : 4

    dist_aux(:,i,i) = min(dist_aux(:,i,setdiff([1 2 3 4],i)),[],3);

end

for i = 1 : 4

    for j = i : 4

        M_aux = sparse(tetra(:,i),tetra(:,j),1./dist_aux(:,i,j),size(M,1),size(M,2));

        M = M + M_aux;

        if j > i
            M = M + M_aux';
        end


    end

end

if not(isempty(I))
    M = M(I,I);
end

DM = spdiags(1./full(sum(M,2)),0,size(M,1),size(M,2));

M = DM*M;

end
