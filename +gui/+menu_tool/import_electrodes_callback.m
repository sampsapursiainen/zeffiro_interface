function zef = import_electrodes_callback(zef)
%
% import_electrodes_fn
%
% The callback called by Menu tool > Import > Import elecrodes. Adds the
% fields "sensors" and "s2_name_list" to the given zef struct.
%

    arguments

        zef (1,1) struct

    end

    [name, path] = uigetfile ( ["*.dat", "*.csv"], "Import electrodes from .dat or .csv" ) ;

    abspath = fullfile ( path, name ) ;

    [ ~, ~, extension ] = fileparts ( abspath ) ;

    if extension == ".dat"

        [ electrode_data, electrode_labels ] = import.electrodes_from_dat ( abspath ) ;

    elseif extension == ".csv"

        [ electrode_data, electrode_labels ] = import.electrodes_from_csv ( abspath ) ;

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
