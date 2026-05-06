function h_surf = zef_plot_disk(position,radius,width,ori,k,color)


h_axes = gca;
hold_state = ishold(h_axes);

if not(hold_state)
    hold on;
end

    
%make sure ori is column vector
z = ori(:)/norm(ori);

if isequal(abs(z),[0 0 1]')
    x = [1 0 0]';
else
    x = 1/sqrt(z(1)^2+z(2)^2)* [z(2) -z(1) 0]';
end

y = cross(z,x);


%rotation matrix
T = [x y z]; 

if k == 0 %no curvature

    h_surf = hggroup;
    
    nTheta = 50;
    nRadius = 20; 
    
   
    %this is a ring
    [theta, Z] = meshgrid(linspace(0, 2*pi, nTheta), linspace(-width/2, width/2, 2));
    X = radius * cos(theta);
    Y = radius * sin(theta);  

    points_rot = T* [X(:)'; Y(:)'; Z(:)'];

    X_ring = reshape(points_rot(1,:), size(X)) + position(1);
    Y_ring = reshape(points_rot(2,:), size(Y)) + position(2);
    Z_ring = reshape(points_rot(3,:), size(Z)) + position(3);

    %this is a circle
    [theta, r] = meshgrid(linspace(0, 2*pi, nTheta), linspace(0, radius, nRadius));
    X = r.* cos(theta);
    Y = r.* sin(theta);
    Z = (width/2) * ones(size(X));
   

    points_rot = T *[X(:)'; Y(:)'; Z(:)'];

    %top of the cylinder
    X_top = reshape(points_rot(1,:), size(X)) + position(1);
    Y_top = reshape(points_rot(2,:), size(Y)) + position(2);
    Z_top = reshape(points_rot(3,:), size(Z)) + position(3);
 

    Z = (-width/2) * ones(size(X));
    points_rot = T* [X(:)'; Y(:)'; Z(:)'];
    
    %bottom of the cylinder
    X_bot = reshape(points_rot(1,:), size(X)) + position(1);
    Y_bot = reshape(points_rot(2,:), size(Y)) + position(2);
    Z_bot = reshape(points_rot(3,:), size(Z)) + position(3);

    %if width ==0 these converge
    surf(h_axes, X_top, Y_top, Z_top, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);
    surf(h_axes, X_ring, Y_ring, Z_ring, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);
    surf(h_axes, X_bot, Y_bot, Z_bot, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);
    
    

else
    
  
    r = radius/(k*sqrt(2));
    w = min([width,2*abs(r)]);
    r_vec = r*ori;


    theta_max = acos(1 - radius^2/(2*abs(r)^2));

  
    N = 50; % resolution
    

    % this is a sphere cap
    [phi, theta] = meshgrid(linspace(0, 2*pi, N), linspace(0, theta_max, N));

    % Outer sphere
    r_outer = r + w/2;
    X_outer = r_outer * sin(theta) .* cos(phi);
    Y_outer = r_outer * sin(theta) .* sin(phi);
    Z_outer = r_outer * cos(theta);

    points_rot = T *[X_outer(:)'; Y_outer(:)'; Z_outer(:)'];

    X_outer = reshape(points_rot(1,:), size(X_outer)) + position(1)-r_vec(1);
    Y_outer = reshape(points_rot(2,:), size(Y_outer)) + position(2)-r_vec(2);
    Z_outer = reshape(points_rot(3,:), size(Z_outer)) + position(3)-r_vec(3);

    % Inner sphere
    r_inner = r - w/2;
    X_inner = r_inner * sin(theta) .* cos(phi);
    Y_inner = r_inner * sin(theta) .* sin(phi);
    Z_inner = r_inner * cos(theta);

    points_rot = T *[X_inner(:)'; Y_inner(:)'; Z_inner(:)'];


    X_inner = reshape(points_rot(1,:), size(X_inner)) + position(1)-r_vec(1);
    Y_inner = reshape(points_rot(2,:), size(Y_inner)) + position(2)-r_vec(2);
    Z_inner = reshape(points_rot(3,:), size(Z_inner)) + position(3)-r_vec(3);

    h_surf = hggroup;

    % Plot outer cap
    surf(X_outer, Y_outer, Z_outer, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);
    hold on

    % Plot inner cap
    surf(X_inner, Y_inner, Z_inner, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);

    % the side surface is at theta = theta_max but variable r
    r = linspace(r_inner, r_outer, N);
    phi_side = linspace(0, 2*pi, N);
    [R, Phi] = meshgrid(r, phi_side);

    X_side = R .* sin(theta_max) .* cos(Phi);
    Y_side = R .* sin(theta_max) .* sin(Phi);
    Z_side = R .* cos(theta_max);

    points_rot = T *[X_side(:)'; Y_side(:)'; Z_side(:)'];


    X_side = reshape(points_rot(1,:), size(X_side)) + position(1)-r_vec(1);
    Y_side = reshape(points_rot(2,:), size(Y_side)) + position(2)-r_vec(2);
    Z_side = reshape(points_rot(3,:), size(Z_side)) + position(3)-r_vec(3);

   surf(X_side, Y_side, Z_side, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'Parent', h_surf);

      

end
  

    if not(hold_state)
        hold off;
    end

end

