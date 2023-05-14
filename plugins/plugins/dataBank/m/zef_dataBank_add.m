function [tree, hash] = zef_dataBank_add(tree, parentHash, data)

%getData (before!)

%make new node

%identify parent
%add to parent

%update gui other function

node=[];
node.data=data;
node.type=data.type;
node.name=data.type;

if strcmp(data.type, 'reconstruction') && isfield(node.data, 'reconstruction_information') && isfield(node.data.reconstruction_information, 'tag')
    node.name=strcat('rec-', node.data.reconstruction_information.tag);
end

i=1;
while isfield(tree, strcat(parentHash, '_', num2str(i)))
i=i+1;
end
hash=strcat(parentHash, '_', num2str(i));

node.hash=hash;
tree.(hash)=node;

end
