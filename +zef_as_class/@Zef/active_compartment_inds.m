function compartment_inds = active_compartment_inds(self)

    %
    % active_compartments
    %
    % Returns an array of compartments that are active.
    %
    % Input:
    %
    % - self
    %
    %   The instance of Zef that called this method.
    %
    % Output:
    %
    % - compartments
    %
    %   The active compartments in a vector.
    %

    arguments

        self zef_as_class.Zef

    end

    active_fn = @(c) c.is_on;

    activities = arrayfun(active_fn, self.compartments);

    compartment_inds = find(activities);

end
