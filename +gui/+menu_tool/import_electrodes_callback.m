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

    filter = { '*.dat', 'DAT files' ; '*.csv', 'CSV files' } ;

    [name, path] = uigetfile ( filter, "Import electrodes from .dat or .csv" ) ;

    % If user presses "Cancel", return early.

    if name == 0 || path == 0

        return

    end

    abspath = fullfile ( path, name ) ;

    [ ~, ~, extension ] = fileparts ( abspath ) ;

    if extension == ".dat"

        try

            [ electrode_data, electrode_labels ] = import.electrodes_from_dat ( abspath ) ;

        catch err

            msg = err.message ;

            title_str = "Could not read DAT file." ;

            fig = errordlg ( msg, title_str ) ;

            uiwait ( fig ) ;

            return

        end

    elseif extension == ".csv"

        try

            [ electrode_data, electrode_labels ] = import.electrodes_from_csv ( abspath ) ;

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

    zef.sensors = electrode_data ;

    zef.s2_name_list = electrode_labels ;

end % function
