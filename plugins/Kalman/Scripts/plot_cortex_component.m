
loop_indx = 1;
ms_after_stimulus = [120];

for frame = [84]
    frame = num2str(frame);
    ms = num2str(ms_after_stimulus(loop_indx));
    full_address = 'exportImage';
    file_name = ['KalmanSL' ms 'ms' 'Auditory'];
    file_full = fullfile(full_address, file_name);

    %%
    zef.h_reconstruction_type.Value = 7;
    zef.h_frame_stop.Value = frame;
    zef.h_frame_start.Value = frame;
    zef_update_mesh_visualization_tool;
    zef_visualize_surfaces;
    
    TuningParameters = {
                     'colormapselection',5
%                     'update_specular_slider',0.02
%                     'update_diffusion_slider',0.25
%                     'update_ambience_slider',0.94
%                    'update_contrast_slider',-0.25
                    'update_brightness_slider',0.25};
    f = gcf;
    for j = 1:size(TuningParameters,1)
        h = findobj(f.Children,'Tag',TuningParameters{j,1});
        h.Value=TuningParameters{j,2};
        eval(h.Callback)
    end
    %%
    f1 = gcf;
    f2 = figure();
    copyobj(findobj(f1.Children, 'tag','axes1'), f2);

    f2.Children.Position(2) = 35;
    grid off
    axis off
    view(-90,0)

    %f2.Children.View = [-110 40];
    
    %colormap(gca, plasma)
    set(gca,'clim',[0 0.85])
    set(gcf, 'color', 'w')
    
    % f2.Children.Children(end).FaceAlpha = 0.35;
    % f2.Children.Children(end-1).FaceAlpha = 0.35;
    % f2.Children.Children(end-2).FaceAlpha = 0.35;
    %%
    
    print(f2,'-dpng','-r150',[file_full '1' '.png'])
    savefig(f2, [file_full '1' '.fig'])
    
    view(90,0)
    print(f2,'-dpng','-r150',[file_full '2' '.png'])
    %savefig(f2, [file_full 'side2' '.fig'])
    
    view(-180,-90)
    print(f2,'-dpng','-r150',[file_full '3' '.png'])
    %savefig(f2, [file_full 'side3' '.fig'])
%     
%     view(180,0)
%     print(f2,'-dpng','-r150',[file_full 'cortexFront' '.png'])
%     savefig(f2, [file_full 'cortex' '.fig'])
%     
%     view(-90,90)
%     print(f2,'-dpng','-r150',[file_full 'cortexUp' '.png'])
%     savefig(f2, [file_full 'cortex' '.fig'])
    
    close(f2)
    loop_indx = loop_indx + 1;
end
