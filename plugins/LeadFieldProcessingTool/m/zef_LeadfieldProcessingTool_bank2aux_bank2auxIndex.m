
%reads the data from the bank into the aux field.
%zef.LeadFieldProcessingTool.bank2auxIndex has to be set before

% zef.LeadFieldProcessingTool.auxData=[];
%
% zef.LeadFieldProcessingTool.auxData.source_interpolation_ind = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.source_interpolation_ind;
% zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.parcellation_interp_ind;
% zef.LeadFieldProcessingTool.auxData.source_positions = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.source_positions;
% zef.LeadFieldProcessingTool.auxData.source_directions = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.source_directions;
% zef.LeadFieldProcessingTool.auxData.L = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.L;
% zef.LeadFieldProcessingTool.auxData.sensors = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.sensors;
%
% zef.LeadFieldProcessingTool.auxData.imaging_method_Name = zef.imaging_method_cell{zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.imaging_method};
% zef.LeadFieldProcessingTool.auxData.imaging_method = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.imaging_method;
%
%
% zef.LeadFieldProcessingTool.auxData.measurements = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.measurements;
% zef.LeadFieldProcessingTool.auxData.noise_data = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.noise_data;
% %zef.LeadFieldProcessingTool.auxData.lf_bank_scaling_factor = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.lf_bank_scaling_factor;
% zef.LeadFieldProcessingTool.auxData.lf_tag = zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.lf_tag;
%
% zef.LeadFieldProcessingTool.auxData.source_structure=zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.source_structure;
% zef.LeadFieldProcessingTool.auxData.compartment_tags=zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex}.compartment_tags;
%
%

zef.LeadFieldProcessingTool.auxData=zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bank2auxIndex};

