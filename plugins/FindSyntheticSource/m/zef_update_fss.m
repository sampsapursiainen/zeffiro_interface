%Copyright © 2020- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if ~zef.synth_source_updated_true
temp_fields = fields(zef.synth_source_data);
zef.inv_synth_source = zeros(length(temp_fields),8);
for zef_n = 1:length(temp_fields)
    zef.inv_synth_source(zef_n,1) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{1,2});
    zef.inv_synth_source(zef_n,2) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{2,2});
    zef.inv_synth_source(zef_n,3) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{3,2});
    zef.inv_synth_source(zef_n,4) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{4,2});
    zef.inv_synth_source(zef_n,5) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{5,2});
    zef.inv_synth_source(zef_n,6) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{6,2});
    zef.inv_synth_source(zef_n,7) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{7,2});
    zef.inv_synth_source(zef_n,8) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{8,2});
    
    zef.inv_synth_source(zef_n,9) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{15,2});
    zef.inv_synth_source(zef_n,10) = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{16,2});
    
    zef.inv_synth_sampling_frequency{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{9,2});
    zef.inv_pulse_peak_time{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{10,2});
    zef.inv_pulse_amplitude{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{11,2});
    zef.inv_pulse_length{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{12,2});
    zef.inv_oscillation_frequency{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{13,2});
    zef.inv_oscillation_phase{zef_n} = str2num(zef.synth_source_data.(temp_fields{zef_n}).parameters{14,2});
end
zef.synth_source_updated_true = true;
end

