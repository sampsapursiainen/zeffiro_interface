
zef.h = waitbar(0,'Downsampling surfaces.');
zef.temp_time = now;
number_of_compartments = 27;
for zef_k = 1 : number_of_compartments
switch zef_k
    case 1
        zef.temp_var_0 = 'd1';
     case 2
        zef.temp_var_0 = 'd2';
     case 3
        zef.temp_var_0 = 'd3';
     case 4
        zef.temp_var_0 = 'd4';
     case 5
        zef.temp_var_0 = 'd5';
     case 6
        zef.temp_var_0 = 'd6';
     case 7
        zef.temp_var_0 = 'd7';
     case 8
        zef.temp_var_0 = 'd8';
    case 9
        zef.temp_var_0 = 'd9';
     case 10
        zef.temp_var_0 = 'd10';
     case 11
        zef.temp_var_0 = 'd11';
     case 12
        zef.temp_var_0 = 'd12';
     case 13
        zef.temp_var_0 = 'd13';
  case 14
        zef.temp_var_0 = 'd14';
  case 15
        zef.temp_var_0 = 'd15';
     case 16
        zef.temp_var_0 = 'd16';
     case 17
        zef.temp_var_0 = 'd17';
    case 18
        zef.temp_var_0 = 'd18';
     case 19
        zef.temp_var_0 = 'd19';
     case 20
        zef.temp_var_0 = 'd20';
     case 21
        zef.temp_var_0 = 'd21';
     case 22
        zef.temp_var_0 = 'd22';
    case 23
        zef.temp_var_0 = 'w';
    case 24
        zef.temp_var_0 = 'g';
    case 25
        zef.temp_var_0 = 'c';
     case 26
        zef.temp_var_0 = 'sk';
     case 27
        zef.temp_var_0 = 'sc';
end    

if evalin('base',['zef.' zef.temp_var_0 '_on']) 
if evalin('base',['isfield(zef,"' zef.temp_var_0 '_points_original_surface_mesh")'])
if evalin('base',['not(isempty(zef.' zef.temp_var_0 '_points_original_surface_mesh))'])
    zef.temp_patch_data.vertices_all = evalin('base',['zef.' zef.temp_var_0 '_points_original_surface_mesh;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles_original_surface_mesh;']);
        zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh;']);
else
    zef.temp_patch_data.vertices_all = evalin('base',['zef.' zef.temp_var_0 '_points;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles;']);
    zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind;']);   
    evalin('base',['zef.' zef.temp_var_0 '_points_original_surface_mesh = zef.' zef.temp_var_0 '_points;']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles_original_surface_mesh = zef.' zef.temp_var_0 '_triangles;']);
    evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh = zef.' zef.temp_var_0 '_submesh_ind;']);
end
else 
   zef.temp_patch_data.vertices_all = evalin('base',['zef.' zef.temp_var_0 '_points;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles;']);
        zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind;']);
    evalin('base',['zef.' zef.temp_var_0 '_points_original_surface_mesh = zef.' zef.temp_var_0 '_points;']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles_original_surface_mesh = zef.' zef.temp_var_0 '_triangles;']);    
evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original_surface_mesh = zef.' zef.temp_var_0 '_submesh_ind;']);

end

evalin('base',['zef.' zef.temp_var_0 '_points_inf = [];']);
evalin('base',['zef.' zef.temp_var_0 '_points = [];']);
evalin('base',['zef.' zef.temp_var_0 '_triangles = [];']);


if evalin('base',['not(isempty(zef.' zef.temp_var_0 '_submesh_ind));'])
    zef_i = 0;
    for zef_j = 1 : length(zef.temp_patch_data.submesh_ind)
     zef_i = zef_i + 1;
     zef.temp_patch_data.faces = zef.temp_patch_data.faces_all(zef_i : zef.temp_patch_data.submesh_ind(zef_j),:);
     zef.temp_patch_data.vertice_ind_aux = zeros(size(zef.temp_patch_data.vertices_all,1),1);
     zef.temp_patch_data.unique_faces_ind = unique(zef.temp_patch_data.faces);
     zef.temp_patch_data.vertice_ind_aux(zef.temp_patch_data.unique_faces_ind) = [1:length(zef.temp_patch_data.unique_faces_ind)];
     zef.temp_patch_data.faces = zef.temp_patch_data.vertice_ind_aux(zef.temp_patch_data.faces);
      zef.temp_patch_data.vertices = zef.temp_patch_data.vertices_all(zef.temp_patch_data.unique_faces_ind,:);
      zef.temp_patch_data_aux = reducepatch(zef.temp_patch_data,min(1,zef.max_surface_face_count/size(zef.temp_patch_data.faces,1)));
     if evalin('base',['zef.' zef.temp_var_0 '_sources'])
     [zef.temp_patch_data_aux.vertices_inflated] = inflate_surface(zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces);
       evalin('base',['zef.' zef.temp_var_0 '_points_inf = [zef.' zef.temp_var_0 '_points_inf ;  zef.temp_patch_data_aux.vertices_inflated];']);
    end
     evalin('base',['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces+size(zef.' zef.temp_var_0 '_points,1)];']);
    evalin('base',['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
    zef_i = zef.temp_patch_data.submesh_ind(zef_j);
    evalin('base',['zef.' zef.temp_var_0 '_submesh_ind(' int2str(zef_j) ') = size(zef.' zef.temp_var_0 '_triangles,1);']);
    end
else 
   zef.temp_patch_data.faces = zef.temp_patch_data.faces_all;
   zef.temp_patch_data.faces = zef.temp_patch_data.vertices_all;
     zef.temp_patch_data_aux = reducepatch(zef.temp_patch_data,min(1,zef.max_surface_face_count/size(zef.temp_patch_data.faces,1)));
        if evalin('base',['zef.' zef.temp_var_0 '_sources'])
     zef.temp_patch_data_aux.vertices_inflated = inflate_surface(zef.temp_patch_data_aux.vertices,zef.temp_patch_data_aux.faces);
   evalin('base',['zef.' zef.temp_var_0 '_points_inf = [zef.' zef.temp_var_0 '_points_inf ;  zef.temp_patch_data_aux.vertices_inflated];']);
        end
     evalin('base',['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces];']);
end
end

waitbar(zef_k/number_of_compartments,zef.h,['Downsampling surfaces. Ready approx.: ' datestr(now + (number_of_compartments-zef_k)*(now-zef.temp_time)/zef_k) '.'] );
end
close(zef.h);
zef = rmfield(zef,'temp_patch_data');
zef = rmfield(zef,'temp_patch_data_aux');
zef = rmfield(zef,'temp_var_0');
zef = rmfield(zef,'temp_time');
clear zef_i zef_j zef_k