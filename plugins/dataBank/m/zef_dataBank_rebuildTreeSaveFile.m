function [tree] = zef_dataBank_rebuildTreeSaveFile(tree)

%tree is sorted and rebuild, but the names and hashes of the nodes might
%longer match the names of the save files.
%rename the old files to tmp-files, then rename them to the new names
%(avoids overwriting) and renew the node matfiles
% IF the hash and filename do not match

hashes=fieldnames(tree);

if length(hashes)>=1
    folder=extractBefore(tree.(hashes{1}).data.Properties.Source, strcat(filesep, 'node_'));
    folder=strcat(folder, filesep);
end

for i=1:length(hashes)

    nameOfSaveFile=reverse(extractBetween(reverse(tree.(hashes{i}).data.Properties.Source),'.', filesep));
    nameOfSaveFile=nameOfSaveFile{1};

    if ~strcmp(hashes{i}, nameOfSaveFile)
       complNameOfSaveFile=tree.(hashes{i}).data.Properties.Source;
       complNameOfTMPSaveFile=strcat(folder, nameOfSaveFile, '_temporaryDataBankFile.mat');
       movefile(complNameOfSaveFile, complNameOfTMPSaveFile);

    end

end

for i=1:length(hashes)

    nameOfSaveFile=reverse(extractBetween(reverse(tree.(hashes{i}).data.Properties.Source),'.', filesep));
    nameOfSaveFile=nameOfSaveFile{1};

    if ~strcmp(hashes{i}, nameOfSaveFile)
       complNameOfSaveFile=strcat(folder, hashes{i}, '.mat') ;
       complNameOfTMPSaveFile=strcat(folder, nameOfSaveFile, '_temporaryDataBankFile.mat');
       movefile(complNameOfTMPSaveFile, complNameOfSaveFile);
       tree.(hashes{i}).data=matfile(complNameOfSaveFile);

    end

end

end

