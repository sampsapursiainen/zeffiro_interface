function str = zef_string_from_source_model(input)

    % Converts a ZefSourceModel input into a character array.

    switch input
        case ZefSourceModel.Error
            str = 'Error';
        case ZefSourceModel.Whitney
            str = 'Whitney';
        case ZefSourceModel.Hdiv
            str = 'H(div)'
        otherwise
            warning("Did not receive a valid ZefSourceModel. Returning Error.")
            str = 'Error';
    end
end
