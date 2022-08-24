classdef MeshTool < handle

    % MeshTool
    %
    % A tool for building finite element meshes and initiating lead field
    % generation.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        layout matlab.ui.container.GridLayout

        leftlayout matlab.ui.container.GridLayout

        leftlayout1 matlab.ui.container.GridLayout

        leftlayout2 matlab.ui.container.GridLayout

        leftlayout3 matlab.ui.container.GridLayout

        rightlayout matlab.ui.container.GridLayout

        rightlayout1 matlab.ui.container.GridLayout

        rightlayout2 matlab.ui.container.GridLayout

        rightlayout3 matlab.ui.container.GridLayout

    end % properties

    methods

        function self = MeshTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Mesh Tool');

            % Create layouts

            self.layout = uigridlayout(self.tab, [1,2], 'Scrollable', 'on');

            self.leftlayout = uigridlayout(self.layout, [3,1]);

            self.leftlayout1 = uigridlayout(self.leftlayout, [3,2]);

            self.leftlayout2 = uigridlayout(self.leftlayout, [2,4]);

            self.leftlayout3 = uigridlayout(self.leftlayout, [3,6]);

            self.rightlayout = uigridlayout(self.layout, [3,1]);

            self.rightlayout1 = uigridlayout(self.rightlayout, [3,1]);

            self.rightlayout2 = uigridlayout(self.rightlayout, [3,1]);

            self.rightlayout3 = uigridlayout(self.rightlayout, [3,1]);

            % Place widgets into layouts

        end

    end % methods

end % MeshTool
