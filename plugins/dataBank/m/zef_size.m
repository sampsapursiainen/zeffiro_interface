function [size1, size2] = zef_size(data, field)
%gives the size of the field in the data. If data is a matObject, it is
%given without loading the data. If data is just a struct, it just gives
%the size
%Works only with 2 dimensions!

if isobject(data)
    sizeOfField=size(data, field);
else
    sizeOfField=size(data.(field));
end

size1=sizeOfField(1);
size2=sizeOfField(2);

end

