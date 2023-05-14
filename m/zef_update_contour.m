function zef_update_contour(zef)

if eval('zef.show_contour')
    h_fig = gcf;
    h_axes = findobj(h_fig.Children,'Tag','axes1');
    h_contour_old = findobj(h_axes.Children,'Tag','contour');
    delete(h_contour_old);
    h_contour_text_old = findobj(h_axes.Children,'Tag','contour_text');
    delete(h_contour_text_old);
    h_reconstruction = findobj(h_axes.Children,'Tag','reconstruction');
    for i = 1 : length(h_reconstruction)
        zef_plot_contour(zef,eval('zef.contour_set'),h_reconstruction(i).FaceVertexCData,h_reconstruction(i).Faces,h_reconstruction(i).Vertices);
    end
end

end
