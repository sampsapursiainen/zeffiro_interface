function sensors_attached_volume = zef_pem2cem(sensors_attached_volume,tetra);

    n_electrodes = max(sensors_attached_volume(:,1),[],1);
    sensors_aux = [];
    
    for i = 1 : n_electrodes
    
    ele_ind_aux = find(sensors_attached_volume(:,1)==i);
    [I, ~] = find(sensors_attached_volume(ele_ind_aux,:)==0);
    
    if isempty(I)    
    
    sensors_aux = [sensors_aux ; sensors_attached_volume(ele_ind_aux,:)];
    
    else
        
     [J,~] = find(tetra==sensors_attached_volume(ele_ind_aux,2));
     ele_tri = zef_surface_mesh(tetra,[],J);
     
     sensors_aux = [sensors_aux ; i(ones(size(ele_tri,1),1),1) ele_tri];
   
    end    
    end
   
    sensors_attached_volume = sensors_aux;

end