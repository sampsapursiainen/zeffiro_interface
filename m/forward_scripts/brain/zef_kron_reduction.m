function out_reduced_interpolation_matrix = zef_kron_reduction( ...
    in_interpolation_matrix, ...
    in_schur_complement, ...
    in_electrode_model, ...
    in_source_model ...
)

    % Documentation
    %
    % Performs a Kron reduction on a given interpolation matrix G. In
    % practical terms, this might mean simplifying the structure of the
    % interpolation matrix, such that the remaining graph relation is still
    % equivalent to the original one.
    %
    % Input:
    %
    % - in_interpolation_matrix: the matrix being reduced.
    %
    % - in_schur_compement: this is applied to in_interpolation_matrix to
    %   reduce its sturcture.
    %
    % - in_electrode_model: if this is not 'CEM' but 'PEM', the matrix is
    %   returned as-is. Has to be one of these options.
    %
    % Output:
    %
    % - out_reduced_interpolation_matrix: the reduced (Complete Electrode
    %   Model) or unreduced (Partial Elecrode Model) interpolation matrix.

    arguments
        in_interpolation_matrix
        in_schur_complement
        in_electrode_model { mustBeText, mustBeMember(in_electrode_model, {'CEM', 'PEM'}) }
        in_source_model { mustBeA(in_source_model, ["ZefSourceModel"]) }
    end

    out_reduced_interpolation_matrix = in_interpolation_matrix;

    schur_size = size(in_schur_complement);

    if strcmp(in_electrode_model,'CEM')

        switch in_source_model

            case { ZefSourceModel.Whitney, ZefSourceModel.Hdiv }

                inv_schur_complement = in_schur_complement \ eye(schur_size);

                out_reduced_interpolation_matrix = ...
                    inv_schur_complement ...
                    * ...
                    in_interpolation_matrix ...
                ;

            case ZefSourceModel.StVenant

                % Do nothing. TODO: check whether St. Venant should also
                % trigger the reduction.

            otherwise

                error("Unknown source model. Should be one of ZefSourceModel.{Whitney, Hdiv, StVenant}");

        end
    end
end
