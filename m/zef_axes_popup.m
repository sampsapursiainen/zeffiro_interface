function zef = zef_axes_popup(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.h_figure_aux = gcf;
zef.h_zeffiro_axes_popup = figure(...
    'PaperUnits',get(0,'defaultfigurePaperUnits'),...
    'Units','normalized',...
    'Position',[zef.h_zeffiro.Position(1)+zef.h_zeffiro.Position(3) zef.h_zeffiro.Position(2)  zef.h_zeffiro.Position(3)  zef.h_zeffiro.Position(4)],...
    'Renderer',get(0,'defaultfigureRenderer'),...
    'Visible',zef.use_display,...
    'Color',get(0,'defaultfigureColor'),...
    'CloseRequestFcn','closereq;',...
    'CurrentAxesMode','manual',...
    'IntegerHandle','off',...
    'NextPlot',get(0,'defaultfigureNextPlot'),...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'DoubleBuffer','off',...
    'MenuBar','figure',...
    'ToolBar','figure',...
    'Name','ZEFFIRO Interface: Figure tool axes popup',...
    'NumberTitle','off',...
    'HandleVisibility','on',...
    'Tag','figure_tool_axes_popup',...
    'UserData',[],...
    'WindowStyle',get(0,'defaultfigureWindowStyle'),...
    'Resize',get(0,'defaultfigureResize'),...
    'PaperPosition',get(0,'defaultfigurePaperPosition'),...
    'PaperSize',[20.99999864 29.69999902],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'InvertHardcopy',true,...
    'ScreenPixelsPerInchMode','manual' );

zef.h_object_aux_new = copyobj(findobj(zef.h_figure_aux.Children,'Tag','axes1','-or','Type','colorbar'),zef.h_figure_aux);
for zef_i = 1 : length(zef.h_object_aux_new)
    if isequal(zef.h_object_aux_new(zef_i).Tag,'axes1')
        zef.h_object_aux_new(zef_i).Parent = zef.h_zeffiro_axes_popup;
        zef.h_object_aux_new(zef_i).Units = 'normalized';
        zef.h_object_aux_new(zef_i).OuterPosition  = [0.2 0.2 0.6 0.6];
    end
end
for zef_i = 1 : length(zef.h_object_aux_new)
    if isequal(zef.h_object_aux_new(zef_i).Type,'colorbar')
        zef.h_object_aux_new(zef_i).Parent = zef.h_zeffiro_axes_popup;
    end
end

zef = rmfield(zef,{'h_figure_aux','h_object_aux_new'});

clear zef_i

if nargout == 0
    assignin('base','zef',zef);
end

end
