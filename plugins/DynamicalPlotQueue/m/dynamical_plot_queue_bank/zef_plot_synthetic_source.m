function zef_plot_synthetic_source(varargin)
%A static plot showing the active synthetic sources

color_cell = {'k','r','g','b','y','m','c'};
h_axes = evalin('caller','h_axes_image');
s = evalin('base','zef.inv_synth_source');
s_o = s(:,4:6)./repmat(sqrt(sum(s(:,4:6).^2,2)),1,3);
for i = 1 : size(s,1)
h_source = quiver3(s(i,1),s(i,2),s(i,3),s(i,9)*s_o(i,1),s(i,9)*s_o(i,2),s(i,9)*s_o(i,3)); 
set(h_source,'Tag','additional: synthetic source');
set(h_source,'linewidth',sqrt(3)*sqrt(s(i,9)));
set(h_source,'color',color_cell{s(i,10)})
end

end