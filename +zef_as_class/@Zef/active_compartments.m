function compartments = active_compartments(self)

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

    active_inds = find(activities);

    compartments = self.compartments(active_inds);

end
