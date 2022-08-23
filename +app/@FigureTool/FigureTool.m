classdef FigureTool < handle

    % FigureTool
    %
    % A canvas for displaying visualizations after their settings have been
    % adjusted in MeshVisualizationTool.

    properties

        zef app.Zef

        % Other properties here.

    end % properties

    methods

        function self = FigureTool(zef, varargin)

            self.zef = zef;

        end

    end % methods

end % FigureTool
