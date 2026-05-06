function [s_roi, roi_specs] = zef_ROI_finder(source_positions, roi_specs)
%beware: this function only moves s_p to the nearest source point if
%the roi is completely empty, therefore if the roi is not empty, there is
%not necessarily a source at the exact center

s_p = roi_specs.roi_center;
radius = roi_specs.radius;
source_vectors = source_positions - repmat(s_p,size(source_positions,1),1);


if roi_specs.shape == 2 %spherical
    
    d = sqrt(sum((source_positions - repmat(s_p,size(source_positions,1),1)).^2,2));
    
    %find sources within radius around center
    s_roi = find(d<=radius); 

else
    
    % for flat/ellipsoid rois first determine orientation 
    
    if roi_specs.oriType ==  1 %custom input orientation
            ori = roi_specs.ori; 
           
    else
        
        %find source index in source space
        s_ind = dsearchn(source_positions, s_p);
        
        if roi_specs.oriType == 4 % cortex normal orientation

               
        ori = zef_get_normal_ori(roi_specs.procFile,roi_specs.ori,s_ind);
                    
       
         
        else % do SVD for the source position
           
            if roi_specs.oriType == 2
                minmax = 'max';
            elseif roi_specs.oriType == 3
                minmax = 'min';
            end
             

            ori = zef_get_radial_orientation(s_ind,minmax,roi_specs.L,s_ind,source_positions);
                  

         end 
        
   
    end

    % end of determining source orientation
    ori = ori(:)';   % make sure is row vector
    ori = ori/norm(ori);


    patch_thickness = roi_specs.width;

    if roi_specs.shape == 3  %ellipsoid
        if roi_specs.width~=0
            axis_1 = roi_specs.radius; 
            axis_2 = roi_specs.radius; %or rather, spheroid

            axis_3 = roi_specs.width;

            
            z = ori';
        
            if isequal(abs(z),[0 0 1]')
                x = [1 0 0]';
            else
                x = 1/sqrt(z(1)^2+z(2)^2)* [z(2) -z(1) 0]';
            end
        
            y = cross(z,x);


            %rotation matrix
            T_ellipsoid_to_lab = [x y z];

            %source distances in ellipsoid coord system
            trans_d = source_vectors * inv(T_ellipsoid_to_lab');

            % find sources that fulfill ellipsoid equation
            s_roi = find(trans_d(:,1).^2/axis_1^2+trans_d(:,2).^2./axis_2^2+trans_d(:,3).^2./axis_3^2 <= 1);
            
        else %if width is 0

            %in case of an ellipsoid with zero width, make it a plane
            roi_specs.shape = 1;
            roi_specs.curvature = 0;
        end
    end


    if roi_specs.shape == 1 %plane
    

    k = roi_specs.curvature;

    if k == 0 || radius == 0 %flat disk/cylinder or technically it could be a line with length = width but that is not plotted

        %distances from center
        dis_vector = source_positions-repmat(s_p,size(source_positions,1),1);
        
        % distances in direction of width
        proj_width = (dis_vector * ori.') / (norm(ori)^2) .*ori ;

        %distances in direction of radius
        proj_r = dis_vector-proj_width;
        
        %sources within width and radius
        s_roi = find(vecnorm(proj_width,2,2)<=patch_thickness & vecnorm(proj_r,2,2)<=radius);


    else % curved disk
       
        

        %we lay the disk on on a sphere, this cap spans at most half of the sphere, 
        %so for k=1 -->  2*pi*r^2 = pi radius^2, and for k=0 --> r = inf

         r = radius/(k*sqrt(2));

         %largest possible thickness means a filled half sphere for k=1, and
         %otherwise a filled cone
         patch_thickness = min([patch_thickness,2*abs(r)]);
         
           
        %choose the center of the sphere, so that s_p is on the surface of
        %the sphere. Takes into account sign of k
        sphere_center = s_p-r*ori;
        
        %distance of points from sphere center
        radial_vector = source_positions- repmat(sphere_center,size(source_positions,1),1);
        d_r = sqrt(sum((radial_vector).^2,2));

        % find all sources around the sphere within thickness
        source_ind= find(round(abs(d_r-abs(r)),3)<=patch_thickness);
        
        % convert patch radius --> angle pi radius^2 = 2 pi r^2 *(1-cos(alpha))
        alpha_max = acosd(1 - radius^2/(2*abs(r)^2));
        
        % find all sources within that angle
        angle = acosd(radial_vector(source_ind,:)*(s_p-sphere_center)'./(abs(r)*d_r(source_ind)));
        source_ind_r = find(angle<=alpha_max);

        s_roi = source_ind(source_ind_r);

     
    end
    end


   
end
    

 if isempty(s_roi)
        %if there are no sources, first move the position
        center_ind = dsearchn(source_positions,roi_specs.roi_center);
        
        fprintf('\nNo sources found at [%s], moving to nearest source position [%s]\n',num2str(roi_specs.roi_center),num2str(source_positions(center_ind,:)));
        roi_specs.roi_center = source_positions(center_ind,:);

        %then at the very least s_roi will contain center_ind
        [s_roi, roi_specs] = zef_ROI_finder(source_positions, roi_specs);
            
 else
       
   %update the specs for further processing

   %remove unnecessary fields
   fields_rm = {'L','procFile'};
   for i=1:size(fields_rm,2)
       if isfield(roi_specs,fields_rm{i})
           roi_specs = rmfield(roi_specs,fields_rm{i});
       end
   end

   %update ori
   if roi_specs.shape ~= 2
        roi_specs.ori = ori;
        
        %since we already computed surface for the curvature case
        if exist('radial_vector','var')
        roi_specs.surface_normals = radial_vector(s_roi,:)./vecnorm(radial_vector(s_roi,:),2,2);
        end
   end
           
 
      
end
    
end
