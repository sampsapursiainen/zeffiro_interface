function [data] =  zef_dataBank_getData(zef, type)

data=[];
data.type=type;

switch type

    case 'data'
        data.measurements=zef.measurements;

            case 'noisedata'
        data.noisedata=zef.noise_data;

    case 'reconstruction'
        if iscell(zef.reconstruction)
           data.reconstruction=zef.reconstruction;
        else
            data.reconstruction={zef.reconstruction};
        end
        data.reconstruction_information=zef.reconstruction_information;

    case 'leadfield'
        data.source_interpolation_ind = zef.source_interpolation_ind;
        data.parcellation_interp_ind = zef.parcellation_interp_ind;
        data.source_positions = zef.source_positions;
        data.source_directions = zef.source_directions;
        data.L = zef.L;
        data.sensors = zef.sensors;
        data.imaging_method = zef.imaging_method;
        data.noise_data = zef.noise_data;
        data.lf_tag = zef.lf_tag;
        data.source_structure = cell(0,0);
        for zef_ind=1:length(zef.compartment_tags)
            zef_name=strcat(zef.compartment_tags{zef_ind}, '_sources');
            data.source_structure{zef_ind}=zef.(zef_name);
        end

    case 'gmm'
        data.model = zef.GMM.model;
        data.dipoles = zef.GMM.dipoles;
        data.amplitudes = zef.GMM.amplitudes;
        data.time_variables = zef.GMM.time_variables;
        data.parameters = zef.GMM.parameters;

end

end

