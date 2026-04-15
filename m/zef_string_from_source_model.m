function str = zef_string_from_source_model(input)

% Converts a zeffiro.SourceModel input into a character array.

switch input
    case zeffiro.SourceModel.Error
        str = 'Error';
    case zeffiro.SourceModel.Whitney
        str = 'Whitney';
    case zeffiro.SourceModel.Hdiv
        str = 'H(div)'
    otherwise
        warning("Did not receive a valid zeffiro.SourceModel. Returning Error.")
        str = 'Error';
end
end
