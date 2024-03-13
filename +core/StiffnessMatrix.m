classdef StiffnessMatrix
%
% StiffnessMatrix
%
% Defines the structure of a stiffness matrix.
%
    properties
        realPart (:,:) double { mustBeFinite } = sparse ([]) % The sparse real part of this stiffness matrix.
        imagPart (:,:) double { mustBeFinite } = sparse ([]) % The sparse imaginary part of this stiffness matrix.
    end

    methods

        function self = StiffnessMatrix ( kwargs )
        %
        % self = StiffnessMatrix ( kwargs )
        %
        % A constructor for this class. Takes in the class properties as
        % keyword arguments with default values, so that the constructor might
        % be called without any arguments, in the cases where MATLAB requires
        % it.
        %

            arguments
                kwargs.realPart = sparse ([])
                kwargs.imagPart = sparse ([])
            end

            fns = string ( fieldnames ( kwargs ) )

            for fni = 1 : numel ( fns )

                fn = fns (fni) ;

                self.(fn) = sparse ( kwargs.(fn) ) ;

            end % for

        end % function

    end % methods

end % classdef
