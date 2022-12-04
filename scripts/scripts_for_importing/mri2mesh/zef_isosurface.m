function [nodes, triangles] = zef_isosurface(V,iso_val,smooth_val,triangle_count,X,Y,Z)

if nargin < 2
iso_val = 0.5;
end

if nargin < 3
smooth_val = 5; 
end

if nargin < 4
triangle_count = Inf;
end

conn_comp = bwconncomp(V,6);
numPixels = cellfun(@numel,conn_comp.PixelIdxList);
[biggest,idx] = max(numPixels);
V = zeros(size(V));
V(conn_comp.PixelIdxList{idx}) = 1;
V = smooth3(V,'box',smooth_val);


if nargin < 5
X = 0 : size(V,2)+1;
Y = 0 : size(V,1)+1;
Z = 0 : size(V,3)+1;
V_aux = zeros(size(V,1)+2,size(V,2)+2,size(V,3)+2);
V_aux(2:end-1,2:end-1,2:end-1) = V;
V = V_aux;
clear V_aux;
end

[triangles, nodes] = isosurface(X,Y,Z,V,iso_val);

if triangle_count < Inf

p.faces = triangles; 
p.vertices = nodes; 

p = reducepatch(p,triangle_count);

triangles = p.faces;
nodes = p.vertices;

end


end
