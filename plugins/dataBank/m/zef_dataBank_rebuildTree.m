function [newtree] = zef_dataBank_rebuildTree(tree)


hashes=fieldnames(tree);
list=cell(length(hashes));


newtree=[];

newtree.(zef_dataBank_number2hash(1))=tree.(hashes{1});
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
    newtree.(zef_dataBank_number2hash(index))=tree.(hashes{i});
    newtree.(zef_dataBank_number2hash(index)).hash=zef_dataBank_number2hash(index);
    
end







end






