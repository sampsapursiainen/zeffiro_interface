classdef ZeffiroInterface < handle

    % ZeffiroInterface
    %
    % The front-end class of the application. Holds onto the GUI components
    % and a Zef object, which functions as the back-end of the program and
    % whose methods the callbacks of this GUI calls.

    properties

        zef app.Zef
        segmentation_tool app.SegmentationTool
        mesh_tool app.MeshTool
        mesh_visualization_tool app.MeshVisualizationTool
        figure_tool app.FigureTool

    end % properties

    methods

        function application = ZeffiroInterface(varargin)

            % ZeffiroInterface
            %
            % The constructor of ZeffiroInterface. Sets the properties
            % contained in properties by calling their respective
            % constructors.

            % The object that contains all the numerical data and mathematical
            % methods.

            application.zef = app.Zef(varargin{:});

            % The segmentation tool window object.

            application.segmentation_tool = app.SegmentationTool(application.zef, varargin{:});

            % The mesh tool window object.

            application.mesh_tool = app.MeshTool(application.zef, varargin{:});

            % The visualization tool window object.

            application.mesh_visualization_tool = app.MeshVisualizationTool(application.zef, varargin{:});

            % The figure tool window object.

            application.figure_tool = app.FigureTool(application.zef, varargin{:});

        end

    end % methods

    methods (Static)
    end % methods (Static)

end % classdef
