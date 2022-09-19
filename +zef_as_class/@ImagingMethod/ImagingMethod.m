classdef ImagingMethod

    %
    % ImagingMethod
    %
    % An enumeration of the imaging methods known by Zeffiro Interface. These
    % include
    %
    % - EEG or electroencephalography,
    %
    % - MEG_M or magnetoencephalography performed with magnetometers,
    %
    % - MEG_G or magnetoencephalography performed with gradiometers,
    %
    % - EIT or electrical impedance tomography.
    %
    % - tES or transcranial electrical stimulation and
    %

    enumeration

        EEG
        MEG_M
        MEG_G
        EIT
        tES

    end

    methods (Static)

        function vars = variants()

            % ImagingMethod.variants
            %
            % A constant function that generates an array of the variants of the
            % SourceModel enumeration.
            %
            % Output:
            %
            % - vars
            %
            %   A column vector of the variants.

            % A bit funny, but this is necessary for listing the variants
            % without invoking a constructor.

            im = ImagingMethod.EEG;

            % Generate the list of variants.

            vars = enumeration(im);

        end

    end % methods (Static)

end % classdef
