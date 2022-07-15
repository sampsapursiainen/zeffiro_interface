function [neighbours,neighboursp] = SESAMEneighbours(V)
radius = 1.5 * ((max(V(:,1))-min(V(:,1))) * (max(V(:,2))-min(V(:,2))) * (max(V(:,3))-min(V(:,3)))/ size(V,1) ) ^(1/3) ;
neighbours = compute_neighbours(V, radius);
neighboursp = compute_neigh_prob(V, neighbours, radius);

end

function [ NProb] = compute_neigh_prob(V,neighbours,sigmar)
NProb = zeros(size(neighbours));
for i = 1:size(neighbours,1)  
  j = 1;  
  while j <= size(neighbours,2) && neighbours(i,j)>0    
    NProb(i,j) = exp(-norm(V(i,:) - V(neighbours(i,j),:))^2/sigmar^2);
    j=j+1;    
  end  
  NProb(i,:) = NProb(i,:)/sum(NProb(i,:));    
end
end

function neighbours = compute_neighbours(vertices, radius)

MdlKDT = KDTreeSearcher(vertices);
neighbours_aux = rangesearch(MdlKDT,vertices,radius);

max_length = 0;
for i = 1 : length(neighbours_aux)

    max_length = max(length(neighbours_aux{i}),max_length);
    
end

neighbours = zeros(length(neighbours_aux),max_length);

for i = 1 : length(neighbours_aux)
    
    length_aux = length(neighbours_aux{i});
    neighbours(i,1:length_aux) = neighbours_aux{i}; 

end
    
end