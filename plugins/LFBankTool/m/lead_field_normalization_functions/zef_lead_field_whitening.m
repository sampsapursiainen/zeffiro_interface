function [L, measurements] = zef_lead_field_whitening(lf_bank_index)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team 
%See: https://github.com/sampsapursiainen/zeffiro_interface 
%This function normalizes the lead field data for a given lead 
%field bank entry. 
%Description: Lead field whitening via noise data

L = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.L']);
measurements = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.measurements']);
noise_data = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.noise_data']);


inv_C = inv(sqrtm(cov(noise_data')));

L = inv_C*L;
measurements = inv_C*measurements;

end