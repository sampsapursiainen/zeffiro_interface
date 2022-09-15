function self = refine_volume_adaptively(self, n_of_refinements, tolerance, iteration_param)

% Zef.refine_volume_adaptively
%
% Refines active compartment volumes adaptively a given number of times.
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
% - tolerance
%
%   The adaptive tolerance that is to be used.
%
%   default = 1
%
% - iteration_param
%
%   The iteration parameter of the adaptive routine.
%
%   default = 10
%
% Output
%
% - self
%
%   The Zef object that called the method.

    arguments

        self zef_as_class.Zef

        n_of_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        tolerance (1,1) double  { mustBeReal, mustBePositive } = 1;

        iteration_param (1,1) double { mustBeInteger, mustBePositive } = 10;

    end

    % Set refinement parameters.

    self.mesh_generation_phase = "adaptive refinement";

    self.n_of_adaptive_volume_refinements = n_of_refinements;

    self.adaptive_refinement_thresh_val = tolerance;

    self.adaptive_refinement_k_param = iteration_param;

    for n = 1 : self.n_of_adaptive_volume_refinements

        % TODO

    end

end
