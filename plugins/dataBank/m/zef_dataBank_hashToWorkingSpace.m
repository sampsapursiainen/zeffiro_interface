function [workingHashes] = zef_dataBank_hashToWorkingSpace(newHash, workingHashes)

if ~iscell(newHash)
    newHash={newHash};
end

if ~iscell(workingHashes)
    workingHashes={workingHashes};
end

for i=1:length(newHash)
    duplicate=0;
    for wh=1:length(workingHashes)

        if strcmp(newHash{i}, workingHashes{wh})
            duplicate=1;
        end

    end
    if ~duplicate
            workingHashes{end+1}=newHash{i};
    end

end

end

