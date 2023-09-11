classdef LFModality
%
% LFModality
%
% An enumeration class describing the different possible modalities that a lead field matrix might
% have in Zeffiro Interface.
%
    enumeration
        %
        % A lead field constructed from EEG or electroencephalography measurements.
        %
        EEG
        %
        % A lead field constructed from MEG or magnetoencephalography measurements.
        %
        MEG
        %
        % A lead field constructed from gMEG or gradiometric magnetoencephalography measurements.
        %
        gMEG
        %
        % A lead field constructed from EIT or electrical impedance tomography measurements.
        %
        EIT
        %
        % A lead field constructed from tES or trascranial electric stimulation measurements.
        %
        tES
        %
        % Indicates that a lead field has no modality. This is a default value for a lead field
        % that has not been constructed yet.
        %
        None
        %
    end % enumeration

end % classdef
