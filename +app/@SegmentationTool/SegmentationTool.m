classdef SegmentationTool < handle

    % SegmentationTool
    %
    % Holds most of the general settings of Zeffiro Interface. Plugin tools
    % are also accessed via this window, via the menu bar.

    properties

        zef app.Zef

        window matlab.ui.Figure

        % Other properties here.

    end % properties

    methods

        function self = SegmentationTool(zef, varargin)

            self.zef = zef;

            self.window = figure('MenuBar','none', 'NumberTitle', 'off', ...
                'Name', 'Zeffiro Interface: Segmentation Tool');

        end

    end % methods

end % SegmentationTool
