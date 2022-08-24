classdef MeshTool < handle

    % MeshTool
    %
    % A tool for building finite element meshes and initiating lead field
    % generation.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        layout matlab.ui.container.GridLayout

    end % properties

    methods

        function self = MeshTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Mesh Tool');

            self.layout = uigridlayout(self.tab, [1,1], 'Scrollable', 'on');

        end

    end % methods

end % MeshTool
