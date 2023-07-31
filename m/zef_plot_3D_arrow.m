function h_arrow_vec = zef_plot_3D_arrow(x,y,z,u,v,w,varargin)

h_axes = gca;
hold_state = ishold(h_axes);

arrow_scale = 1;
arrow_type = 1;
arrow_color = 0.5*[1 1 1];
arrow_shape = 10;
arrow_length = 1;
arrow_head_size = 2;
arrow_n_polygons = 100;

if not(isempty(varargin))
    arrow_scale = varargin{1};
    if length(varargin)>1
        arrow_type = varargin{2};
    end
    if length(varargin)>2
        arrow_color = varargin{3};
    end
    if length(varargin)>3
        arrow_shape= varargin{4};
    end
    if length(varargin)>4
        arrow_length = varargin{5};
    end
    if length(varargin)>5
        arrow_head_size = varargin{6};
    end
    if length(varargin)>6
        arrow_n_polygons = varargin{7};
    end
end

if isequal(arrow_type,1)
    [X,Y,Z] = cylinder([1],arrow_n_polygons);
    [X2,Y2,Z2] = sphere(arrow_n_polygons);
    X = [X; arrow_head_size*X2]/arrow_shape;
    Y = [Y; arrow_head_size*Y2]/arrow_shape;
    Z = arrow_length*(1-[(arrow_shape-arrow_head_size)*Z ; (arrow_shape-arrow_head_size)+arrow_head_size*Z2]/arrow_shape);
else
    [X,Y,Z] = cylinder(1,arrow_n_polygons);
    [X2,Y2,Z2] = cylinder([1 0],arrow_n_polygons);
    X = [X; arrow_head_size*X2]/arrow_shape;
    Y = [Y; arrow_head_size*Y2]/arrow_shape;
    Z = arrow_length*([(arrow_shape-2*arrow_head_size)*Z ; (arrow_shape-2*arrow_head_size)+2*arrow_head_size*Z2]/arrow_shape);
end

axes(h_axes);

dir_vec_1 = [zeros(1,length(x)) ; zeros(1,length(x)) ; ones(1,length(x))];
dir_vec_2 = [u(:)' ; v(:)' ; w(:)'];
dir_vec_1 = dir_vec_1./repmat(sqrt(sum(dir_vec_1.^2)),3,1);
dir_vec_2 = dir_vec_2./repmat(sqrt(sum(dir_vec_2.^2)),3,1);
dir_vec_3 = cross(dir_vec_1,dir_vec_2);
arrow_sign = 1;
dir_vec_3_norm = norm(dir_vec_3,2);
if isequal(dir_vec_3_norm,0)
    arrow_sign = sign(sum(dir_vec_1.*dir_vec_2));
end

rot_angle = acosd(sum(dir_vec_1.*dir_vec_2));

if not(hold_state)
    hold on;
end

h_arrow_vec = zeros(length(x),1);

for i = 1 : length(x)

    arrow_norm = arrow_sign*arrow_scale*(sqrt(u(i)^2 + v(i)^2 + w(i)^2));
    h_arrow = surf(arrow_norm*X,arrow_norm*Y,arrow_norm*Z);
    h_arrow_vec(i) = h_arrow;
    if not(isequal(dir_vec_3_norm,0))
        rotate(h_arrow,dir_vec_3,rot_angle,[0 0 0]);
    end

    h_arrow.XData = h_arrow.XData + x(i);
    h_arrow.YData  = h_arrow.YData + y(i);
    h_arrow.ZData = h_arrow.ZData + z(i);

    if isequal(size(arrow_color,1),length(x))
        set(h_arrow,'FaceColor',arrow_color(i,:));
        set(h_arrow,'EdgeColor','none');
    else
        set(h_arrow,'FaceColor',arrow_color);
        set(h_arrow,'EdgeColor','none');
    end

end

if not(hold_state)
    hold off;
end



end
