

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

            rsize = size (self.realPart) ;

            isize = size (self.imagPart) ;

            sizeIsValid = all ( rsize == isize ) || isempty (self.realPart) || isempty (self.imagPart) ;

            assert ( sizeIsValid, "StiffnessMatrix: either the real and imaginary parts need to be the same size, or one of them needs to be empty. Now size (realPart) = (" + strjoin (string ( rsize ),",") + ") and size (imagPart) = (" + strjoin ( string ( isize ),",") + ")." )

        end % function

        function out = real ( self )
        %
        % out = real ( self )
        %
        % Returns the real part of this stiffness matrix.
        %

            out = self.realPart ;

        end % function


        function out = imag ( self )
        %
        % out = imag ( self )
        %
        % Returns the imaginary part of this stiffness matrix.
        %

            out = self.imagPart ;

        end % function

        function out = double ( self )
        %
        % out = double ( self )
        %
        % Returns self as a sparse (complex-valued) matrix of doubles.
        %

            out = self.realPart + i * self.imagPart ;

        end % function

        function out = plus (left,right)
        %
        % out = plus (left,right)
        %
        % Implements addition for this class.
        %

            dl = double ( left ) ;

            dr = double ( right ) ;

            out = core.StiffnessMatrix.fromDouble ( dl + dr ) ;

        end % function

        function out = uplus (self)
        %
        % out = uplus (in)
        %
        % Implements unary plus for this class.
        %

            rself = real (self) ;

            iself = imag (self) ;

            out = core.StiffnessMatrix.fromDouble ( + rself + iself ) ;

        end % function

        function out = minus (left,right)
        %
        % out = minus (left,right)
        %
        % Implements subtraction for this class.
        %

            dl = double ( left ) ;

            dr = double ( right ) ;

            out = core.StiffnessMatrix.fromDouble ( dl - dr ) ;

        end % function

        function out = uminus (self)
        %
        % out = uminus (in)
        %
        % Implements unary minus or negation for this class.
        %

            rself = real (self) ;

            iself = imag (self) ;

            out = core.StiffnessMatrix.fromDouble ( - rself - iself ) ;

        end % function

    end % methods

    methods (Static)

        function self = fromDouble ( array )
        %
        % self = fromDouble ( array )
        %
        % Constructs a StiffnessMatrix from a given array of doubles.
        %

            arguments
                array (:,:) double { mustBeFinite }
            end

            self = core.StiffnessMatrix ( realPart=real(array), imagPart=imag(array) )

        end % function

    end % methods (Static)

end % classdef
