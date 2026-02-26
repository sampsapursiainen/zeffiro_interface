function gd = zef_init_signal_general_data()
%ZEF_INIT_SIGNAL_GENERAL_DATA Default global signal parameters (new naming).

    gd = struct();

    %% --------------------------------------------------------------------
    %% General signal parameters
    gd.samplingRate_Hz     = nv('samplingRate_Hz', 1000);
    gd.gaussianNoiseStd    = nv('gaussianNoiseStd', 0.0);
    gd.numFeedbackLoops    = nv('numFeedbackLoops', 0);
    gd.blockDuration_s     = nv('blockDuration_s', 1.0);
    gd.plotLoopIndex    = nv('plotLoopIndex', 1.0);

    %% --------------------------------------------------------------------
    %% External input parameters
    % shape: 'box' | 'blackmanharris'
    gd.externalInput_shape       = nv('externalInput_shape', 'box');
    gd.externalInput_baseline    = nv('externalInput_baseline', 80);
    gd.externalInput_amplitude   = nv('externalInput_amplitude', 80);
    gd.externalInput_onset_s     = nv('externalInput_onset_s', 0.10);
    gd.externalInput_duration_s  = nv('externalInput_duration_s', 0.50);

    %% --------------------------------------------------------------------
    %% Modulation parameters
    % waveform: 'sin' | 'cos'
    gd.modulation_enabled    = nv('modulation_enabled', false);
    gd.modulation_waveform   = nv('modulation_waveform', 'sin');
    gd.modulation_freq_Hz    = nv('modulation_freq_Hz', 10.0);
    gd.modulation_depth      = nv('modulation_depth', 1.0);
    gd.modulation_phase_rad  = nv('modulation_phase_rad', 0.0);

end

function s = nv(name, value)
    s = struct('Name', name, 'Value', value);
end
