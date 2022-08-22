classdef SegmentationTool

    % SegmentationTool
    %
    % Holds most of the general settings of Zeffiro Interface. Plugin tools
    % are also accessed via this window, via the menu bar.

    properties

        zef app.Zef

        % Other properties here.

    end % properties

    methods

        function tool = SegmentationTool(zef, varargin)

            tool.zef = zef;

        end

    end % methods

end % SegmentationTool
