function self = load_from_file(filepath)

    % load_from_file
    %
    % Loads a Zeffiro Interface project file and generates an instance of Zef
    % from it by calling the constructor of the class.

    arguments
        filepath string
    end

    if isfile(filepath)

        data = load(filepath);

        if isfield(data, 'zef_data')
            zef_data = data.zef_data;
        else
            warning('Could not find zef_data within the given pickle file. Setting Zef.data field as an empty struct.')
            zef_data = struct;
        end

    else
        warning('Given file does not exist. Setting Zef.data field as an empty struct.')
        zef_data = struct;
    end

    self = app.Zef(zef_data);

end % function
