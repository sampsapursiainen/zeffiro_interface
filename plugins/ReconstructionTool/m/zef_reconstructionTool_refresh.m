zef.reconstructionTool.currentInfo=cell(1,5);


if ~isfield(zef, 'reconstruction_information')
    zef.reconstruction_information=[];
end


if isfield(zef, 'reconstruction_info') && isfield(zef.reconstruction_info, 'tag')
    zef.reconstructionTool.currentInfo{1}=zef.reconstruction_info;
else
    zef.reconstructionTool.currentInfo{1}='';
end

zef.reconstructionTool.currentInfo{2}='?';
zef.reconstructionTool.currentInfo{3}='?';

if iscell(zef.reconstruction)
    zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 1);
else
    zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 2);
end

if iscell(zef.reconstruction) && zef.reconstructionTool.currentInfo{4}>=1
    zef.reconstructionTool.currentInfo{5}=(size(zef.reconstruction{1}, 1));
else %is either empty cell or single frame
    zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction,1);
end


zef.reconstructionTool.app.current.Data=zef.reconstructionTool.currentInfo;