function zef = import_electrodes_callback(zef)
%
% import_electrodes_callback
%
% The callback called by Menu tool > Import > Import elecrodes. Adds the
% fields "sensors" and "s2_name_list" to the given zef struct, or overwrites
% them if they already exist. If the chosen input file could not be read, an
% error dialog is opened with the related error message.
%
% Inputs:
%
% - zef
%
%   The central Zeffiro struct.
%
% Outputs:
%
% - zef
%
%   The input struct, augmented with the fields "sensors" and "s2_name_list".
%

    arguments

        zef (1,1) struct

    end

    % Read file from user.

    filter = { '*.dat', 'DAT files' ; '*.csv', 'CSV files' } ;

    [name, path] = uigetfile ( filter, "Import electrodes from .dat or .csv" ) ;

    % Perform type conversion, because uigetfile is not type stable. Who
    % designed this...?

    name = string ( name ) ;

    path = string ( path ) ;

    % If user presses "Cancel", return early.

    if name == "0" || path == "0"

        return

    end

    abspath = fullfile ( path, name ) ;

    [ ~, ~, extension ] = fileparts ( abspath ) ;

    if extension == ".dat"

        try

            [ electrode_data, electrode_labels ] = zefCore.import.electrodes_from_dat ( abspath ) ;

        catch err

            msg = err.message ;

            title_str = "Could not read DAT file." ;

            fig = errordlg ( msg, title_str ) ;

            uiwait ( fig ) ;

            return

        end

    elseif extension == ".csv"

        try

            [ electrode_data, electrode_labels ] = zefCore.import.electrodes_from_csv ( abspath ) ;

        catch err

            msg = err.message ;

            title_str = "Could not read CSV file." ;

            fig = errordlg ( msg, title_str ) ;

            uiwait ( fig ) ;

            return

        end

    else

        msg = "The chosen file was not a .dat or .csv file." ;

        title_str = "Wrong file type" ;

        fig = errordlg ( msg, title_str ) ;

        uiwait ( fig ) ;

        return

    end

    % Generate correct field names.

    if isfield(zef, "current_sensors")

        name_field_prefix = zef.current_sensors ;

    else

        name_field_prefix = "s" ;

    end

    % Build needed zef field names and set data.

    name_field_name = name_field_prefix + "_name_list" ;

    points_field_name = name_field_prefix + "_points" ;

    zef.sensors = electrode_data ;

    zef.(points_field_name) = electrode_data (:,1:3) ;

    zef.(name_field_name) = electrode_labels ;

    % Set CEM data if available: column 4 is inner radii, column 5 is outer
    % radii and column 6 are the impedances.

    if size ( electrode_data, 2 ) == 6

        zef.(points_field_name) = [ ...
            zef.(points_field_name) ...
            electrode_data(:,4) ...
            electrode_data(:,5) ...
            electrode_data(:,6) ...
        ] ;

    end

    zef = zef_update ( zef ) ;

end % function
