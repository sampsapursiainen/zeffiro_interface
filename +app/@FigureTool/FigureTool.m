classdef FigureTool < handle

    % FigureTool
    %
    % A canvas for displaying visualizations after their settings have been
    % adjusted in MeshVisualizationTool.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

    end % properties

    methods

        function self = FigureTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Figure Tool');

        end

    end % methods

end % FigureTool
