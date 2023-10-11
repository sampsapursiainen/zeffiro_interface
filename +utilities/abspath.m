function abspaths = abspath ( files )
%
% abspath ( files )
%
% Returns a string array of absolute paths to a given set of files.
%
% Input:
%
% - files
%
%   The list of files you wish to get the absulte paths of.
%
% Output:
%
% - abspaths
%
%   A string array of the abslute paths.
%

    arguments

        files (:,1) string { mustBeFile }

    end

    fullpaths = fullfile ( files ) ;

    n_of_paths = numel ( fullpaths ) ;

    abspaths = repmat ( "", n_of_paths, 1 ) ;

    for ii = 1 : numel ( fullpaths )

        ff = fullpaths ( ii ) ;

        dd = dir ( ff ) ;

        folder = string ( dd.folder ) ;

        abspaths ( ii ) = fullfile ( folder, ff ) ;

    end

end % function
