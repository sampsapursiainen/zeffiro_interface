function self = from_ascii_files ( self, files, io_descriptor )
%
% self = from_ascii_files ( self, files )
%
% Constructs a surface segmentation from a given set of files.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        files (:,1) string { mustBeFile }
        io_descriptor (1,1) double { mustBePositive, mustBeInteger } = utilities.fopen_devnull
    end

    for ii = 1 : numel ( files )

        fn = files ( ii ) ;

        self = self.from_ascii_file ( fn, io_descriptor ) ;

    end % for

end % function
