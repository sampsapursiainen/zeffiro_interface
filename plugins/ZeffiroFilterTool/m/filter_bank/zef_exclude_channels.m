function [processed_data] = zef_exclude_channels(f, exclude_channels)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Exclude channels
%Input: 1 Exclude channels [Default: ]
%Output: Data without the excluded channels.

%Conversion between string and numeric data types.
if isstr(exclude_channels)
exclude_channels = str2num(exclude_channels);
end
%End of conversion.

selected_channels = find(not(ismember([1:length(f)],exclude_channels)));

processed_data = f(selected_channels,:);
