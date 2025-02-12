%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z] = zef_evaluate_topography(zef)

h = zef_waitbar(0,1,['Topography.']);
sampling_freq = eval('zef.top_sampling_frequency');
high_pass = eval('zef.top_low_cut_frequency');
low_pass = eval('zef.top_high_cut_frequency');
number_of_frames = eval('zef.top_number_of_frames');
time_step = eval('zef.top_time_3');
triangles = eval('zef.reuna_t{end-1}');
triangle_points = eval('zef.reuna_p{end-1}');
sensor_points = eval('zef.sensors(:,1:3)');

if number_of_frames > 1
    z = cell(number_of_frames,1);
else
    number_of_frames = 1;
end

tic;

   [f_data] = zef_getFilteredData(zef);

for f_ind = 1 : number_of_frames
    time_val = toc;
    if f_ind > 1;
        date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
    end;

    [f] = zef_getTimeStep(f_data, f_ind, zef);

    zef_waitbar(f_ind,number_of_frames,h,['Topography. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);

    if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
        f = gpuArray(f);
    end

    z_aux = zeros(size(triangle_points,1),1);
    for sensor_ind = 1 : size(sensor_points,1)
        dist_vec = sqrt(sum((triangle_points-sensor_points(sensor_ind*ones(size(triangle_points,1),1),:)).^2,2));
        dist_vec = dist_vec/min(dist_vec);
        z_aux = z_aux + f(sensor_ind)./(eval('zef.top_regularization_parameter')+(dist_vec));
    end

    if number_of_frames > 1
        z{f_ind} = z_aux;
    else
        z = z_aux;
    end

end

if number_of_frames > 1;
    aux_norm_vec = 0;
    for f_ind = 1 : number_of_frames;
        aux_norm_vec = max(abs(z{f_ind}),aux_norm_vec);
    end;
    for f_ind = 1 : number_of_frames;
        z{f_ind} = z{f_ind}./max(aux_norm_vec);
    end;
else
    aux_norm_vec = abs(z);
    z = z./max(aux_norm_vec);
end;

close(h);

end
