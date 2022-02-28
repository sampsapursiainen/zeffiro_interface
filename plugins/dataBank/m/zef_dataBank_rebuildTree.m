function [newtree] = zef_dataBank_rebuildTree(tree)

%nargin==1 means a normal tree that was not saved to disk. The other files
%are needed to give a new savefile and an ordered hashList
hashes=fieldnames(tree);
newtree=struct;

% list=cell(length(hashes));

if ~isempty(hashes)

    newtree.(zef_dataBank_number2hash(1))=tree.(hashes{1});
    newtree.(zef_dataBank_number2hash(1)).hash=zef_dataBank_number2hash(1);

    index=1;
    for i=2:length(hashes)
        num=(regexp(hashes{i}, '(?<num>\d+)'));

        if length(num)==length(index)
            index(end)=index(end)+1;

        else
            if length(num)<length(index)
                index=index(1:length(num));
                index(end)=index(end)+1;

            else
                index(end+1)=1;
            end
        end
        %node=tree.(hashes{i}); %this is needed for the matfile
        %node.hash=zef_dataBank_number2hash(index);
        % newtree.(zef_dataBank_number2hash(index))=node;

        newtree.(zef_dataBank_number2hash(index))=tree.(hashes{i});
        newtree.(zef_dataBank_number2hash(index)).hash=zef_dataBank_number2hash(index);

    end

end

end

