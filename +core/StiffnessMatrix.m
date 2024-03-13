classdef StiffnessMatrix
%
% StiffnessMatrix
%
% Defines the structure of a stiffness matrix.
%
    properties
        data (:,:) double { mustBeFinite } = sparse ([]) % Contains the numerical data related to this matrix.
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
                kwargs.data = sparse ([])
            end

            fns = string ( fieldnames ( kwargs ) ) ;

            for fni = 1 : numel ( fns )

                fn = fns (fni) ;

                self.(fn) = sparse ( kwargs.(fn) ) ;

            end % for

        end % function

        function out = real ( self )
        %
        % out = real ( self )
        %
        % Returns the real part of this stiffness matrix.
        %

            out = real ( self.data ) ;

        end % function


        function out = imag ( self )
        %
        % out = imag ( self )
        %
        % Returns the imaginary part of this stiffness matrix.
        %

            out = imag ( self.data ) ;

        end % function

        function out = double ( self )
        %
        % out = double ( self )
        %
        % Returns self as a sparse (complex-valued) matrix of doubles.
        %

            out = self.data ;

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

            out = self ;

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

            out = core.StiffnessMatrix.fromDouble ( - self.data ) ;

        end % function

        function out = times (left, right)
        %
        % out = times (left, right)
        %
        % Imlements elementwise multiplication for this class.
        %

            dl = double ( left ) ;

            dr = double ( right ) ;

            out = core.StiffnessMatrix.fromDouble ( dl .* dr ) ;

        end % function

        function out = mtimes (left, right)
        %
        % out = mtimes (left, right)
        %
        % Imlements matrix multiplication for this class.
        %

            dl = double ( left ) ;

            dr = double ( right ) ;

            out = core.StiffnessMatrix.fromDouble ( dl * dr ) ;

        end % function

        function self = transpose (self)
        %
        % self = transpose (self)
        %
        % Implements traspose for this class.
        %

            self.data = transpose ( self.data ) ;

        end % function

        function self = ctranspose (self)
        %
        % self = ctranspose (self)
        %
        % Implements conjugate transpose for this class.
        %

            self.data = ctranspose (self.data) ;

        end % function

        function out = power ( left, right )
        %
        % out = power ( left, right )
        %
        % Implements elementwise poiwer for this class.
        %

            dl = double ( left ) ;

            dr = double ( right ) ;

            out = core.StiffnessMatrix.fromDouble ( dl .^ dr ) ;

        end % function

        function out = lt (a,b)
        %
        % out = lt (a,b)
        %
        % Implements the < operator for this class.
        %

            out = double (a) < double (b) ;

        end % function

        function out = gt (a,b)
        %
        % out = gt (a,b)
        %
        % Implements the > operator for this class.
        %

            out = double (a) > double (b) ;

        end % function

        function out = le (a,b)
        %
        % out = le (a,b)
        %
        % Implements the <= operator for this class.
        %

            out = double (a) <= double (b) ;

        end % function

        function out = ge (a,b)
        %
        % out = ge (a,b)
        %
        % Implements the >= operator for this class.
        %

            out = double (a) >= double (b) ;

        end % function

        function out = eq (a,b)
        %
        % out = eq (a,b)
        %
        % Implements the == operator for this class.
        %

            out = double (a) == double (b) ;

        end % function

        function out = and (a,b)
        %
        % out = and (a,b)
        %
        % Implements the & operator for this class.
        %

            out = double (a) & double (b) ;

        end % function

        function out = or (a,b)
        %
        % out = or (a,b)
        %
        % Implements the | operator for this class.
        %

            out = double (a) | double (b) ;

        end % function

        function out = not (self)
        %
        % out = not (a,b)
        %
        % Implements the ~ operator for this class.
        %

            out = ~ self.data ;

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

            self = core.StiffnessMatrix ( data=array ) ;

        end % function

    end % methods (Static)

end % classdef
