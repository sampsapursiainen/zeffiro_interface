function self = from_ascii_folder ( self, folder, io_descriptor )

    arguments

        self (1,1) core.FreeSurferSegmentation

        folder (1,1) string { mustBeFolder }

        io_descriptor (1,1) double { mustBePositive, mustBeInteger } = utilities.fopen_devnull

    end

    self = self.preallocate_from_ascii_folder ( folder ) ;

    ascii_structs = dir ( fullfile ( folder, "*.asc" ) ) ;

    if isrow ( { ascii_structs.name } )

        ascii_names = transpose ( { ascii_structs.name } ) ;

    end

    ascii_paths = string ( fullfile ( folder, ascii_names ) ) ;

    for ii = 1 : numel ( ascii_paths )

        self = self.from_ascii_file ( ascii_paths ( ii ), io_descriptor ) ;

    end

end % function
