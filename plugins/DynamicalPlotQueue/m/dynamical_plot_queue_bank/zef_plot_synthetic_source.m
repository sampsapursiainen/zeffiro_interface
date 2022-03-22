function zef_plot_synthetic_source(varargin)
%A static plot showing the active synthetic sources

color_cell = {'k','r','g','b','y','m','c'};
h_axes = evalin('caller','h_axes_image');
axes(h_axes);
s = evalin('base','zef.inv_synth_source');
s_o = s(:,4:6)./repmat(sqrt(sum(s(:,4:6).^2,2)),1,3);
for i = 1 : size(s,1)
source_size = 6*sqrt(s(i,9));
h_source = quiver3(h_axes,s(i,1),s(i,2),s(i,3),source_size*s_o(i,1),s(i,9)*s_o(i,2),s(i,9)*s_o(i,3),'Marker','o','MarkerSize',0.8*source_size);
set(h_source,'Tag','additional: synthetic source');
set(h_source,'linewidth',0.5*source_size);
set(h_source,'color',color_cell{s(i,10)})

end

end
