classdef LeadField
%
% LeadField
%
% A class representing a lead field matrix. Also contains information related to the modality that
% the lead field was constructed with, among other information that might be required by the users
% of this data structure.
%

    properties
        %
        % matrix
        %
        % The numerical lead field matrix itself.
        %
        matrix (:,:) double { mustBeNonNan, mustBeFinite } = []
        %
        % modality
        %
        % The modality of this lead field. Must be one of core.LFModality.{EEG,MEG,gMEG,EIT,tES} if
        % a lead field has been constructed. Otherwise this should be LFModality.None.
        %
        modality (1,1) core.LFModality = core.LFModality.None
        %
    end % properties

    methods

        function self = LeadField ( kwargs )
        %
        % LeadField ( kwargs )
        %
        % Constructs a lead field from the given keyword arguments, which correspond to the class
        % properties.
        %
        % Inputs:
        %
        % - kwargs.matrix
        %
        %   The lead fielf matrix.
        %
        % - kwargs.modality
        %
        %   The modality of the lead field.
        %

            arguments

                kwargs.matrix = []

                kwargs.modality = core.LFModality.None

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end

        end % function

    end % methods

end % classdef
