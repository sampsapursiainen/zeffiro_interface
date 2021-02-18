
zef.h = waitbar(0,'Downsampling surfaces.');
zef.temp_time = now;
for zef_k = 1 : 27
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
if evalin('base',['isfield(zef,"' zef.temp_var_0 '_points_original")'])
if evalin('base',['not(isempty(zef.' zef.temp_var_0 '_points_original))'])
    zef.temp_patch_data.vertices = evalin('base',['zef.' zef.temp_var_0 '_points_original;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles_original;']);
        zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original;']);
else
    zef.temp_patch_data.vertices = evalin('base',['zef.' zef.temp_var_0 '_points;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles;']);
    zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind;']);   
    evalin('base',['zef.' zef.temp_var_0 '_points_original = zef.' zef.temp_var_0 '_points;']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles_original = zef.' zef.temp_var_0 '_triangles;']);
    evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original = zef.' zef.temp_var_0 '_submesh_ind;']);
end
else 
   zef.temp_patch_data.vertices = evalin('base',['zef.' zef.temp_var_0 '_points;']);
    zef.temp_patch_data.faces_all = evalin('base',['zef.' zef.temp_var_0 '_triangles;']);
        zef.temp_patch_data.submesh_ind = evalin('base',['zef.' zef.temp_var_0 '_submesh_ind;']);
    evalin('base',['zef.' zef.temp_var_0 '_points_original = zef.' zef.temp_var_0 '_points;']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles_original = zef.' zef.temp_var_0 '_triangles;']);    
evalin('base',['zef.' zef.temp_var_0 '_submesh_ind_original = zef.' zef.temp_var_0 '_submesh_ind;']);

end

evalin('base',['zef.' zef.temp_var_0 '_points = [];']);
evalin('base',['zef.' zef.temp_var_0 '_triangles = [];']);


if evalin('base',['not(isempty(zef.' zef.temp_var_0 '_submesh_ind));'])
    zef_i = 0;
    for zef_j = 1 : length(zef.temp_patch_data.submesh_ind)
     zef_i = zef_i + 1;
     zef.temp_patch_data.faces = zef.temp_patch_data.faces_all(zef_i : zef.temp_patch_data.submesh_ind(zef_j),:);
     zef.temp_patch_data_aux = reducepatch(zef.temp_patch_data,min(1,zef.max_surface_face_count/size(zef.temp_patch_data.faces,1)));
         evalin('base',['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces+size(zef.' zef.temp_var_0 '_points,1)];']);
    evalin('base',['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
     zef_i = zef.temp_patch_data.submesh_ind(zef_j);
    evalin('base',['zef.' zef.temp_var_0 '_submesh_ind(' int2str(zef_j) ') = size(zef.' zef.temp_var_0 '_triangles,1);']);
    end
else 
   zef.temp_patch_data.faces = zef.temp_patch_data.faces_all;
     zef.temp_patch_data_aux = reducepatch(zef.temp_patch_data,min(1,zef.max_surface_face_count/size(zef.temp_patch_data.faces,1)));
    evalin('base',['zef.' zef.temp_var_0 '_points = [zef.' zef.temp_var_0 '_points ;  zef.temp_patch_data_aux.vertices];']);
    evalin('base',['zef.' zef.temp_var_0 '_triangles = [zef.' zef.temp_var_0 '_triangles; zef.temp_patch_data_aux.faces];']);
end
end

waitbar(zef_k/27,zef.h,['Downsampling surfaces. Ready approx.: ' datestr(now + (27-zef_k)*(now-zef.temp_time)/zef_k) '.'] );
end
close(zef.h);
zef = rmfield(zef,'temp_patch_data');
zef = rmfield(zef,'temp_patch_data_aux');
zef = rmfield(zef,'temp_var_0');
zef = rmfield(zef,'temp_time');
clear zef_i zef_j zef_k