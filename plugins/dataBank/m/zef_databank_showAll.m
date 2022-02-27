function [info,columnNames, hashList] = zef_databank_showAll(tree, type)

%get all hashes of type nodes
% this will add a tiny bit of runtime, but makes the funtion more readable

info=cell(0,0);
columnNames=cell(0,0);

dbFieldNames=fieldnames(tree);
hashList=cell(0,0);

for i=1:length(dbFieldNames)
    if strcmp(tree.(dbFieldNames{i}).type, type)
        hashList{end+1}=dbFieldNames{i};
    end
end

for i=1:length(hashList)

    switch type

        case 'leadfield'
            info{i,1}=tree.(hashList{i}).data.imaging_method;
            [info{i, 2}, info{i, 3}]=zef_size(tree.(hashList{i}).data, 'L');

        case 'data'
            [info{i, 1}, info{i, 2}]=zef_size(tree.(hashList{i}).data, 'measurements');

        case 'reconstruction'
            reconstruction_information=tree.(hashList{i}).data.reconstruction_information;

            info{i,1}=reconstruction_information.tag;
            if isfield(reconstruction_information, 'type')
                info{i,2}=reconstruction_information.type;
            else
                info{i,2}='';
            end
             [info{i, 3}, info{i, 4}]=zef_size(tree.(hashList{i}).data, 'reconstruction');

        case 'gmm'

    end

end

%set columnNames

switch type

        case 'leadfield'
            columnNames={'type', 'sensors', 'sources'};

        case 'data'
            columnNames={'sensors', 'samples'};

        case 'reconstruction'
            columnNames={'tag', 'type', 'samples', 'sources'};

        case 'gmm'

end

