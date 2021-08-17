function zef_simple_plot_sphere_min(varargin)
%Plots a blue sphere showing the minimizer of the reconstruction. 
%The optional argument is the scale of the radius. This 
%function can be either static or dynamical.

if not(isempty(varargin))
radius_val = varargin{1};
else
radius_val = 10;
end

[X,Y,Z] = sphere(100);
h_axes = evalin('caller','h_axes_image');
f_ind = evalin('caller','f_ind');
delete(findobj(h_axes,'Tag','additional: min sphere'));
r = evalin('base','zef.reconstruction');
p = evalin('base','zef.source_positions');
[min_val,r_ind] = min(sum(reshape(r{f_ind},3,length(r{f_ind}(:))/3).^2));
h_surf = surf(h_axes,radius_val*X+p(r_ind,1),radius_val*Y+p(r_ind,2),radius_val*Z+p(r_ind,3));
set(h_surf,'edgecolor','none','facecolor',[0 0 1]);
set(h_surf,'Tag','additional: min sphere');

end