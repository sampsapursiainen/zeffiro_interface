% zef.reconstructionTool.currentInfo=cell(1,5);
%
%
% if ~isfield(zef, 'reconstruction_information')
%     zef.reconstruction_information=[];
% end
%
%
% if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'tag')
%     zef.reconstructionTool.currentInfo{1}=zef.reconstruction_information.tag;
% else
%     zef.reconstructionTool.currentInfo{1}='';
% end
%
% if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'type')
%     zef.reconstructionTool.currentInfo{2}=zef.reconstruction_information.type;
% else
%     zef.reconstructionTool.currentInfo{2}='?';
% end
%
% if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'modality')
%     zef.reconstructionTool.currentInfo{3}=zef.reconstruction_information.modality;
% else
%     zef.reconstructionTool.currentInfo{3}='?';
% end
%
%
% if iscell(zef.reconstruction)
%     zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 1);
% else
%     zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 2);
% end
%
% if iscell(zef.reconstruction) && zef.reconstructionTool.currentInfo{4}>=1
%     zef.reconstructionTool.currentInfo{5}=(size(zef.reconstruction{1}, 1));
% else %is either empty cell or single frame
%     zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction,1);
% end
%
%
% zef.reconstructionTool.app.current.Data=zef.reconstructionTool.currentInfo;

%%

%if ~isfield(zef.reconstructionTool, 'currentInfo')
    zef.reconstructionTool.currentInfo=cell(1,6);

    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'tag')
        zef.reconstructionTool.currentInfo{1}=zef.reconstruction_information.tag;
    else
        zef.reconstructionTool.currentInfo{1}='tag';
    end

    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'type')
        zef.reconstructionTool.currentInfo{2}=zef.reconstruction_information.type;
    else
        zef.reconstructionTool.currentInfo{2}='';
    end

    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'modality')
        zef.reconstructionTool.currentInfo{3}=zef.reconstruction_information.modality;
    else
        zef.reconstructionTool.currentInfo{3}='';
    end

    if iscell(zef.reconstruction)
    zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 1);
    else
        zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 2);
    end

    if iscell(zef.reconstruction) && zef.reconstructionTool.currentInfo{4}>=1
        zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction{1}, 1);
    else %is either empty cell or single frame
        zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction,1);
    end

    if isfield(zef, 'lead_field_id')
        zef.reconstructionTool.currentInfo{6}=zef.lead_field_id;
    else
        zef.reconstructionTool.currentInfo{6}='no ID';
    end

%end

zef.reconstructionTool.app.current.Data=zef.reconstructionTool.currentInfo;
