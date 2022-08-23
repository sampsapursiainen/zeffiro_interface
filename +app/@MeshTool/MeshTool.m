classdef MeshTool < handle

    % MeshTool
    %
    % A tool for building finite element meshes and initiating lead field
    % generation.

    properties

        zef app.Zef

        % Other properties here.

    end % properties

    methods

        function tool = MeshTool(zef, varargin)

            tool.zef = zef;

        end

    end % methods

end % MeshTool
