function zef_PlotGMModel
parameters = evalin('base','zef.GMM.parameters.Values');
m_size = str2num(parameters{8});
m_width = str2num(parameters{9});
m_sym = parameters{7};
s_length = str2num(parameters{16})^2;
plot_ellipsoids = parameters{11};
ellip_trans = str2num(parameters{12});
meta2 = evalin('base','zef.GMM.meta{2}');
comp_ord = parameters{meta2+1};
ellip_coloring_type = parameters{meta2+6};
ellip_components = str2num(parameters{meta2+5});
dip_components = str2num(parameters{meta2+4});
if strcmp(comp_ord,'3')
    ellip_num = min(str2num(parameters{meta2+3}),length(ellip_components));
    dip_num = min(str2num(parameters{meta2+2}),length(dip_components));
else
    ellip_num = str2num(parameters{meta2+3});
    dip_num = str2num(parameters{meta2+2});
end

start_t = str2num(parameters{13});
stop_t = str2num(parameters{14});

identcov = parameters{4};
covtype = parameters{3};
estim_param = str2num(parameters{22});

K = max(str2num(parameters{1}));
GMModel = evalin('base','zef.GMM.model');
GMMdipoles = evalin('base','zef.GMM.dipoles');
alpha = str2num(parameters{6})/100;
r = sqrt(chi2inv(alpha,3));

%colors for confidence ellipsoids:
if strcmp(ellip_coloring_type,'1')
    colors = [1,0,0;0,1,0;0,0,1;1,0.5,0;0,1,1;0.5,0,1;1,0.5,0.5;0.4,1,0.8;0.2,0.6,1;1,0.8,0.6;0.8,1,0.6;0.6,1,1;0.8,0.6,1];
    if K > size(colors,1)
        colors = hsv(K);
        colors = colors(randperm(K),:);
    end
else
    colors = parameters{meta2+7};
    if ~iscell(colors)
        colors = str2num(colors);
        if size(colors,2) < 3 || size(colors,2) > 3
            colors = reshape(colors',3,[])';
        end
        keyboard
        if size(colors,1) < K
            colors = [colors; repmat(colors(end,:),K-size(colors,1),1)];
        end
    else
        last_ind = length(colors);
        zef_j = 0;
        colors_num_aux = nan(1,3);
        while zef_j < last_ind
            zef_j=zef_j + 1;
            if length(colors{zef_j}) > 1
                if isempty(str2num(erase(colors{zef_j},{'[',']'})))
                    colors_aux = colors(1:zef_j-1);
                    for zef_i = 1:length(colors{zef_j})
                        colors_aux{zef_j+zef_i-1} = colors{zef_j}(zef_i);
                    end
                    colors = [colors_aux,colors(zef_j+1:end)];
                    last_ind = last_ind + zef_i - 1;
                    zef_j = zef_j + zef_i - 1;
                else
                    if contains(colors{zef_j},'[')
                        colors_num_aux(1) = str2num(erase(colors{zef_j},'['));
                        first_num_ind = zef_j;
                    elseif contains(colors{zef_j},']')
                        colors_num_aux(3) = str2num(erase(colors{zef_j},']'));
                        last_num_ind = zef_j;
                    else
                        colors_num_aux(2) = str2num(colors{zef_j});
                    end

                    if sum(isnan(colors_num_aux)) == 0
                        colors{first_num_ind} = colors_num_aux;
                        colors(first_num_ind+1:last_num_ind) = [];
                        last_ind = length(colors);
                        colors_num_aux = nan(1,3);
                    end
                end
            end
        end
        if length(colors) < K
            for zef_j = (last_ind+1):K
                colors{zef_j} = colors{last_ind};
            end
        end
    end
end

h = evalin('base','zef.h_axes1');
%set temporarly transparencies stated in mesh visualization to temporary
%variables:
evalin('base','zef_layer_transparency_temp=zef.layer_transparency; zef.layer_transparency=str2num(zef.GMM.parameters.Values{10});')
evalin('base','zef_brain_transparency_temp=zef.brain_transparency; zef.brain_transparency=str2num(zef.GMM.parameters.Values{10});')
%If there is no time serie:
if ~iscell(GMModel)
max_iter = min(size(GMModel.mu,1),ellip_num);
if strcmp(comp_ord,'1')
    order = 1:size(GMModel.mu,1);
elseif strcmp(comp_ord,'2')
    Amp = sum(GMMdipoles.^2,2);
    [~,order] = sort(Amp,'descend');
elseif strcmp(comp_ord,'3')
    order = ellip_components(ismember(ellip_components,intersect(ellip_components,1:size(GMModel.mu,1))));
    max_iter = min(length(order),max_iter);
end

evalin('base','zef_GMM_subs_time_vars(''in''); zef_frame_start_temp=zef.frame_start; zef_frame_stop_temp=zef.frame_stop; zef.frame_start=zef.GMM.parameters.Values{17}; zef.frame_stop=zef.GMM.parameters.Values{18};');
evalin('base','zef_visualize_surfaces; zef.frame_start=zef_frame_start_temp; zef.frame_stop=zef_frame_stop_temp; clear zef_frame_start_temp zef_frame_stop_temp;');
hold(h,'on')
if strcmp(plot_ellipsoids,'1')
if ~strcmp(covtype,'1')
    principal_axes = eye(3);
end
for k = 1:max_iter
    %Determine principal and semi axes of the ellipsoid:
    if strcmp(identcov,'1')
        if strcmp(covtype,'1')
            [principal_axes,semi_axes]=eig(inv(GMModel.Sigma(1:3,1:3,order(k))));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel.Sigma(1,1:3,order(k)));
        end
    else
        if strcmp(covtype,'1')
            [principal_axes,semi_axes]=eig(inv(GMModel.Sigma(1:3,1:3)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel.Sigma(1:3));
        end
    end
    %form ellipsoid mesh:
    [X,Y,Z]=ellipsoid(GMModel.mu(order(k),1),GMModel.mu(order(k),2),GMModel.mu(order(k),3),semi_axes(1),semi_axes(2),semi_axes(3),100);
    s(k) = surf(h,X,Y,Z);
    set(s(k),'EdgeColor','none');
    if iscell(colors)
        set(s(k),'FaceColor',colors{k});
    else
        set(s(k),'FaceColor',colors(k,:));
    end
    set(s(k),'FaceAlpha',ellip_trans);
    %Rotate standard coordinated ellipsoid to the direction of principal
    %axes (rotation command is based on right-hand-rule):
    CosTheta = max(min(dot([1;0;0],principal_axes(:,1))/(norm(principal_axes(:,1))),1),-1);
    ang = real(acosd(CosTheta));
    rot_axis = cross([1;0;0],principal_axes(:,1));
    if ang ~= 0
    rotate(s(k),rot_axis,ang,GMModel.mu(order(k),1:3));
    end
    %transform (0,1,0) vector to the new direction via Rodrigues' formula:
    e2_vec = [0;1;0]*cosd(ang)+cross(rot_axis,[0;1;0])*sind(ang)+rot_axis*dot(rot_axis,[0;1;0])*(1-cosd(ang));

    CosTheta = max(min(dot(e2_vec,principal_axes(:,2))/(norm(principal_axes(:,2))),1),-1);
    ang = real(acosd(CosTheta));
    if ang ~= 0
    rotate(s(k),cross(e2_vec,principal_axes(:,2)),ang,GMModel.mu(order(k),1:3));
    end

end
end

if ~strcmp(comp_ord,'3')
    dip_ind = order(1:min(dip_num,size(GMModel.mu,1)));
else
    dip_ind = intersect(dip_components,1:size(GMModel.mu,1));
end
%plot centroid marks:
plot3(h,GMModel.mu(dip_ind,1),GMModel.mu(dip_ind,2),GMModel.mu(dip_ind,3),m_sym,'LineWidth',m_width,'MarkerSize',m_size)
%set direction vectors (original can be non-unit length)
%direct = s_length*GMModel.mu(dip_ind,4:6)./sqrt(sum(GMModel.mu(dip_ind,4:6).^2,2));
if estim_param == 1
direct = s_length*[cos(GMModel.mu(dip_ind,5)).*sin(GMModel.mu(dip_ind,4)),sin(GMModel.mu(dip_ind,5)).*sin(GMModel.mu(dip_ind,1)),cos(GMModel.mu(dip_ind,4))];
elseif estim_param == 2
    direct = zeros(length(dip_ind),3);
end
quiver3(h,GMModel.mu(dip_ind,1),GMModel.mu(dip_ind,2),GMModel.mu(dip_ind,3),direct(:,1),direct(:,2),direct(:,3),0,'color',erase(m_sym,'o'), 'linewidth',m_width,'MarkerSize',m_size);
hold(h,'off')%set old time parameters back to their places:
evalin('base','zef_GMM_subs_time_vars(''out'')');

%If time serie exists:
else
    evalin('base','zef_GMM_subs_time_vars(''in''); zef_frame_start_temp=zef.frame_start; zef_frame_stop_temp=zef.frame_stop;');
    if  length(GMModel) < stop_t
        stop_t = length(GMModel);
    end

for t = start_t:stop_t
    if isempty(GMModel{t})
        error(['There is no Gaussian mixature model for the frame ',num2str(t),'.'])
    end
max_iter = min(size(GMModel{t}.mu,1),ellip_num);
if strcmp(comp_ord,'1')
    order = 1:size(GMModel{t}.mu,1);
elseif strcmp(comp_ord,'2')
    Amp = sum(GMMdipoles{t}.^2,2);
    [~,order] = sort(Amp,'descend');
elseif strcmp(comp_ord,'3')
    order = ellip_components(ismember(ellip_components,intersect(ellip_components,1:size(GMModel{t}.mu,1))));
    max_iter = min(length(order),max_iter);
end

%set surface visualization frames to go along this for loop:
assignin('base','zef_t',t);
evalin('base','zef.frame_start=zef_t; zef.frame_stop=zef_t;');
evalin('base','zef_visualize_surfaces;');
hold(h,'on')
if strcmp(plot_ellipsoids,'1')
if strcmp(covtype,'1')
    principal_axes = eye(3);
end
for k = 1:max_iter
    %Determine principal and semi axes of the ellipsoid:
    if strcmp(identcov,'1')
        if strcmp(covtype,'1')
            [principal_axes,semi_axes]=eig(inv(GMModel{t}.Sigma(1:3,1:3,order(k))));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel{t}.Sigma(1,1:3,order(k)));
        end
    else
        if strcmp(covtype,'1')
            [principal_axes,semi_axes]=eig(inv(GMModel{t}.Sigma(1:3,1:3)));
            semi_axes = transpose(r./sqrt(diag(semi_axes)));
        else
            semi_axes = r*sqrt(GMModel{t}.Sigma(1:3));
        end
    end
    %form ellipsoid mesh:
    [X,Y,Z]=ellipsoid(GMModel{t}.mu(order(k),1),GMModel{t}.mu(order(k),2),GMModel{t}.mu(order(k),3),semi_axes(1),semi_axes(2),semi_axes(3),100);
    s(k) = surf(h,X,Y,Z);
    set(s(k),'EdgeColor','none');
    if iscell(colors)
        set(s(k),'FaceColor',colors{k});
    else
        set(s(k),'FaceColor',colors(k,:));
    end
    set(s(k),'FaceAlpha',ellip_trans);
    %Rotate standard coordinated ellipsoid to the direction of principal
    %axes (rotation command is based on right-hand-rule):
    CosTheta = max(min(dot([1;0;0],principal_axes(:,1))/(norm(principal_axes(:,1))),1),-1);
    ang = real(acosd(CosTheta));
    rot_axis = cross([1;0;0],principal_axes(:,1));
    if ang ~= 0
    rotate(s(k),rot_axis,ang,GMModel{t}.mu(order(k),1:3));
    end
    %transform (0,1,0) vector to the new direction via Rodrigues' formula:
    e2_vec = [0;1;0]*cosd(ang)+cross(rot_axis,[0;1;0])*sind(ang)+rot_axis*dot(rot_axis,[0;1;0])*(1-cosd(ang));

    CosTheta = max(min(dot(e2_vec,principal_axes(:,2))/(norm(principal_axes(:,2))),1),-1);
    ang = real(acosd(CosTheta));
    if ang ~= 0
    rotate(s(k),cross(e2_vec,principal_axes(:,2)),ang,GMModel{t}.mu(order(k),1:3));
    end
end
end

if ~strcmp(comp_ord,'3')
    dip_ind = order(1:min(dip_num,length(order)));
else
    dip_ind = intersect(dip_components,1:size(GMModel{t}.mu,1));
end
%plot centroid marks:
plot3(h,GMModel{t}.mu(dip_ind,1),GMModel{t}.mu(dip_ind,2),GMModel{t}.mu(dip_ind,3),m_sym,'LineWidth',m_width,'MarkerSize',m_size)
%set direction vectors (original can be non-unit length)
if estim_param == 1
direct = s_length*[cos(GMModel{t}.mu(dip_ind,5)).*sin(GMModel{t}.mu(dip_ind,4)),sin(GMModel{t}.mu(dip_ind,5)).*sin(GMModel{t}.mu(dip_ind,4)),cos(GMModel{t}.mu(dip_ind,4))];
elseif estim_param == 2
    direct = zeros(length(dip_ind),3);
end
quiver3(h,GMModel{t}.mu(dip_ind,1),GMModel{t}.mu(dip_ind,2),GMModel{t}.mu(dip_ind,3),direct(:,1),direct(:,2),direct(:,3),0,'color',erase(m_sym,'o'),'linewidth',m_width,'MarkerSize',m_size);
hold(h,'off')
pause(1.5)
end
%set old frame values and time parameters back to their places:
evalin('base','zef_GMM_subs_time_vars(''out''); clear(''zef_t''); zef.frame_start=zef_frame_start_temp; zef.frame_stop=zef_frame_stop_temp; clear(''zef_frame_start_temp'',''zef_frame_stop_temp'');');

end
%set transparencies back:
evalin('base','zef.layer_transparency=zef_layer_transparency_temp; clear zef_layer_transparency_temp;');
evalin('base','zef.brain_transparency=zef_brain_transparency_temp; clear zef_brain_transparency_temp;');

end
