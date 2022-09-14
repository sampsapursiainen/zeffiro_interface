function self = with_mesh_generation_stage(self, stage)

%
% with_mesh_generation_stage
%
% Sets the value of self.mesh_generation_stage to given stage, which is used
% to determine how the mesh is to be refined.
%
% Inputs:
%
% - self
%
%   A Zef instance.
%
% - stage
%
%   One of {"done", "initial", "post-processing"}
%
% Output:
%
% - self
%
%   The same Zef instance that was given as input.
%

    self.mesh_generation_stage = stage;

end
