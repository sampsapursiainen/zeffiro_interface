function self = refine_surface(self, n_of_refinements)

% Zef.refine_surface
%
% Refines active compartment surfaces a given number of times.
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

        n_of_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

    end

    self.n_of_surface_refinements = n_of_refinements;

    for n = 1 : self.n_of_surface_refinements

        % TODO

    end

end
