function self = load_from_file(filepath)

    % load_from_file
    %
    % Loads a Zeffiro Interface project file and generates an instance of Zef
    % from it by calling the constructor of the class.

    arguments
        filepath string
    end

    if isfile(filepath)

        zef_data = load(filepath);

    else
        warning('Given file does not exist. Setting Zef.data field as an empty struct.')
        zef_data = struct;
    end

    self = zef_as_class.Zef(zef_data);

end % function
