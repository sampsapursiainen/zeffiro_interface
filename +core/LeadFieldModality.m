classdef LeadFieldModality
%
% LeadFieldModality
%
% An enumeration of the imaging modalities that Zeffiro Interface supports.
%

    enumeration
        EEG     % Electroenceplahography
        MEG     % Magnetoencephalography
        gMEG    % Magnetoencephalography performed with gradiometers
        EIT     % Electrical Impedance Tomography
        tES     % Transcranial Electric Stimulation.
        None    % No modality specified. Useful mainly as a default value.
    end

end % classdef
