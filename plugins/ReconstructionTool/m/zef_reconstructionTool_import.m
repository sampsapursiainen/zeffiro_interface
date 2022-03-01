
function [reconstruction,reconstruction_information] = zef_reconstructionTool_import

[importName, importPath]=uigetfile('./', 'select reconstruction file', '*.mat');

reconstruction_information=[];
reconstruction=[];

load(strcat(importPath, importName));

if isempty(reconstruction_information)
    reconstruction_information.tag=importName;
end

end

