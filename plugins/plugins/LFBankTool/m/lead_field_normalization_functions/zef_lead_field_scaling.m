function [L, measurements] = zef_lead_field_scaling(lf_bank_index)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function normalizes the lead field data for a given lead
%field bank entry.
%Description: Scaling

L = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.L']);
measurements = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.measurements']);
scaling_factor = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.scaling_factor']);

L = scaling_factor*L;
measurements = scaling_factor*measurements;

end
