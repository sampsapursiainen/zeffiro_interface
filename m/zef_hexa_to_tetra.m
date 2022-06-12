function [tetra,labels_tetra] = zef_hexa_to_tetra(hexa,varargin)

labels_hexa = [];
h = waitbar(0,'Mesh conversion.');
if not(isempty(varargin))
    labels_hexa = varargin{1};
end

n_cubes = size(hexa,1);

ind_mat_1 = [     3     4     1     7 ;
                  2     3     1     7 ;
                  1     2     7     6 ;
                  7     1     6     5 ;
                  7     4     1     8 ;
                  7     8     1     5  ];

tetra = zeros(6*n_cubes,4);
if not(isempty(labels_hexa))
labels_tetra = zeros(6*n_cubes,1);
end

for i = 1 : n_cubes
    
if mod(i,ceil(n_cubes/100))==0
waitbar(i/n_cubes,h,'Mesh conversion.');
    end

tetra(6*(i-1)+1:6*i,:) = reshape(hexa(i,ind_mat_1),6,4);
if not(isempty(labels_hexa))
labels_tetra(6*(i-1)+1:6*i) = labels_hexa(i)*ones(6,1);
end
i = i + 6;

end

close(h)

end
