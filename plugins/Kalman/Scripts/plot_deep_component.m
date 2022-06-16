loop_indx = 1;
ms_after_stimulus = [14 16 20 22 30];

for frame = [21 31 51 61 101]
    frame = num2str(frame);
    ms = num2str(ms_after_stimulus(loop_indx));
    full_address = 'exportImage';
    file_name = ['mneSL' ms 'ms'];
    file_full = fullfile(full_address, file_name);

    %%
    zef.h_reconstruction_type.Value = 7;
    zef.h_frame_stop.Value = frame;
    zef.h_frame_start.Value = frame;
    zef_update_mesh_visualization_tool;
    zef_visualize_surfaces;
    
    TuningParameters = {
%                     'colormapselection',11
%                     'update_specular_slider',0.02
%                     'update_diffusion_slider',0.25
%                     'update_ambience_slider',0.94
                     'update_contrast_slider',-0.25
                    'update_brightness_slider',0};
    f = gcf;
    for j = 1:size(TuningParameters,1)
        h = findobj(f.Children,'Tag',TuningParameters{j,1});
        h.Value=TuningParameters{j,2};
        eval(h.Callback)
    end
    %% Deep Component
    % set(zef.h_axes1,'clim',[0 1])
    f1 = gcf;
    f2 = figure();
    %612   510
    f2.Position(3) = 620;
    f2.Position(4) = 600;
    copyobj(findobj(f1.Children, 'tag','axes1'), f2);

    f2.Children.Position(2) = 60;
    grid off
    axis off
    %view(-90,40)
    view(-180,40)
    %f2.Children.Children(end).FaceAlpha = 0.45;
    %f2.Children.Children(end-1).FaceAlpha = 0.45;
    colormap(gca, plasma)

    set(gcf, 'color', 'w')
    %%
    print(f2,'-dpng','-r150',[file_full 'frontDeep' '.png'])
    savefig(f2, [file_full 'frontDeep' '.fig'])


    view(-90,40)
    print(f2,'-dpng','-r150',[file_full 'sideDeep' '.png'])
    savefig(f2, [file_full 'sideDeep' '.fig'])
    
    close(f2)
    loop_indx = loop_indx + 1;
end