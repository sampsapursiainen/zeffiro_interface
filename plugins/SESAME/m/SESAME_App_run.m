%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.SESAME_App = SESAME_App;
zef_init_SESAME;
%Substitute values from zef to the app
zef_fields = fields(zef);
for zef_i = 1:length(zef_fields)
    if isprop(zef.SESAME_App,strcat('h_',zef_fields{zef_i}))
        if strcmp(zef.SESAME_App.(strcat('h_',zef_fields{zef_i})).Type,'uidropdown')
            zef.SESAME_App.(strcat('h_',zef_fields{zef_i})).Value = zef.SESAME_App.(strcat('h_',zef_fields{zef_i})).ItemsData{zef.(zef_fields{zef_i})};
        else
            zef.SESAME_App.(strcat('h_',zef_fields{zef_i})).Value = num2str(zef.(zef_fields{zef_i}));
        end
    end
end

%initialize fonts of the components
props = properties(zef.SESAME_App);
for zef_i = 1:length(props)
    if isprop(zef.SESAME_App.(props{zef_i}),'FontSize')
        zef.SESAME_App.(props{zef_i}).FontSize = zef.font_size;
        if isprop(zef.SESAME_App.(props{zef_i}),'HorizontalAlignment') && strcmp(zef.SESAME_App.(props{zef_i}).Type,'uilabel')
            zef.SESAME_App.(props{zef_i}).HorizontalAlignment = 'left';
        end
    end
end

clear zef_fields props

%Check if the core script is downloaded from GitHub
SESAME_core_check;

%Defining functionalities of the app

zef.SESAME_App.h_SESAME_snr.ValueChangedFcn = 'zef.SESAME_snr=str2double(zef.SESAME_App.h_SESAME_snr.Value);';
zef.SESAME_App.h_SESAME_n_sampler.ValueChangedFcn = 'zef.SESAME_n_sampler = str2double(zef.SESAME_App.h_SESAME_n_sampler.Value);';
zef.SESAME_App.h_SESAME_sampling_frequency.ValueChangedFcn = 'zef.SESAME_sampling_frequency = str2double(zef.SESAME_App.h_SESAME_sampling_frequency.Value); zef.inv_sampling_frequency = str2double(zef.SESAME_App.h_SESAME_sampling_frequency.Value);';
zef.SESAME_App.h_SESAME_low_cut_frequency.ValueChangedFcn = 'zef.SESAME_low_cut_frequency = str2double(zef.SESAME_App.h_SESAME_low_cut_frequency.Value);';
zef.SESAME_App.h_SESAME_high_cut_frequency.ValueChangedFcn = 'zef.SESAME_high_cut_frequency = str2double(zef.SESAME_App.h_SESAME_high_cut_frequency.Value);';
zef.SESAME_App.h_SESAME_time_1.ValueChangedFcn = 'zef.SESAME_time_1 = str2double(zef.SESAME_App.h_SESAME_time_1.Value); zef.inv_time_1 = str2double(zef.SESAME_App.h_SESAME_time_1.Value);';
zef.SESAME_App.h_SESAME_time_2.ValueChangedFcn = 'zef.SESAME_time_2 = str2double(zef.SESAME_App.h_SESAME_time_2.Value); zef.inv_time_2 = str2double(zef.SESAME_App.h_SESAME_time_2.Value);';
zef.SESAME_App.h_SESAME_number_of_frames.ValueChangedFcn = 'zef.SESAME_number_of_frames = str2double(zef.SESAME_App.h_SESAME_number_of_frames.Value); zef.number_of_frames = str2double(zef.SESAME_App.h_SESAME_number_of_frames.Value);';
zef.SESAME_App.h_SESAME_time_3.ValueChangedFcn = 'zef.SESAME_time_3 = str2double(zef.SESAME_App.h_SESAME_time_3.Value); zef.inv_time_3 = str2double(zef.SESAME_App.h_SESAME_time_3.Value);';
zef.SESAME_App.h_SESAME_data_segment.ValueChangedFcn = 'zef.SESAME_data_segment = str2double(zef.SESAME_App.h_SESAME_data_segment.Value);';
zef.SESAME_App.h_SESAME_normalize_data.ValueChangedFcn = 'zef.SESAME_normalize_data = str2double(zef.SESAME_App.h_SESAME_normalize_data.Value);';
zef.SESAME_App.h_inv_rec_source_8.ValueChangedFcn = 'zef.inv_rec_source(1,8) = str2num(zef.SESAME_App.h_inv_rec_source_8.Value);';
zef.SESAME_App.h_inv_rec_source_9.ValueChangedFcn = 'zef.inv_rec_source(1,9) = str2num(zef.SESAME_App.h_inv_rec_source_9.Value);';
zef.SESAME_App.h_apply.ButtonPushedFcn = 'zef_update_SESAME;';
zef.SESAME_App.h_start.ButtonPushedFcn = 'zef_update_SESAME; zef.reconstruction = SESAME_inversion([]);';
zef.SESAME_App.h_plot_dipoles.ButtonPushedFcn = 'SESAME_plot_movie;';

%set fonts
set(findobj(zef.SESAME_App.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);

clear zef_i