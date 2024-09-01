function atlas_surfaces = zef_bst_get_atlas_surfaces(zef,atlas_struct,n_inflation_steps,transform_cell,compartment_type)

if nargin < 4
transform_cell = cell(0);
end

if nargin < 5
compartment_type = '';
end


atlas_surfaces = struct;

[X, Y, Z] = meshgrid([0:size(atlas_struct.Cube,1)],[0:size(atlas_struct.Cube,2)],[0:size(atlas_struct.Cube,3)]);
cube_labels = atlas_struct.Cube(:);
n_cubes = prod(size(X)-1);

size_xyz = size(X);

h_waitbar = zef_waitbar(0,['Atlas labels for ' atlas_struct.Comment '.']);

    ind_mat_1{1}{2}{1} = [2 5 6 7; 7 5 4 2; 2 3 4 7; 1 2 4 5 ; 4 7 8 5];
    ind_mat_1{1}{2}{2} = [6 2 1 3; 1 3 8 6; 8 7 6 3;  5 8 6 1; 3 8 4 1 ];
    ind_mat_1{2}{2}{2} = [5 2 1 4; 4 2 7 5; 5 8 7 4;  5 7 6 2;  3 7 4 2];
    ind_mat_1{2}{2}{1} = [1 5 6 8; 6 8 3 1; 3 4 1 8; 2 3 1 6 ; 3 7 8 6  ];
    ind_mat_1{1}{1}{2} = [4 3 7 2; 2 7 4 5; 5 7 6 2; 1 5 2 4;  8 7 5 4 ];
    ind_mat_1{2}{1}{2} = [3 6 8 1; 1 3 4 8; 5 8 6 1; 1 6 2 3 ; 8 7 6 3  ];
    ind_mat_1{1}{1}{1} = [7 8 3 6; 8 1 3 6; 2 3 1 6;  1 5 6 8 ; 1 3 4 8   ];
    ind_mat_1{2}{1}{1} = [7 8 4 5; 5 4 7 2; 2 4 1 5; 2 5 6 7 ;  2 3 4 7 ];
    tetra = zeros(5*n_cubes,4);
    cube_labels = zeros(5*n_cubes,1);

    nodes = [X(:) Y(:) Z(:)] + 0.5;
    i = 1;

    for i_x = 1 : size(X,2) - 1

zef_waitbar(i_x/size(X,2),h_waitbar,['Atlas labels for ' atlas_struct.Comment '.']);  

        for i_y = 1 : size(X,1) - 1
            for i_z = 1 : size(X,3) - 1

                x_ind = [i_x   i_x+1  i_x+1  i_x    i_x    i_x+1  i_x+1  i_x]';
                y_ind = [i_y   i_y    i_y+1  i_y+1  i_y    i_y    i_y+1  i_y+1]';
                z_ind = [i_z   i_z    i_z    i_z    i_z+1  i_z+1  i_z+1  i_z+1]';
                ind_mat_2 = sub2ind(size_xyz,y_ind,x_ind,z_ind);

                tetra(i:i+4,:) = ind_mat_2(ind_mat_1{2-mod(i_x,2)}{2-mod(i_y,2)}{2-mod(i_z,2)});
                cube_labels(i:i+4) = atlas_struct.Cube(i_x,i_y,i_z);
                i = i + 5;

            end
        end
    end

    surface_ind = 0;
    for i = 1 : size(atlas_struct.Labels,1)
 
     label_val = atlas_struct.Labels{i,1};
     if label_val > 0
     surface_ind = surface_ind + 1; 
     I = find(cube_labels == label_val);
     [triangles_aux, nodes_aux] = zef_surface_mesh(tetra(I,:),nodes);
     [nodes_aux] = zef_inflate_surface(zef,nodes_aux,triangles_aux,n_inflation_steps);
     atlas_surfaces(surface_ind).Name = atlas_struct.Labels{i,2};
      atlas_surfaces(surface_ind).Type = compartment_type;
     atlas_surfaces(surface_ind).Color = atlas_struct.Labels{i,3}/255;
     if ismember('InitTransf',transform_cell)
     if not(isempty(atlas_struct.InitTransf))
     A = atlas_struct.InitTransf{2}; 
     nodes_aux = (A*[nodes_aux' ; ones(1,size(nodes_aux,1))])';
     end
     end
     atlas_surfaces(surface_ind).Points = nodes_aux(:,1:3);
     atlas_surfaces(surface_ind).Triangles = triangles_aux(:,[1 3 2]);
     end
 
    end

    close(h_waitbar);

end
