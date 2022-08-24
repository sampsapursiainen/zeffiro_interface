classdef SegmentationTool < handle

    % SegmentationTool
    %
    % Holds most of the general settings of Zeffiro Interface. Plugin tools
    % are also accessed via this window, via the menu bar.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        layout matlab.ui.container.GridLayout

        profilelayout matlab.ui.container.GridLayout

        profilelabel matlab.ui.control.Label

        profiledropdown matlab.ui.control.DropDown

        taglabel matlab.ui.control.Label

        tagdropdown matlab.ui.control.DropDown

        compartment_table matlab.ui.control.Table

        infotable matlab.ui.control.Table

    end % properties

    properties (Constant)

        INFOTABLE_DEFAULT_CONTENT = [
            "App folder" "None";
            "Current path" "None";
            "Project file" "None";
            "Project folder" "None";
            "Project size" "None"
        ];

    end % properties (Constant)

    methods

        function self = SegmentationTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Segmentation Tool');

            self.layout = uigridlayout(self.tab, [4,1]);

            self.profilelayout = uigridlayout(self.layout, [1,4]);

            self.profilelabel = uilabel(self.profilelayout, 'Text', 'Profile');

            self.profiledropdown = uidropdown(self.profilelayout);

            self.taglabel = uilabel(self.profilelayout, 'Text', 'Project tag');

            self.tagdropdown = uidropdown(self.profilelayout);

            self.compartment_table = uitable(self.layout, ...
                'ColumnName', { ...
                    'ID', 'On', 'Name', 'Visible', 'Surface nodes', ...
                    'Surface triangles', 'Merge', 'Invert normal', ...
                    'Activity', 'Electrical conductivity'
            });

            self.infotable = uitable(self.layout, ...
                'ColumnName', { 'Field','Value' }, ...
                'Data', app.SegmentationTool.INFOTABLE_DEFAULT_CONTENT ...
            );

        end

    end % methods

end % SegmentationTool
