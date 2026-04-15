classdef SourceModel

    % An enumeration of the different source- or interpolation models used by
    % Zeffiro Interface.

    enumeration
        Hdiv
        Whitney
        StVenant
        ContinuousHdiv
        ContinuousWhitney
        ContinuousStVenant
        Error
    end

    methods

        function self = loadobj ( obj_or_struct )
        %
        % loadobj
        %
        % Converts a struct or a SourceModel loaded from a .mat file into a
        % valid in-memory object of this type.
        %

            arguments
                obj_or_struct (1,1)
            end

            classname = string ( class ( obj_or_struct ) ) ;

            % Set a default return value if all else fails.

            self = zeffiro.SourceModel.Hdiv ;

            if endsWith ( classname, "SourceModel" )

                self = obj_or_struct ;

            elseif classname == "struct"

                if isfield ( obj_or_struct, "ValueNames" )

                    self = zeffiro.SourceModel.from ( obj_or_struct.ValueNames ) ;

                end

            end % if

        end % function

    end % methods

    methods (Static)

        function source_model = from(p_input)

            % A function that creates an instance of the enumeration
            % zeffiro.SourceModel based on given p_input. Generates a
            % zeffiro.SourceModel.Error on invalid p_input.

            % Assume p_input is invalid. If valid p_input is found, this will
            % change to a valid return value.

            source_model = zeffiro.SourceModel.Error;

            % Check that we receive p_input.

            if ~ nargin == 1
                warning('I accept exactly one p_input. Returning erraneous output.')
                return
            end

            % Function is idempotent with respect to given zeffiro.SourceModel variants.

            if isenum(p_input)

                switch p_input
                    case zeffiro.SourceModel.Error
                        source_model = p_input;
                    case zeffiro.SourceModel.Whitney
                        source_model = p_input;
                    case zeffiro.SourceModel.Hdiv
                        source_model = p_input;
                    case zeffiro.SourceModel.StVenant
                        source_model = p_input;
                    case zeffiro.SourceModel.ContinuousWhitney
                        source_model = p_input;
                    case zeffiro.SourceModel.ContinuousHdiv
                        source_model = p_input;
                    case zeffiro.SourceModel.ContinuousStVenant
                        source_model = p_input;
                    otherwise
                        warning("I received an enum that is not a zeffiro.SourceModel. Setting erraneous return value.")
                        source_model = zeffiro.SourceModel.Error;
                end

                return

            end

            % If p_input is a real number.

            KNOWN_INTEGERS = [1, 2, 3, 4, 5, 6];

            % Check for valid inputs.

            if isreal(p_input)

                if p_input == 1
                    source_model = zeffiro.SourceModel.Whitney;
                elseif p_input == 2
                    source_model = zeffiro.SourceModel.Hdiv;
                elseif p_input == 3
                    source_model = zeffiro.SourceModel.StVenant;
                elseif p_input == 4
                    source_model = zeffiro.SourceModel.ContinuousWhitney;
                elseif p_input == 5
                    source_model = zeffiro.SourceModel.ContinuousHdiv;
                elseif p_input == 6
                    source_model = zeffiro.SourceModel.ContinuousStVenant;
                else
                    source_model = zeffiro.SourceModel.Error;
                end

            end

            % If p_input is a character.

            if ischar(p_input) || isstring(p_input)

                if strcmp(p_input, '1')
                    source_model = zeffiro.SourceModel.Whitney;
                elseif strcmp(p_input, '2')
                    source_model = zeffiro.SourceModel.Hdiv;
                elseif strcmp(p_input, '3')
                    source_model = zeffiro.SourceModel.StVenant;
                elseif strcmp(p_input, '4')
                    source_model = zeffiro.SourceModel.ContinuousWhitney;
                elseif strcmp(p_input, '5')
                    source_model = zeffiro.SourceModel.ContinuousHdiv;
                elseif strcmp(p_input, '6')
                    source_model = zeffiro.SourceModel.ContinuousStVenant;
                else
                    source_model = zeffiro.SourceModel.Error;
                end

            end

            % If no valid source model was found along the way…

            if source_model == zeffiro.SourceModel.Error
                warning(strcat( ...
                    "The source model was not set properly. Needs to be initialized with one of the known values ", ...
                    "{" , num2str(KNOWN_INTEGERS), "}." ...
                    ));
            end

        end % from

        function vars = variants()

            % zeffiro.SourceModel.variants
            %
            % A constant function that generates an array of the variants of the
            % zeffiro.SourceModel enumeration.
            %
            % Output:
            %
            % - vars
            %
            %   A column vector of the variants. NOTE: the collection includes the
            %   Error variant, which needs to be accounted for, if only valid
            %   variants are wanted.

            % A bit funny, but this is necessary for listing the variants
            % without invoking a constructor.

            source_model = zeffiro.SourceModel.Hdiv;

            % Generate the list of variants.

            vars = enumeration(source_model);

        end

    end % methods (Static)

    methods

        function str = to_string(variant)

            % zeffiro.SourceModel.to_string
            %
            % Converts a given zeffiro.SourceModel variant to a string.
            %
            % Input:
            %
            % - source_model
            %
            %   A zeffiro.SourceModel variant.
            %
            % Output
            %
            % - str
            %
            %   A string representation of the given variant. "None", if given
            %   variant does not exist.

            switch variant

                case zeffiro.SourceModel.Whitney

                    str = "Whitney";

                case zeffiro.SourceModel.Hdiv

                    str = "H(div)";

                case zeffiro.SourceModel.StVenant

                    str = "St. Venant";

                case zeffiro.SourceModel.ContinuousWhitney

                    str = "Continuous Whitney";

                case zeffiro.SourceModel.ContinuousHdiv

                    str = "Continuous H(div)";

                case zeffiro.SourceModel.ContinuousStVenant

                    str = "Continuous St. Venant";

                case zeffiro.SourceModel.Error

                    str = "Error";

                otherwise

                    str = "None";

            end % switch

        end % function

    end % methods

end % classdef
