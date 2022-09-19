function self = refine_volume(self, n_of_refinements)

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

        n_of_refinements (:,1) double { mustBeInteger, mustBeNonnegative } = zeros(numel(self.compartments) + 1, 1);

    end

    self.mesh_generation_phase = "refinement";

    for n = 1 : self.n_of_volume_refinements

        % TODO

    end

end
