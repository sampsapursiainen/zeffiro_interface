function tetra_inds = active_tetra_inds(self)

    %
    % active_tetra_inds
    %
    % Gets the indices of active tetra based on the labeling performed by
    % self.label_mesh.
    %
    % Input:
    %
    % - self
    %
    %   The instance of Zef that called this method, that must have performed
    %   a labeling of the tetra in the mesh beforehand.
    %
    % Output:
    %
    % - tetra_inds
    %
    %   The indices of the active tetra, again asuming they have been labeled
    %   correctly.
    %

    arguments

        self zef_as_class.Zef

    end

    tetra_inds = ismember(self.domain_labels, self.active_compartment_inds);

end
