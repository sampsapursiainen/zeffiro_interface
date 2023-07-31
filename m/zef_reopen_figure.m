set(gcbo,'Tag','');
if isequal(exist('zef'),1)
    if isfield(zef,'h_zeffiro')
        if zef.h_zeffiro == gcbo;
            zef_figure_tool;
        end
    end
end
