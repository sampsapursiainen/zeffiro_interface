function self = refine_volume(self, meshgen_stage, n_of_refinements)

% Zef.refine_volume
%
% Refines active compartment volumes a given number of times.
%
% Inputs:
%
% - self
%
%   The Zef object calling this method.
%
% - meshgen_stage
%
%   Tells whether the refinement occurs during mesh generation or
%   post-processing. Must be one of {"mesh generation", "post-processing"}.
%
% - n_of_refinements
%
%   The number of refinements that are to be performed.
%
%   default = 1
%
% Output
%
% - self
%
%   The Zef object that called the method.

    arguments

        self zef_as_class.Zef

        meshgen_stage (1,1) string { mustBeMember(meshgen_stage, ["mesh generation","post-processing"]) }

        n_of_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

    end

    self.n_of_volume_refinements = n_of_refinements;

    for n = 1 : self.n_of_volume_refinements

        % TODO

    end

end
