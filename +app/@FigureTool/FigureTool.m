classdef FigureTool < handle

    % FigureTool
    %
    % A canvas for displaying visualizations after their settings have been
    % adjusted in MeshVisualizationTool.

    properties

        zef app.Zef

        window matlab.ui.Figure

        % Other properties here.

    end % properties

    methods

        function self = FigureTool(zef, varargin)

            self.zef = zef;

            self.window = uifigure('Name', 'Zeffiro Interface: Figure Tool');

        end

    end % methods

end % FigureTool
