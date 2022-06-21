function zef_update_contour

if evalin('base','zef.show_contour')
h_fig = gcf;
h_axes = findobj(h_fig.Children,'Tag','axes1');
h_reconstruction = findobj(h_axes.Children,'Tag','reconstruction');
for i = 1 : length(h_reconstruction)
zef_plot_contour(evalin('base','zef.contour_set'),h_reconstruction(i).FaceVertexCData,h_reconstruction(i).Faces,h_reconstruction(i).Vertices);
end 
end

end