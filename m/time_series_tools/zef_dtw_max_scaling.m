function [y_vals, plot_mode] = zef_dtw_max_scaling(time_series)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Dynamic time warping (DTW), maximum scaling

time_series = time_series./max(time_series);
y_vals = zeros(size(time_series,1), size(time_series,1));
for i = 1 : size(time_series,1)
    for j = 1 : size(time_series,1)
y_vals(i,j) = dtw(time_series(i,:),time_series(j,:));
    end
end

plot_mode = 2;
