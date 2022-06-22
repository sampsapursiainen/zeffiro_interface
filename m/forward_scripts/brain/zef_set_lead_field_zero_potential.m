function out_L = zef_set_lead_field_zero_potential( ...
    in_L, ...
    in_electrodes ...
)

    % Documentation
    %
    % Sets the zero potential level of a given lead field based on a given set
    % of electrodes.
    %
    % Input:
    %
    % - in_L:
    %
    %   The lead field matrix whose zero potential level we are adjusting.
    %
    % - in_electrodes:
    %
    %   The electrodes according to which we are setting the potential levels.
    %
    % Output:
    %
    % - out_L:
    %
    %   The lead field in_L after the zero potential level has been set.

    arguments
        in_L double
        in_electrodes double
    end

    n_of_electrodes = size(in_electrodes, 1);

    zero_potential_setter = ...
        eye(n_of_electrodes,n_of_electrodes) ...
        - ...
        (1/n_of_electrodes) ...
        * ...
        ones(n_of_electrodes,n_of_electrodes) ...
    ;

    out_L = zero_potential_setter * in_L;

end
