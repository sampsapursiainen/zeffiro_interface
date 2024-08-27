function [ absFilePaths, dirs, names, suffixes ] = fileParts (filePattern)
%
% [ absFilePaths, dirs, names, suffixes ] = fileParts (filePattern)
%
% Finds out the absolute paths, directories, names and suffixes of a set of
% files, specified via a string pattern recognized by the MATLAB function dir.
%

    dataFolderStructs = dir (filePattern) ;

    dataFileDirs = arrayfun ( @(entry) string (entry.folder), dataFolderStructs ) ;

    dataFileNames = arrayfun ( @(entry) string (entry.name), dataFolderStructs ) ;

    absFilePaths = fullfile ( dataFileDirs, dataFileNames ) ;

    [ dirs, names, suffixes ] = fileparts (absFilePaths) ;

end % function
