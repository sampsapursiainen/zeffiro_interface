classdef ZeffiroInterface < matlab.apps.AppBase

    % ZeffiroInterface
    %
    % The front-end class of the application. Holds onto the GUI components
    % and a Zef object, which functions as the back-end of the program and
    % whose methods the callbacks of this GUI calls.

    properties

        zef app.Zef

        window matlab.ui.Figure

        % Project menu

        projectmenu matlab.ui.container.Menu

        new_project_item matlab.ui.container.Menu

        open_project_item matlab.ui.container.Menu

        save_project_item matlab.ui.container.Menu

        save_project_as_item matlab.ui.container.Menu

        % Import menu

        importmenu matlab.ui.container.Menu

        % Export menu

        exportmenu matlab.ui.container.Menu

        volume_export_item matlab.ui.container.Menu

        segdata_export_item matlab.ui.container.Menu

        lf_export_item matlab.ui.container.Menu

        source_space_export_item matlab.ui.container.Menu

        sensor_export_item matlab.ui.container.Menu

        recons_export_item matlab.ui.container.Menu

        mesh_export_item matlab.ui.container.Menu

        % Edit menu

        editmenu matlab.ui.container.Menu

        % Inverse tools menu

        inversemenu matlab.ui.container.Menu

        % Forward tools menu

        forwardmenu matlab.ui.container.Menu

        % Multi tool menu

        multimenu matlab.ui.container.Menu

        % Settings menu

        settingsmenu matlab.ui.container.Menu

        % Help menu

        helpmenu matlab.ui.container.Menu

        doc_item matlab.ui.container.Menu

        about_item matlab.ui.container.Menu

        % Application components.

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

            % Project menu.

            self.projectmenu = uimenu(self.window, 'Text', '&Project');

            self.new_project_item = uimenu(self.projectmenu, 'Text', '&New project');

            self.open_project_item = uimenu(self.projectmenu, 'Text', '&Open project');

            self.save_project_item = uimenu(self.projectmenu, 'Text', '&Save project');

            self.save_project_as_item = uimenu(self.projectmenu, 'Text', '&Save project as...');

            % Import menu.

            self.importmenu = uimenu(self.window, 'Text', '&Import');

            % Export menu.

            self.exportmenu = uimenu(self.window, 'Text', '&Export');

            self.volume_export_item = uimenu(self.exportmenu, 'Text', '&Volume data');

            self.segdata_export_item = uimenu(self.exportmenu, 'Text', '&Segmentation data');

            self.lf_export_item = uimenu(self.exportmenu, 'Text', '&Lead field');

            self.source_space_export_item = uimenu(self.exportmenu, 'Text', '&Source space');

            self.sensor_export_item = uimenu(self.exportmenu, 'Text', '&Sensor data');

            self.recons_export_item = uimenu(self.exportmenu, 'Text', '&Reconstruction');

            self.mesh_export_item = uimenu(self.exportmenu, 'Text', '&FE mesh');

            % Edit menu.

            self.editmenu = uimenu(self.window, 'Text', '&Edit');

            % Forward menu.

            self.forwardmenu = uimenu(self.window, 'Text', '&Forward tools');

            % Inverse menu.

            self.inversemenu = uimenu(self.window, 'Text', '&Inverse tools');

            % Multi tool menu.

            self.multimenu = uimenu(self.window, 'Text', '&Multi tools');

            % Settings menu.

            self.settingsmenu = uimenu(self.window, 'Text', '&Settings');

            % Help menu.

            self.helpmenu = uimenu(self.window, 'Text', '&Help');

            self.doc_item = uimenu(self.helpmenu, 'Text', '&Documentation');

            self.about_item = uimenu(self.helpmenu, 'Text', '&About');

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
