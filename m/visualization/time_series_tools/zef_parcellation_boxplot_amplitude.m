function [y_vals, plot_mode] = zef_parcellation_boxplot_amplitude(time_series)
% Description: Amplitude boxplot

plot_mode = 4; % custom mode for boxplot rendering

if ~iscell(time_series)
    error('Time series must be a cell array for boxplot mode.');
end

[num_rois, num_frames] = size(time_series);
y_vals = cell(num_rois, 1);

for i = 1:num_rois
    % Collect all frame samples for the i-th ROI
    all_samples = [];
    for j = 1:num_frames
        if ~isempty(time_series{i, j})
            all_samples = [all_samples; abs(time_series{i, j}(:))];
        end
    end
    y_vals{i} = all_samples;
end

end