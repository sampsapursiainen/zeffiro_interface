function tetra_inds = tetra_inds_in_compartment(self, compartments)

    %
    % tetra_inds_in_compartment
    %
    % Get the indices of the tetrahedra in a given compartment index array.
    % Requires that self.label_mesh has been run since the last mesh
    % generation.
    %
    % Inputs:
    %
    % - self
    %
    %   The instance of Zef that called this method, with mesh labeling
    %   performed.
    %
    % - compartments
    %
    %   An array of compartment indices, whose tetra indices one wishes to
    %   retrieve.
    %

    arguments

        self zef_as_class.Zef

        compartments (:,1) double { mustBePositive, mustBeInteger }

    end

    tetra_inds = find(ismember(self.domain_labels, compartments));

end
