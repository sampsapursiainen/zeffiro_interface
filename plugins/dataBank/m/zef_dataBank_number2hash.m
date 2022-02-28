function [hash]=zef_dataBank_number2hash(number)
%x is an array of numbers, we will add
% nodes and _

hash='node';
for i=1:length(number)
    if ~isnan(number(i)) && ~number(i)==0
    hash=strcat(hash, '_', num2str(number(i)));
    end
end

end
