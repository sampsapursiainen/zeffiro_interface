classdef LeadField
%
% LeadField
%
% A class that holds onto a lead field matrix and its modality.
%

    properties
        matrix (:,:,:) double { mustBeFinite } = [] % The numerical data related to this lead field.
        modality (1,1) core.LeadFieldModality = core.LeadFieldModality.None % The modality of this lead field.
    end

    methods

        function self = LeadField ( kwargs )
        %
        % self = LeadField ( kwargs )
        %
        % The constructor of this class. All properties are given as keyword arguments.
        %

            arguments
                kwargs.matrix = []
                kwargs.modality = core.LeadFieldModality.None
            end

            fields = string ( fieldnames ( kwargs ) ) ;

            for fi = 1 : numel ( kwargs )

                fieldname = fields ( fi ) ;

                self.(fieldname) = kwargs.(fieldname) ;

            end

        end % function

    end % methods

end % classdef
