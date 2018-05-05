%Copyright © 2018, Sampsa Pursiainen
function [nodes,tetrahedra,sigma,brain_ind,surface_triangles] = zef_import(void)

if not(isempty(evalin('base','zef.save_file_path'))) & not(evalin('base','zef.save_file_path')==0)  
[file file_path] = uigetfile('*.mat','Import volume data',evalin('base','zef.save_file_path'));
else
[file file_path] = uigetfile('*.mat','Import volume data');   
end
surface_triangles = [];
nodes = [];
tetrahedra = [];
sigma = [];
brain_ind = [];
if not(isequal(file,0));
load([file_path file]);
surface_triangles = 1;

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ];


tetra_sort = [tetrahedra(:,[2 4 3]) ones(size(tetrahedra,1),1) [1:size(tetrahedra,1)]'; 
              tetrahedra(:,[1 3 4]) 2*ones(size(tetrahedra,1),1) [1:size(tetrahedra,1)]'; 
              tetrahedra(:,[1 4 2]) 3*ones(size(tetrahedra,1),1) [1:size(tetrahedra,1)]'; 
              tetrahedra(:,[1 2 3]) 4*ones(size(tetrahedra,1),1) [1:size(tetrahedra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetrahedra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles = tetrahedra(tetra_ind);
% trep = TriRep(zef.tetrahedra, zef.nodes);
% surface_triangles = freeBoundary(trep);
% clear trep;
end