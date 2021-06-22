function zef_PlotGMMcluster
m_size = evalin('base','zef.GMMcluster_markersize');
m_width = evalin('base','zef.GMMcluster_markerwidth');
m_sym = evalin('base','zef.GMMcluster_markercolor');
s_length = evalin('base','zef.GMMcluster_veclength')^2;
plot_ellipsoids = evalin('base','zef.GMMcluster_plotellip');
ellip_trans = evalin('base','zef.GMMcluster_elliptrans');

start_t = evalin('base','zef.GMMcluster_startframe');
stop_t = evalin('base','zef.GMMcluster_stopframe');

identcov = evalin('base','zef.GMMcluster_covident');
covtype = evalin('base','zef.GMMcluster_covtype');

K = max(evalin('base','zef.GMMcluster_clustnum'));
GMModel = evalin('base','zef.GMModel');
alpha = evalin('base','zef.GMMcluster_alpha')/100;
r = sqrt(chi2inv(alpha,3));

%colors for confidence ellipsoids:
colors = [1,0,0;0,1,0;0,0,1;1,0.5,0;0,1,1;0.5,0,1;1,0.5,0.5;0.4,1,0.8;0.2,0.6,1;1,0.8,0.6;0.8,1,0.6;0.6,1,1;0.8,0.6,1];
if K > size(colors,1)
    colors = hsv(K);
    colors = colors(randperm(K),:);
end

h = evalin('base','zef.h_axes1');
%set temporarly transparencies stated in mesh visualization to temporary
%variables:
evalin('base','zef_layer_transparency_temp=zef.layer_transparency; zef.layer_transparency=zef.GMMcluster_headtrans;')
evalin('base','zef_brain_transparency_temp=zef.brain_transparency; zef.brain_transparency=zef.GMMcluster_headtrans;')
%If there is no time serie:
if ~iscell(GMModel)
evalin('base','zef_visualize_surfaces;');
hold(h,'on')
if plot_ellipsoids
if covtype ~= 1
    principal_axes = eye(3);
end 
for k = 1:size(GMModel.mu,1)
    %Determine principal and semi axes of the ellipsoid:
    if identcov == 1
        if covtype == 1
            [principal_axes,semi_axes]=eig(inv(GMModel.Sigma(1:3,1:3,k)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel.Sigma(1,1:3,k));
        end
    else
        if covtype == 1
            [principal_axes,semi_axes]=eig(inv(GMModel.Sigma(1:3,1:3)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel.Sigma(1:3));            
        end
    end
    %form ellipsoid mesh:
    [X,Y,Z]=ellipsoid(GMModel.mu(k,1),GMModel.mu(k,2),GMModel.mu(k,3),semi_axes(1),semi_axes(2),semi_axes(3),100);
    s(k) = surf(h,X,Y,Z);
    set(s(k),'EdgeColor','none');
    set(s(k),'FaceColor',colors(k,:));
    set(s(k),'FaceAlpha',ellip_trans);
    %Rotate standard coordinated ellipsoid to the direction of principal
    %axes (rotation command is based on right-hand-rule):
    CosTheta = max(min(dot([1;0;0],principal_axes(:,1))/(norm(principal_axes(:,1))),1),-1);
    ang = real(acosd(CosTheta));
    rot_axis = cross([1;0;0],principal_axes(:,1));
    if ang ~= 0
    rotate(s(k),rot_axis,ang,GMModel.mu(k,1:3));
    end
    %transform (0,1,0) vector to the new direction via Rodrigues' formula:
    e2_vec = [0;1;0]*cosd(ang)+cross(rot_axis,[0;1;0])*sind(ang)+rot_axis*dot(rot_axis,[0;1;0])*(1-cosd(ang));
    
    CosTheta = max(min(dot(e2_vec,principal_axes(:,2))/(norm(principal_axes(:,2))),1),-1);
    ang = real(acosd(CosTheta));
    if ang ~= 0
    rotate(s(k),cross(e2_vec,principal_axes(:,2)),ang,GMModel.mu(k,1:3));
    end
    
end
end
%plot centroid marks:
plot3(h,GMModel.mu(:,1),GMModel.mu(:,2),GMModel.mu(:,3),m_sym,'LineWidth',m_width,'MarkerSize',m_size)
%set direction vectors (original can be non-unit length)
direct = s_length*GMModel.mu(:,4:6)./sqrt(sum(GMModel.mu(:,4:6).^2,2));
quiver3(h,GMModel.mu(:,1),GMModel.mu(:,2),GMModel.mu(:,3),direct(:,1),direct(:,2),direct(:,3),0,'color',erase(m_sym,'o'), 'linewidth',m_width,'MarkerSize',m_size);
hold(h,'off')
%If time serie exists:
else
    evalin('base','zef_frame_start_temp=zef.frame_start; zef_frame_stop_temp=zef.frame_stop;');
    if  length(GMModel) < stop_t
        stop_t = length(GMModel);
    end
    
for t = start_t:stop_t
%set surface visualization frames to go along this for loop:
assignin('base','zef_t',t);
evalin('base','zef.frame_start=zef_t; zef.frame_stop=zef_t;');
evalin('base','zef_visualize_surfaces;');
hold(h,'on')
if plot_ellipsoids
if covtype ~= 1
    principal_axes = eye(3);
end
for k = 1:size(GMModel{t}.mu,1)
    %Determine principal and semi axes of the ellipsoid:
    if identcov == 1
        if covtype == 1
            [principal_axes,semi_axes]=eig(inv(GMModel{t}.Sigma(1:3,1:3,k)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel{t}.Sigma(1,1:3,k));
        end
    else
        if covtype == 1
            [principal_axes,semi_axes]=eig(inv(GMModel{t}.Sigma(1:3,1:3)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel{t}.Sigma(1:3));            
        end
    end   
    %form ellipsoid mesh:
    [X,Y,Z]=ellipsoid(GMModel{t}.mu(k,1),GMModel{t}.mu(k,2),GMModel{t}.mu(k,3),semi_axes(1),semi_axes(2),semi_axes(3),100);
    s(k) = surf(h,X,Y,Z);
    set(s(k),'EdgeColor','none');
    set(s(k),'FaceColor',colors(k,:));
    set(s(k),'FaceAlpha',ellip_trans);
    %Rotate standard coordinated ellipsoid to the direction of principal
    %axes (rotation command is based on right-hand-rule):
    CosTheta = max(min(dot([1;0;0],principal_axes(:,1))/(norm(principal_axes(:,1))),1),-1);
    ang = real(acosd(CosTheta));
    if ang ~= 0
    rotate(s(k),cross([1;0;0],principal_axes(:,1)),ang,GMModel{t}.mu(k,:));
    end
    CosTheta = max(min(dot([0;1;0],principal_axes(:,2))/(norm(principal_axes(:,2))),1),-1);
    ang = real(acosd(CosTheta));
    if ang ~= 0
    rotate(s(k),cross([0;1;0],principal_axes(:,2)),ang,GMModel{t}.mu(k,:));
    end
end
end
%plot centroid marks:
plot3(h,GMModel{t}.mu(:,1),GMModel{t}.mu(:,2),GMModel{t}.mu(:,3),m_sym,'LineWidth',m_width,'MarkerSize',m_size)
%set direction vectors (original can be non-unit length)
direct = s_length*GMModel{t}.mu(:,4:6)./sqrt(sum(GMModel{t}.mu(:,4:6).^2,2));
quiver3(h,GMModel{t}.mu(:,1),GMModel{t}.mu(:,2),GMModel{t}.mu(:,3),direct(:,1),direct(:,2),direct(:,3),0,'color',erase(m_sym,'o'),'linewidth',m_width,'MarkerSize',m_size);
hold(h,'off')
pause(1.5)
end
%set old frame values back to their  places:
evalin('base','clear zef_t; zef.frame_start=zef_frame_start_temp; zef.frame_stop=zef_frame_stop_temp; clear zef_frame_start_temp zef_frame_stop_temp;');

end
%set transparencies back:
evalin('base','zef.layer_transparency=zef_layer_transparency_temp; clear zef_layer_transparency_temp;');
evalin('base','zef.brain_transparency=zef_brain_transparency_temp; clear zef_brain_transparency_temp;');

end