function [f,t] = get_time_step( ...
    f_data, ...
    f_ind, ...
    time_start, ...
    time_window, ...
    time_step, ...
    sampling_frequency, ...
    options ...
)

    % get_time_step
    %
    % Gets the time windows and segments of f_data that are specified in the
    % zef.inv_time* parameters. f_ind gives the number of the given window (first,
    % second, third ...) if there is only one time step, f_data is returned.
    % Should the specified time steps exceed the data length, an empty array is
    % returned. If a window is specified, averaging can be applied. The behavior
    % is specified in Optional_averaging_bool, with a default of true

    arguments

        f_data

        f_ind (1,1) double { mustBePositive, mustBeInteger }

        time_start (1,1) double

        time_window (1,1) double

        time_step (1,1) double

        sampling_frequency

        options.Optional_averaging_bool (1,1) double = true;

    end

    size_Data=size(f_data,2);

    % This part gives wrong values, because it uses the time step length?

    if size_Data > 1

        if time_window >=0 ...
        && time_start >= 0 ...
        && 1 + sampling_frequency*time_start <= size_Data

            t_ind = max(1, 1 + floor(sampling_frequency * time_start+sampling_frequency*(f_ind - 1)*time_step)) : ...
                min(size_Data, 1 + floor(sampling_frequency*(time_start + time_window + sampling_frequency*(f_ind - 1)*time_step)));
            f = f_data(:, t_ind);
            t = (double(t_ind)-1)./sampling_frequency;

        end

    else
        f=f_data;
    end

    if options.Optional_averaging_bool && size(f,2) > 1
        f = mean(f,2);
    end

end
