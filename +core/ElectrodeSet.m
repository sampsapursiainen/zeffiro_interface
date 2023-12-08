classdef ElectrodeSet < core.Sensor
%
% ElectrodeSet < Sensor
%
% A type representing a set of active or a passive electrodes. Might be used in
% EEG, EIT and tES tomography.
%

    properties
        positions  (:,3) double { mustBeFinite }      = []
        innerRadii (:,1) double { mustBeFinite }      = []
        outerRadii (:,1) double { mustBeFinite }      = []
        impedances (:,1) double { mustBeNonnegative } = []
    end

    methods

        function self = ElectrodeSet ( kwargs )
        %
        % self = ElectrodeSet ( kwargs )
        %
        % A constructor for this class. All properties are passed as keyword
        % arguments.
        %

            arguments
                kwargs.positions  = []
                kwargs.innerRadii = []
                kwargs.outerRadii = []
                kwargs.impedances = []
            end

            sensorN = size ( kwargs.positions, 1 ) ;

            sizeAssertion = @(arg) isscalar ( arg ) || numel ( arg ) == sensorN ;

            assert ( ...
                sizeAssertion ( kwargs.impedances ), ...
                "The number of given impedances must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                sizeAssertion ( kwargs.innerRadii ), ...
                "The number of given inner radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                sizeAssertion ( kwargs.outerRadii ), ...
                "The number of given outer radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            assert ( ...
                all ( kwargs.innerRadii < kwargs.outerRadii ), ...
                "All of the given inner radii must be less than the given outer radii." ...
            ) ;

            assert ( ...
                sizeAssertion ( kwargs.impedances ), ...
                "The number of given outer radii must match the number of sensor positions, or be a scalar." ...
            ) ;

            fields = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fields )

                field = fields ( fni ) ;

                fieldval = kwargs.(field) ;

                if isscalar ( fieldval )

                    fieldval = repmat ( fieldval, sensorN, 1 ) ;

                end

                self.(field) = fieldval ;

            end % for

        end % function

        function N = electrodeCount ( self )
        %
        % N = electrodeCount ( self )
        %
        % Returns the number of electrodes in self, defined by how many
        % electrode positions there are.
        %

            N = size ( self.positions, 1 ) ;

        end % function

        function A = areas ( self )
        %
        % A = areas ( self )
        %
        % Computes the areas of the electrodes contained in this set.
        %

            innerA = pi .* self.innerRadii .^ 2 ;

            outerA = pi .* self.outerRadii .^ 2 ;

            A = outerA - innerA ;

            if isscalar ( A )
                A = repmat ( A, self.electrodeCount, 1 ) ;
            end

        end % function

        function Z = effectiveImpedances ( self )
        %
        % Z = effectiveImpedances ( self )
        %
        % Computes the effective impedances, the impedances multiplied by
        % electrode areas, of this electrode set.
        %

            As = self.areas ;

            Zs = self.impedances ;

            Z = Zs .* As ;

        end % function

        function M = electrodeModel ( self )
        %
        % M = electrodeModel ( self )
        %
        % Checks whether this electrode set conforms to the point electrode
        % model PEM or complete electrode model CEM.
        %

            if all ( isinf ( self.effectiveImpedances ) )

                M = core.ElectrodeModel.PEM ;

            else

                M = core.ElectrodeModel.CEM ;

            end % if

        end % function

    end % methods

end % classdef
