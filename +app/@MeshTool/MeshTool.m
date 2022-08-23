classdef MeshTool < handle

    % MeshTool
    %
    % A tool for building finite element meshes and initiating lead field
    % generation.

    properties

        zef app.Zef

        window matlab.ui.Figure

        % Other properties here.

    end % properties

    methods

        function self = MeshTool(zef, varargin)

            self.zef = zef;

            self.window = uifigure('Name', 'Zeffiro Interface: Mesh Tool');

        end

    end % methods

end % MeshTool
