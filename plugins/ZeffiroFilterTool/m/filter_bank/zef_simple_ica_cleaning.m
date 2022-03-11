function [processed_data] = zef_simple_ica_cleaning(f, ica_reference_channels)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Simple ICA for data cleaning
%Input: 1 ICA reference channel indices [Default: ]
%Output: Data cleaned via ICA.

%Conversion between string and numeric data types.
if isstr(ica_reference_channels)
ica_reference_channels = str2num(ica_reference_channels);
end
%End of conversion.

size_f = size(f,1);
f = f';
n_ica = length(ica_reference_channels)+1;

f_2 = zeros(size(f));

h = waitbar(0,['Simple ICA filter.']);

for i = 1 : size_f

  Mdl = rica(f(:,[i ica_reference_channels]),n_ica);
  aux_vec = transform(Mdl,f(:,[i ica_reference_channels]));
  f_2(:,i) = aux_vec(:,1);
  waitbar(i/size_f,h,['Simple ICA filter.']);

end

close(h);

processed_data = f_2';
