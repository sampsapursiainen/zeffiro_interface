classdef LeadField
%
% LeadField
%
% A class that holds onto a lead field matrix and its modality.
%

    properties
        matrix (:,:,:) double { mustBeFinite } = [] % The numerical data related to this lead field.
        modality (1,1) zefCore.LeadFieldModality = zefCore.LeadFieldModality.None % The modality of this lead field.
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
                kwargs.modality = zefCore.LeadFieldModality.None
            end

            fields = string ( fieldnames ( kwargs ) ) ;

            for fi = 1 : numel ( kwargs )

                fieldname = fields ( fi ) ;

                self.(fieldname) = kwargs.(fieldname) ;

            end

        end % function

        function self = plus ( self, other )
        %
        % self = plus ( self, other )
        %
        % Overleads the + operator for this class. Returns a LeadField, as long
        % as other is a numerical matrix of same dimensions as self, or a lead
        % field of the same modality.
        %

            arguments
                self (1,1) zefCore.LeadField
                other
            end

            if isnumeric ( other )

                self.matrix = self.matrix + other ;

            elseif class ( other ) == "zefCore.LeadField" && other.modality == self.modality

                self.matrix = self.matrix + other.matrix ;

            else

                error ( "Received a non-numerical matrix as the second argument, or the modality of the given second lead field was not the same the first one." )

            end % if

        end

    end % methods

end % classdef
