%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [meas_data] = zef_find_source(zef)
if nargin == 0
    zef = evalin('base', 'zef');
end
source_positions = eval( 'zef.source_positions');
noise_level = 10^(eval( 'zef.inv_synth_source(1,8)')/20);       %dipole noise
if noise_level > 1
    warning(['Noise level ',num2str(eval( 'zef.inv_synth_source(1,8)')),' corresponds to ',num2str(round(100*noise_level)),' % of noise. If this is not decired, please check the definition of Matlab function "db" and readjust the noise.'])
end
if ~isempty(eval( 'zef.fss_bg_noise'))
    bg_noise_level = 10^(eval( 'zef.fss_bg_noise')/20);    %background noise
else
    bg_noise_level = 0;
end
if bg_noise_level > 1
    warning(['Background noise level ',num2str(eval( 'zef.fss_bg_noise')),' corresponds to ',num2str(round(100*bg_noise_level)),' % of noise. If this is not decired, please check the definition of Matlab function "db" and readjust the noise.'])
end

s_p = eval( 'zef.inv_synth_source(:,1:3)');
s_o = eval( 'zef.inv_synth_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
if ~eval( 'isfield(zef,''time_sequence'')')
    s_a = eval( 'zef.inv_synth_source(:,7)');
    s_f = 1e-3*repmat(s_a,1,3).*s_o;
    L = eval( 'zef.L');
    meas_data = zeros(size(L(:,1),1),1);
    for i = 1 : size(s_p,1)
        [s_min,s_ind] = min(sqrt(sum((source_positions - repmat(s_p(i,:),size(source_positions,1),1)).^2,2)));
        meas_data = meas_data + s_f(i,1)*L(:,3*(s_ind-1)+1) + s_f(i,2)*L(:,3*(s_ind-1)+2) + s_f(i,3)*L(:,3*(s_ind-1)+3);
    end
    n_val = max(abs(meas_data));
    meas_data = meas_data + max(abs(meas_data)).*randn(size(meas_data,1),size(noise_level,1))*noise_level + max(abs(meas_data),[],'all').*randn(size(meas_data))*bg_noise_level;
else
    h = zef_waitbar(0,1,['Create time sequence data.']);
    if isempty(eval( 'zef.fss_time_val'))
        if eval( 'str2num(zef.find_synth_source.h_plot_switch.Value)') == 1
            time_seq = eval( 'zef.time_sequence(1:length(zef.find_synth_source.selected_source),:)');
        else
            time_seq = eval( 'zef.time_sequence');
        end
    else
        if eval( 'str2num(zef.find_synth_source.h_plot_switch.Value)') == 1
            time_seq = eval( 'zef.time_sequence(1:length(zef.find_synth_source.selected_source),length(zef.time_variable(zef.time_variable<=zef.fss_time_val)))');
        else
            time_seq = eval( 'zef.time_sequence(:,length(zef.time_variable(zef.time_variable<=zef.fss_time_val)))');
        end
    end
    s_a = eval( 'zef.inv_synth_source(:,7)');
    s_f = 1e-3*repmat(s_a,1,3).*s_o;
    s_f = repmat(s_f,1,1,size(time_seq,2));
    for zef_i = 1:size(time_seq,2)
        for zef_n = 1:size(s_a,1)
            s_f(zef_n,:,zef_i) = s_f(zef_n,:,zef_i)*time_seq(zef_n,zef_i);
        end
    end
    L = eval( 'zef.L');
    meas_data = zeros(size(L(:,1),1),size(time_seq,2));
    for i = 1 : size(s_p,1)
        [s_min,s_ind] = min(sqrt(sum((source_positions - repmat(s_p(i,:),size(source_positions,1),1)).^2,2)));
        for j = 1:size(time_seq,2)
            meas_data(:,j) = meas_data(:,j) + s_f(i,1,j)*L(:,3*(s_ind-1)+1) + s_f(i,2,j)*L(:,3*(s_ind-1)+2) + s_f(i,3,j)*L(:,3*(s_ind-1)+3);
        end
        zef_waitbar(i,size(s_p,1),h,['Creating the time sequence data. ',num2str(i),''/'',num2str(size(s_p,1))]);
    end
    n_val = max(abs(meas_data));
    meas_data = meas_data + max(abs(meas_data)).*randn(size(meas_data,1),size(noise_level,1))*noise_level+max(abs(meas_data),[],'all').*randn(size(meas_data))*bg_noise_level;
    close(h);
end
if nargout == 0
    assignin('base', 'zef', zef);
end

end
