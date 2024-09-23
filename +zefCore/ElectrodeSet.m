classdef ElectrodeSet < zefCore.Sensor
%
% ElectrodeSet < Sensor
%
% A type representing a set of active or a passive double layer electrodes, as
% in electrodes whose ciruit diagram is as follows:
%
%      |- RC -|
%   E -|      |- Rw -- S
%      |- Cc -|
%
% Here E is the electrode voltage source, Rc and Cc are the double layer
% capacitor resistance and capacitance, and Rw is the resistance of a wet
% component such as electrolyte gel between the double layer and the skin.
%

    properties
        capacitances (:,1) double { mustBeNonnegative } = []
        contactSurfaces (:,1) zefCore.SuperNode = zefCore.SuperNode.empty
        doubleLayerResistances (:,1) double { mustBeNonnegative, mustBeReal, mustBeFinite } = []
        frequencies (:,1) double { mustBeNonnegative } = []
        innerRadii (:,1) double { mustBeNonnegative, mustBeFinite } = 0
        outerRadii (:,1) double { mustBeNonnegative, mustBeFinite } = 0
        positions  (3,:) double { mustBeFinite } = []
        wetResistances (:,1) double { mustBeNonnegative, mustBeReal, mustBeFinite } = []
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
                kwargs.capacitances= []
                kwargs.contactSurfaces = zefCore.SuperNode.empty
                kwargs.doubleLayerResistances = []
                kwargs.frequencies = []
                kwargs.innerRadii = 0
                kwargs.outerRadii = 0
                kwargs.positions  = []
                kwargs.wetResistances = []
            end

            sensorN = size ( kwargs.positions, 2 ) ;

            sizeAssertion = @(arg) isscalar ( arg ) || numel ( arg ) == sensorN ;

            fields = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fields )

                field = fields ( fni ) ;

                fieldval = kwargs.(field) ;

                assert ( ...
                    sizeAssertion ( fieldval ), ...
                    "The number of given " + field + " must match the number of sensor positions, or be a scalar." ...
                ) ;

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

            N = size ( self.positions, 2 ) ;

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

        function Z = impedances (self)
        %
        % Z = impedances (self)
        %
        % Computes and returns the impedances of the electrodes based on the
        % parameters of self.
        %

            Rw = self.wetResistances ;

            f = self.frequencies ;

            C = self.capacitances ;

            Rc = self.doubleLayerResistances ;

            Z = zefCore.impedanceParallel (Rc, f, 0, C) + Rw ;

        end % function

        function Z = effectiveImpedances ( self )
        %
        % Z = effectiveImpedances ( self )
        %
        % Computes the effective wetResistances, the wetResistances multiplied by
        % electrode areas, of this electrode set.
        %

            As = self.areas ;

            Zs = self.wetResistances ;

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

                M = zefCore.ElectrodeModel.PEM ;

            else

                M = zefCore.ElectrodeModel.CEM ;

            end % if

        end % function

        function self = withImpedances (self, wetResistances)
        %
        % self = withImpedances (self, wetResistances)
        %
        % Sets the wetResistances of self to given values.
        %

            self.wetResistances (:) = wetResistances ;

        end % function

        function self = withWetResistances (self,R)
        %
        % self = withWetResistances (self,R)
        %
        % Sets the wet resistancies within self.
        %

            self.wetResistances = R ;

        end % function

        function self = withDoubleLayerResistances (self,R)
        %
        % self = withDoubleLayerResistances (self,R)
        %
        % Sets the wet resistancies within self.
        %

            self.doubleLayerResistances = R ;

        end % function

        function self = withFrequencies (self, frequencies)
        %
        % self = withImpedances (self, frequencies)
        %
        % Sets the frequencies of self to given values.
        %

            self.frequencies (:) = frequencies ;

        end % function

        function self = withCapacitances(self, capacitances)
        %
        % self = withCapacitances (self, capacitances)
        %
        % Sets the capacitances of self to given values.
        %

            self.capacitances (:) = capacitances ;

        end % function

    end % methods

end % classdef
