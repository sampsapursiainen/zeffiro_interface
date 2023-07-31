function zef = zef_merge_surface_mesh(zef,compartment_tag,triangles,points,varargin)

if isempty(zef)
    zef = evalin('base','zef',zef);
end

if not(isempty(varargin))
    merge = varargin{1};
else
    merge = eval(['zef.' compartment_tag '_merge;']);
end

triangles_0 = eval(['zef.' compartment_tag '_triangles;']);
points_0 = eval(['zef.' compartment_tag '_points;']);
submesh_ind_0 = eval(['zef.' compartment_tag '_submesh_ind;']);

if merge

    [points,~,ind_aux] = unique([points_0 ; points],'rows');
    triangles = ind_aux([triangles_0; triangles + size(points_0,1)]);
    submesh_ind = [submesh_ind_0 size(triangles,1)];

else

    submesh_ind = [size(triangles,1)];

end

eval(['zef.' compartment_tag '_points = points;']);
eval(['zef.' compartment_tag '_triangles = triangles;']);
eval(['zef.' compartment_tag '_submesh_ind = submesh_ind;']);

if nargout == 0
    assign('base','zef',zef);
end

end
