function [struct_out] = zef_dataBank_text2struct(text)

struct_out=[];
for i=1:length(text)
    struct_out.(text{i})=[];
end

end

