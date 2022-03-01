
zef.LeadFieldProcessingTool.combineNew=true;
zef.LeadFieldProcessingTool.combinePoints=zef.LeadFieldProcessingTool.app.NoisestartSpinner.Value:zef.LeadFieldProcessingTool.app.NoiseendSpinner.Value;
zef.LeadFieldProcessingTool.combineData=[];
for zef_LeadFieldProcessingTool_index_combine=1:zef.LeadFieldProcessingTool.bankSize

    if zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_index_combine, 6}

        zef.LeadFieldProcessingTool.bank2auxIndex=zef_LeadFieldProcessingTool_index_combine;
        zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex;

        if zef.LeadFieldProcessingTool.combineNew
            zef.LeadFieldProcessingTool.combineNew=false;

            zef.LeadFieldProcessingTool.combineData.source_interpolation_ind = zef.LeadFieldProcessingTool.auxData.source_interpolation_ind;
            zef.LeadFieldProcessingTool.combineData.parcellation_interp_ind =zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind;
            zef.LeadFieldProcessingTool.combineData.source_positions = zef.LeadFieldProcessingTool.auxData.source_positions;
            zef.LeadFieldProcessingTool.combineData.source_directions = zef.LeadFieldProcessingTool.auxData.source_directions;
            zef.LeadFieldProcessingTool.combineData.imaging_method_Name = 'combined';
            %zef.LeadFieldProcessingTool.combineData.lf_bank_scaling_factor = zef.LeadFieldProcessingTool.auxData.lf_bank_scaling_factor;

            zef.LeadFieldProcessingTool.combineData.source_structure=zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.source_structure;
            zef.LeadFieldProcessingTool.combineData.compartment_tags=zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.compartment_tags;

            zef.LeadFieldProcessingTool.combineData.imaging_method = zef.LeadFieldProcessingTool.auxData.imaging_method;
            zef.LeadFieldProcessingTool.combineData.lf_tag = '';

            zef.LeadFieldProcessingTool.combineData.L = [];
            zef.LeadFieldProcessingTool.combineData.measurements = [];
            zef.LeadFieldProcessingTool.combineData.noise_data = [];
            zef.LeadFieldProcessingTool.combineData.sensors = [];
            zef.LeadFieldProcessingTool.combineData.noise=[];

        end

        %noise_par=std(data, 0, 2)
        zef.LeadFieldProcessingTool.combineData.noise=std(zef.LeadFieldProcessingTool.auxData.measurements(:, zef.LeadFieldProcessingTool.combinePoints), 0,2);

        zef.LeadFieldProcessingTool.combineData.L = vertcat(zef.LeadFieldProcessingTool.combineData.L, ...
            (1./zef.LeadFieldProcessingTool.combineData.noise).*zef.LeadFieldProcessingTool.auxData.L);

        zef.LeadFieldProcessingTool.combineData.measurements =vertcat( zef.LeadFieldProcessingTool.combineData.measurements, ...
            (1./zef.LeadFieldProcessingTool.combineData.noise).*zef.LeadFieldProcessingTool.auxData.measurements);

        if ~isempty(zef.LeadFieldProcessingTool.auxData.noise_data)
            zef.LeadFieldProcessingTool.combineData.noise_data = vertcat( zef.LeadFieldProcessingTool.combineData.noise_data, ...
                (1./zef.LeadFieldProcessingTool.combineData.noise).*zef.LeadFieldProcessingTool.auxData.noise_data);
        end

        if isempty(zef.LeadFieldProcessingTool.combineData.sensors)
            zef.LeadFieldProcessingTool.combineData.sensors = vertcat(zef.LeadFieldProcessingTool.combineData.sensors, zef.LeadFieldProcessingTool.auxData.sensors(:,1:3));
        else
            zef.LeadFieldProcessingTool.combineData.sensors = vertcat(zef.LeadFieldProcessingTool.combineData.sensors(:,1:3) , zef.LeadFieldProcessingTool.auxData.sensors(:,1:3));
        end

    end

end

        zef.LeadFieldProcessingTool.auxData=[];
        zef.LeadFieldProcessingTool.auxData=zef.LeadFieldProcessingTool.combineData;

        [zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'bank_apply');
        zef.LeadFieldProcessingTool.auxData.lead_field_id=zef.lead_field_id_max;

        zef.LeadFieldProcessingTool.combineData=[];
        zef_LeadFieldProcessingTool_aux2bank_new;

        clear zef_LeadFieldProcessingTool_index_combine;

