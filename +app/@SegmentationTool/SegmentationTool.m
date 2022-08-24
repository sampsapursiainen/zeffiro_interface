classdef SegmentationTool < handle

    % SegmentationTool
    %
    % Holds most of the general settings of Zeffiro Interface. Plugin tools
    % are also accessed via this window, via the menu bar.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        layout matlab.ui.container.GridLayout

    end % properties

    methods

        function self = SegmentationTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Segmentation Tool');

            self.layout = uigridlayout(self.tab, [1,1]);

        end

    end % methods

end % SegmentationTool
