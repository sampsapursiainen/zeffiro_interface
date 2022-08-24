classdef SegmentationTool < handle

    % SegmentationTool
    %
    % Holds most of the general settings of Zeffiro Interface. Plugin tools
    % are also accessed via this window, via the menu bar.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        % Other properties here.

    end % properties

    methods

        function self = SegmentationTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Segmentation Tool');

        end

    end % methods

end % SegmentationTool
