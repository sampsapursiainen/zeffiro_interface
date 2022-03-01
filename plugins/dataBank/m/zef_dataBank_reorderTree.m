function [newtree, listOld, listNew] = zef_dataBank_reorderTree(tree)
%reorders the tree nodes so that the numberings starts at 1 and continues
%without jumping
%this is needed to rebuild the tree when things were deleted

%derive new hashList on this level

array=[];
arrayToGive=1;

N=length(fieldnames(tree));

listOld=cell(N,1);
listNew=cell(N,1);
listIndex=1;

while listIndex<=N

    hashes=fieldnames(tree);
    hashes=hashes(startsWith(hashes, zef_dataBank_number2hash(array)));

    if ~isempty(hashes)

        if length(hashes)==1
            %in this case, the node once had children, but now those are processed
            %Process this node and go up

            arrayToGive=arrayToGive(1:end-1);
            newtree.( zef_dataBank_number2hash(arrayToGive))=tree.(zef_dataBank_number2hash(array));
            newtree.( zef_dataBank_number2hash(arrayToGive)).hash=zef_dataBank_number2hash(arrayToGive);
            tree=rmfield(tree, zef_dataBank_number2hash( array));

            listOld{listIndex}=zef_dataBank_number2hash( array);
            listNew{listIndex}=zef_dataBank_number2hash(arrayToGive);
            listIndex=listIndex+1;

            arrayToGive(end)=arrayToGive(end)+1;
            array=array(1:end-1);

        else
            %the node has children. Sort them and process them one by one

            %find smallest number
            hashes=extractAfter( hashes,strcat(zef_dataBank_number2hash(array), '_'));

            numbers=NaN(length(hashes),1);
            for i=1:length(hashes)  %get the starting numbers numbers of all hashes
                %is either x or x_y
                if contains(hashes{i}, '_')
                    numbers(i)=str2double( extractBefore( hashes{i} ,'_') );
                else
                    numbers(i)=str2double(hashes{i});
                end
            end

            smallNumbers=find(numbers==min(numbers));

            if length(smallNumbers)==1 %in this case, the child is a node without children. Process it directly
                newtree.( zef_dataBank_number2hash(arrayToGive))=tree.(zef_dataBank_number2hash( [array, min(numbers)]));
                newtree.( zef_dataBank_number2hash(arrayToGive)).hash=zef_dataBank_number2hash(arrayToGive);

              if isstruct(tree)
              tree=rmfield(tree, zef_dataBank_number2hash( [array, min(numbers)]));
              end

                listOld{listIndex}=zef_dataBank_number2hash( [array, min(numbers)]);
                listNew{listIndex}=zef_dataBank_number2hash(arrayToGive);
                listIndex=listIndex+1;

                arrayToGive(end)=arrayToGive(end)+1; %same level
            else %the node has children on its own.  Go one level deeper

                array=[array min(numbers)];
                arrayToGive=[arrayToGive, 1];
            end

        end
    else %there are no more nodes to process on this level, go up
        array=array(1:end-1);
        arrayToGive=arrayToGive(1:end-1);
    end

end

end

