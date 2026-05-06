function [meas_data,roi_source_pos,dip_ori,amp_all,n_multiple_sources,roi_specs] = zef_find_source_ROI(zef,varargin)

allow_overlapping_ROIs = true;

if nargin>1
    if islogical(varargin{1})
        allow_overlapping_ROIs = varargin{1}; 
    end
end

%get variables
noise_level = zef.synth_source_ROI(1,17);
s_p = zef.synth_source_ROI(:,9:11); 
s_a = 1e-3*zef.synth_source_ROI(:,16); 
source_positions = zef.source_positions;
L = zef.L;
dip_ori_type = zef.synth_source_ROI(1,12);

% specs for all the rois
roi_specs_global = struct();
roi_specs_global.shape = zef.synth_source_ROI(1,1);

%if the roi or the dipoles are cortex normal need to process the leadfield
if dip_ori_type == 4  || (roi_specs_global.shape~=2 && zef.synth_source_ROI(1,5) == 4)
    
    %check if there is a constrained compartment
    compartment_tags = zef.compartment_tags;
    n_cpm = size(compartment_tags,2);
    cpm_source_directions = zeros(1, n_cpm);
    for tag_idx=1:n_cpm
       cpm_source_directions(tag_idx) = zef.(['c' int2str(tag_idx) '_sources']);
    end
    if ~any(cpm_source_directions == 1)
        warning('Set grey matter compartment activity to constrained!')
    end

    zef.source_direction_mode = 2;
    [~,~,procFile] = zef_processLeadfields(zef);
end

%more specs if the ROI is not spherical
if roi_specs_global.shape ~=2 
    roi_specs_global.oriType = zef.synth_source_ROI(1,5);

    %for svd, we also need the leadfield
    if ismember(roi_specs_global.oriType, [2 3])
        roi_specs_global.L = L;
    
    %and the procFile for cortex normal 
    elseif roi_specs_global.oriType == 4      
        roi_specs_global.procFile = procFile;

    end
end


% manual/custom orientation 
% for normal constraint, sources in nonrestricted cpms will also take s_o
if ismember(dip_ori_type,[1 4]) 
    s_o = zef.synth_source_ROI(:,13:15);
    s_o = s_o ./ vecnorm(s_o, 2, 2);
end


%output positions and moments of the dipoles
all_roi_sources = [];
dip_ori = []; 
amp_all = [];

% how many dipoles per roi, if there is more than one roi
n_multiple_sources = ones(size(s_p,1),1);


for i = 1 : size(s_p,1)

    % define the current roi
    roi_name = ['roi_' int2str(i)];
    roi_specs.(roi_name) = roi_specs_global;

    % some more specs if it is not a sphere
    if roi_specs.(roi_name).shape ~=2 

        roi_specs.(roi_name).width = abs(zef.synth_source_ROI(i,3));

        if roi_specs.(roi_name).shape == 1
            roi_specs.(roi_name).curvature = zef.synth_source_ROI(i,4);
        end
    
        if ismember(roi_specs.(roi_name).oriType,[1 4])
            roi_specs.(roi_name).ori = zef.synth_source_ROI(i,6:8);
        end

    end

    roi_specs.(roi_name).radius = abs(zef.synth_source_ROI(i,2));
    roi_specs.(roi_name).roi_center = s_p(i,:);
    
    %find the sources
    [s_roi,roi_specs_current] = zef_ROI_finder(source_positions, roi_specs.(roi_name));
    
    %update the position and orientation of the ROI
    roi_specs.(roi_name) = roi_specs_current;

    
    if ~allow_overlapping_ROIs

            %remove sources already in previous roi
            s_roi_unique = setdiff(s_roi,all_roi_sources);
                      
            if length(s_roi_unique)<length(s_roi)
            
                warning('Overlapping ROIs: Sources are only used once!');
                
                if isempty(s_roi_unique)
                    %normally s_roi is not empty as it contains at least
                    %the roi center
                    error('No sources in ROI %i',i)
                elseif isfield(roi_specs.(roi_name),'surface_normals')
                    %remove surface normals of repeated sources
                    roi_specs.(roi_name).surface_normals =  roi_specs.(roi_name).surface_normals(ismember(s_roi, s_roi_unique),:);
                end
                
                s_roi = s_roi_unique;  

            end
       
    end

    all_roi_sources = [all_roi_sources; s_roi];

    %get the orientations of the dipoles
    
    switch dip_ori_type

        case  1 %...all sources per roi have the same, manually input orientation
            
            ori = repmat(s_o(i,:),size(s_roi,1),1);

        case 2 %... svd max

            minmax = 'max';

            %if we already did svd for the roi orientation, use as reference
            if roi_specs.(roi_name).shape~=2 && ismember(roi_specs.(roi_name).oriType, [2 3])
                radialRef = roi_specs.(roi_name).ori;
                ori = zef_minmax_svd_ori(s_roi,minmax,L,radialRef);
            else             
                ori = zef_get_radial_orientation(s_roi,minmax,L);
            end             
             
        case 3 %svd min
             
            minmax = 'min';

            %if we already did svd for the roi orientation, use as reference
            if roi_specs.(roi_name).shape~=2 && ismember(roi_specs.(roi_name).oriType, [2 3])
                radialRef = roi_specs.(roi_name).ori;
                ori = zef_minmax_svd_ori(L,minmax,s_roi,radialRef);
            else
                %use roi position as reference
                s_ref = dsearchn(source_positions, s_p(i,:)); 
                ori = zef_get_radial_orientation(s_roi,minmax,L,s_ref,source_positions);
            end

        case 4 %...using normal orientation for restricted sources, and specified for nonrestricted
            
            [ori,s_roi] = zef_get_normal_ori(procFile,s_o(i,:),s_roi);       

        case 5 %...sources are oriented normal to patch surface
            
            %in case of a curved patch, surface normals are already
            %calculated
            if isfield(roi_specs.(roi_name),'surface_normals')

                ori = roi_specs.(roi_name).surface_normals;

            else %if there is no curvature there is just one surface normal
 
               ori = repmat(roi_specs.(roi_name).ori,size(s_roi,1),1);
            
            end
        
        

    end
    
    n_multiple_sources(i) = size(s_roi,1);
    dip_ori = [dip_ori;ori];

    %divide amplitude by number of sources in roi
    amp_all = [amp_all;repmat(s_a(i)/n_multiple_sources(i),n_multiple_sources(i),1)];

end

%dipole moment vector
s_f = reshape(amp_all.*dip_ori,size(all_roi_sources,1)*3,1);

meas_data = L(:, all_roi_sources*3 + (0:2)-2) * s_f;


%noise
meas_data = meas_data + noise_level*max(abs(meas_data)).*randn(size(meas_data));

%output positions
roi_source_pos = source_positions(all_roi_sources,:);



end

