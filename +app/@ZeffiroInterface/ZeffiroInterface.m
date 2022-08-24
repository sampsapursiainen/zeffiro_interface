classdef ZeffiroInterface < matlab.apps.AppBase

    % ZeffiroInterface
    %
    % The front-end class of the application. Holds onto the GUI components
    % and a Zef object, which functions as the back-end of the program and
    % whose methods the callbacks of this GUI calls.

    properties

        zef app.Zef

        window matlab.ui.Figure

        layout matlab.ui.container.GridLayout

        tabs matlab.ui.container.TabGroup

        segmentation_tool app.SegmentationTool

        mesh_tool app.MeshTool

        mesh_visualization_tool app.MeshVisualizationTool

        figure_tool app.FigureTool

    end % properties

    methods

        function self = ZeffiroInterface(varargin)

            % ZeffiroInterface
            %
            % The constructor of ZeffiroInterface. Sets the properties
            % contained in properties by calling their respective
            % constructors.

            % The object that contains all the numerical data and mathematical
            % methods.

            self.zef = app.Zef(varargin{:});

            % The main window of the application.

            self.window = uifigure('Name', 'Zeffiro Interface');

            self.window.Position(3:4) = [800, 600];

            % Attach layput manager to main window.

            self.layout = uigridlayout(self.window, [1,1]);

            % Tab group for the different components of the application.

            self.tabs = uitabgroup(self.layout, 'Units', 'Normalized');

            % The segmentation tool window object.

            self.segmentation_tool = app.SegmentationTool(self.zef, self.tabs, varargin{:});

            % The mesh tool window object.

            self.mesh_tool = app.MeshTool(self.zef, self.tabs, varargin{:});

            % The visualization tool window object.

            self.mesh_visualization_tool = app.MeshVisualizationTool(self.zef, self.tabs, varargin{:});

            % The figure tool window object.

            self.figure_tool = app.FigureTool(self.zef, self.tabs, varargin{:});

        end

    end % methods

    methods (Static)
    end % methods (Static)

end % classdef
