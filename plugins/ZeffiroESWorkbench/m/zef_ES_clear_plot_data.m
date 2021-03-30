% n = evalin('base','zef.ES_plot_type');
% switch n
%     case 1
%         if isfield(zef,'h_current_ES')
%             delete(zef.h_current_ES)
%             zef = rmfield(zef,'h_current_ES');
%         end
%     case 2
%         if isfield(zef,'h_barplot_ES')
%             delete(zef.h_barplot_ES)
%             zef = rmfield(zef,'h_barplot_ES');
%         end
%     case 3
%         if isfield(zef,'h_colorbar_ES')
%             delete(zef.h_colorbar_ES)
%             zef = rmfield(zef,'h_colorbar_ES');
%         end
%     otherwise
%         disp('An error has ocurred. No case was detected in the switch')
% end
% clear n
%%
if evalin('base','zef.ES_plot_type') == 1
    if isfield(zef,'h_current_ES')
        delete(zef.h_current_ES)
        zef = rmfield(zef,'h_current_ES');
    end
end
if evalin('base','zef.ES_plot_type') == 2 
    if isfield(zef,'h_barplot_ES')
        delete(zef.h_barplot_ES)
        zef = rmfield(zef,'h_barplot_ES');
        close(gcf);
    end
end
if evalin('base','zef.ES_plot_type') == 3
    if isfield(zef,'h_colorbar_ES')
        delete(zef.h_colorbar_ES)
        zef = rmfield(zef,'h_colorbar_ES');
        close(gcf);
    end
end