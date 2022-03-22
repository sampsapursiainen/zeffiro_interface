function [L, measurements] = zef_lead_field_normalize_frobenius(lf_bank_index)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function normalizes the lead field data for a given lead
%field bank entry.
%Description: Frobenius norm normalization

L = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.L']);
measurements = evalin('base',['zef.lf_bank_storage{' num2str(lf_bank_index) '}.measurements']);

L = sqrt(size(L,1))*L/norm(L,'fro');
measurements = sqrt(size(L,1))*measurements/norm(L,'fro');

end
