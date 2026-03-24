classdef ElectrodeSet < zefCore.Sensor
%
% ElectrodeSet < Sensor
%
% A type representing a set of active or a passive double layer electrodes, as
% in electrodes whose ciruit diagram is as follows:
%
%      |- Rd -|
%   E -|      |- Rc - S
%      |- Cd -|
%
% Here E is the electrode voltage source, Rd and Cd are the double layer
% capacitor resistance and capacitance, and Rc is the contact resistance
% between the double layer and the skin S.
%

    properties
        capacitances (:,1) double { mustBeNonnegative } = []
        contactSurfaces (:,1) zefCore.SuperNode = zefCore.SuperNode.empty
        doubleLayerResistances (:,1) double { mustBeNonnegative, mustBeReal, mustBeFinite } = []
        frequencies (:,1) double { mustBeNonnegative } = []
        contactResistances (:,1) double { mustBeNonnegative, mustBeReal, mustBeFinite } = []
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
                kwargs.contactResistances = []
            end

            sensorN = numel ( kwargs.contactSurfaces ) ;

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

            N = numel ( self.contactSurfaces ) ;

        end % function

        function P = positions (self)
        %
        % P = self.positions
        %
        % Returns the positions of the contact surfaces.
        %

            P = [ self.contactSurfaces.centralNodePos ] ;

        end % function

        function A = areas ( self )
        %
        % A = areas ( self )
        %
        % Computes the areas of the electrodes contained in this set.
        %

            A = [ self.contactSurfaces.totalSurfaceArea ] ;

        end % function

        function Z = impedances (self)
        %
        % Z = impedances (self)
        %
        % Computes and returns the impedances of the electrodes based on the
        % parameters of self.
        %

            Z = zefCore.impedanceParallel (self.doubleLayerResistances, self.frequencies, 0, self.capacitances) + self.contactResistances ;

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

                M = zefCore.ElectrodeModel.PEM ;

            else

                M = zefCore.ElectrodeModel.CEM ;

            end % if

        end % function

        function self = withWetResistances (self,R)
        %
        % self = withWetResistances (self,R)
        %
        % Sets the wet resistancies within self.
        %

            self.contactResistances = R ;

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

        function self = withPerturbedFrequencies (self, I, df)
        %
        % self = withPerturbedFrequencies (self, I, df)
        %
        % Modifies the frequencies of self at indices I by df.
        %

            arguments
                self
                I (:,1) double { mustBeInteger, mustBePositive }
                df (:,1) double { mustBeReal, mustBeFinite }
            end

            eN = self.electrodeCount ;

            assert ( all (I <= eN ), "Electrode index out of range." ) ;

            self.frequencies (I) = self.frequencies (I) + df ;

        end % function

    end % methods

end % classdef
