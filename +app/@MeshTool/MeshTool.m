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

        function self = MeshTool(zef, varargin)

            self.zef = zef;

        end

    end % methods

end % MeshTool
