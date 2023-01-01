function [ ...
    surface_triangles, ...
    surface_nodes, ...
    tetra_ind, ...
    tetra_ind_global, ...
    tetra_ind_diff, ...
    node_ind, ...
    node_pair, ...
face_ind] = zef_surface_mesh(tetra, nodes, I, gpu_mode)

    % TODO Documentation
    %
    % The basic idea is that this function returns the surface triangles of a
    % given tetrahedral volume in different formats, depending on the
    % combination of input and output arguments.
    %
    % Input:
    %
    % - tetra: the set of volume tetrahedra whose surface is to be constructed (?)
    %
    % - varargin{1}: the nodes that constitute the tetrahedra (?)
    %
    % - varargin{2}: the indices that denote which tetrahedra are to be chosen
    %   as a part of the volume from the given ones (?)
    %
    % Output:
    %
    % - surface_triangles: Triples of node indices that make up the surface
    %   triangles
    %
    % - surface_nodes: the nodes that constitute the surface triangles.
    %
    % - tetra_ind: the indices of the tetrahedra that have the surface
    %   triangles as a face.
    %
    % - tetra_ind_global: TODO
    %
    % - tetra_ind_diff: TODO
    %
    % - node_ind: TODO
    %
    % - node_pair: TODO: pairs of neigbouring nodes on different sides of the
    %   triangular surface.

    surface_triangles = [];
    surface_nodes = [];
    tetra_ind = [];
    tetra_ind_global = [];
    tetra_ind_diff = [];
    node_ind = [];
    node_pair = [];
    face_ind = [];

tetra = uint32(tetra);


% Get nodes and indices from varargin.

if nargin < 2 
nodes = []; 
end 

if nargin < 3
 I = []; 
end 

if nargin < 4
gpu_mode = 'graphics';
end

use_gpu = 0;
if evalin('caller', 'exist(''zef'', ''var'' )')
zef = evalin('caller', 'zef');
if zef.gpu_count > 0
if isequal(gpu_mode,'normal')
use_gpu = zef.use_gpu;
elseif isequal(gpu_mode,'graphics')
if zef.use_gpu
use_gpu = zef.use_gpu_graphic;
end
end
end
end


if not(isempty(I))
    I_global = [1 : size(tetra,1)]';
    if nargout > 4
        I_diff = setdiff(I_global,I);
        tetra_diff = tetra(I_diff,:);
    end
    tetra = tetra(I,:);
    I_global = I_global(I);
end

% Tetra faces (node index triples) opposite to row index node.

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

% Find tetra indices I that share a face, by sorting and subtracting.

tetra_sort_1 = uint32([
    tetra(:,[2 4 3]);
    tetra(:,[1 3 4]);
    tetra(:,[1 4 2]);
    tetra(:,[1 2 3]);
]);

tetra_sort_2 = uint32([
     1*ones(size(tetra,1),1) [1:size(tetra,1)]';
     2*ones(size(tetra,1),1) [1:size(tetra,1)]';
     3*ones(size(tetra,1),1) [1:size(tetra,1)]';
     4*ones(size(tetra,1),1) [1:size(tetra,1)]';
]);

if use_gpu
tetra_sort_1 = gpuArray(tetra_sort_1);
end
tetra_sort_1 = sort(tetra_sort_1,2);
[tetra_sort_1,J] = sortrows(tetra_sort_1,[1 2 3]);

tetra_ind = zeros(size(tetra_sort_1,1),1);

I = find(sum(abs(tetra_sort_1(2:end,1:3)-tetra_sort_1(1:end-1,1:3)),2)==0);
clear tetra_sort_1;
tetra_sort_2 = tetra_sort_2(J,:);

tetra_ind(I) = 1;
tetra_ind(I+1) = 1;

I = find(tetra_ind == 0);

tetra_ind = sub2ind(size(tetra),repmat(tetra_sort_2(I,2),1,3),ind_m(tetra_sort_2(I,1),:));
surface_triangles = tetra(tetra_ind);
surface_triangles = uint32(surface_triangles(:,[1 3 2]));

tetra_ind = tetra_sort_2(I,2);
face_ind = tetra_sort_2(I,1);

if and(nargout > 4, nargin > 1)
    surface_triangles_aux = surface_triangles;
end

if not(isempty(nodes))
if  use_gpu 
surface_triangles = gpuArray(surface_triangles);
end
    [u_val, ~, u_ind] = unique(surface_triangles);
surface_triangles = gather(surface_triangles);
 
 surface_nodes = nodes(u_val,:);
    surface_triangles = reshape(u_ind,size(surface_triangles));
end

if and(nargout > 3, nargin > 1)
    tetra_ind_global = I_global(tetra_ind);
end

if nargout > 4
    tetra_ind_diff = [];
end

if and(nargout > 4, nargin > 2)



if use_gpu
surface_triangles_aux = gpuArray(surface_triangles_aux);
end

    surface_triangles_aux = sort(surface_triangles_aux,2);
    
    if use_gpu
    aux_vec_1 = gpuArray(tetra_diff(:,[2 4 3]));
    else
    aux_vec_1 = tetra_diff(:,[2 4 3]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
   if use_gpu
    aux_vec_2 = gpuArray(aux_vec_2);
   end
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, triangle_ind_diff, tetra_ind_diff] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2; 
    tetra_ind_diff = gather(I_aux(tetra_ind_diff));
    triangle_ind_diff = gather(triangle_ind_diff);

    if use_gpu
    aux_vec_1 = gpuArray(tetra_diff(:,[1 3 4]));
    else
    aux_vec_1 = tetra_diff(:,[1 3 4]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

    if use_gpu
    aux_vec_1 = gpuArray(tetra_diff(:,[1 4 2]));
    else
    aux_vec_1 = tetra_diff(:,[1 4 2]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

    if use_gpu
    aux_vec_1 = gpuArray(tetra_diff(:,[1 2 3]));
    else
    aux_vec_1 = tetra_diff(:,[1 2 3]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [I_aux, ~] = unique(ind2sub(size(aux_vec_2), I_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

clear surface_triangles_aux

    if and(nargout > 5, nargin > 2)

        node_ind = zeros(size(tetra_ind_diff,1),1);
        tetra_aux = tetra_diff(tetra_ind_diff,:);

        if use_gpu
        tetra_aux = gpuArray(tetra_aux);
        surface_triangles = gpuArray(surface_triangles);
        end

        [I,J] = find(not(ismember(tetra_aux,surface_triangles)));
        
        if use_gpu 
        tetra_aux = gather(tetra_aux);
        surface_triangles = gather(surface_triangles);
        end 
  
        I_aux_2 = sub2ind(size(tetra_aux), I, J);
        node_ind(I) = tetra_aux(I_aux_2);
        node_pair = [surface_triangles(triangle_ind_diff,1) node_ind; ...
                    surface_triangles(triangle_ind_diff,2) node_ind; ...
                    surface_triangles(triangle_ind_diff,3) node_ind];
                
        node_pair = node_pair(find(node_pair(:,2)),:);
                
        [~, I_aux_1] = unique(node_pair(:,1));
        node_pair = node_pair(I_aux_1,:);

    end % if

    tetra_ind_diff = I_diff(tetra_ind_diff);

end % if

end % function