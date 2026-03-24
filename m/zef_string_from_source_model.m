function str = zef_string_from_source_model(input)

% Converts a zefCore.ZefSourceModel input into a character array.

switch input
    case zefCore.ZefSourceModel.Error
        str = 'Error';
    case zefCore.ZefSourceModel.Whitney
        str = 'Whitney';
    case zefCore.ZefSourceModel.Hdiv
        str = 'H(div)'
    otherwise
        warning("Did not receive a valid zefCore.ZefSourceModel. Returning Error.")
        str = 'Error';
end
end
