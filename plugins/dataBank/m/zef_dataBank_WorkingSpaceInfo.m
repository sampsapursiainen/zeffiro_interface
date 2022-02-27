function [info, columnNames] = zef_dataBank_WorkingSpaceInfo(tree, hash)

columnNames={'hash', 'node type', 'name'};
if ~iscell(hash)
    hash={hash};
end
info=cell(length(hash), 3);

for i=1:length(hash)

    info{i,1}=hash{i};
    info{i,2}=tree.(hash{i}).type;
    info{i,3}=tree.(hash{i}).name;

end

end

