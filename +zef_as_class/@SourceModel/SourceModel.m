classdef SourceModel

    % An enumeration of the different source- or interpolation models used by
    % Zeffiro Interface.

    enumeration
        Hdiv, ...
        Whitney, ...
        StVenant, ...
        ContinuousHdiv, ...
        ContinuousWhitney, ...
        ContinuousStVenant, ...
        Error ...
    end

    methods (Static)

        function source_model = from(p_input)

            % A function that creates an instance of the enumeration
            % SourceModel based on given p_input. Generates a
            % SourceModel.Error on invalid p_input.

            % Assume p_input is invalid. If valid p_input is found, this will
            % change to a valid return value.

            source_model = SourceModel.Error;

            % Check that we receive p_input.

            if ~ nargin == 1
                warning('I accept exactly one p_input. Returning erraneous output.')
                return
            end

            % Function is idempotent with respect to given SourceModel
            % variants.

            if isenum(p_input)

                switch p_input
                    case SourceModel.Error
                        source_model = p_input;
                    case SourceModel.Whitney
                        source_model = p_input;
                    case SourceModel.Hdiv
                        source_model = p_input;
                    case SourceModel.StVenant
                        source_model = p_input;
                    case SourceModel.ContinuousWhitney
                        source_model = p_input;
                    case SourceModel.ContinuousHdiv
                        source_model = p_input;
                    case SourceModel.ContinuousStVenant
                        source_model = p_input;
                    otherwise
                        warning("I received an enum that is not a SourceModel. Setting erraneous return value.")
                        source_model = SourceModel.Error;
                end

                return

            end

            % If p_input is a real number.

            KNOWN_INTEGERS = [1, 2, 3, 4, 5, 6];

            % Check for valid inputs.

            if isreal(p_input)

                if p_input == 1
                    source_model = SourceModel.Whitney;
                elseif p_input == 2
                    source_model = SourceModel.Hdiv;
                elseif p_input == 3
                    source_model = SourceModel.StVenant;
                elseif p_input == 4
                    source_model = SourceModel.ContinuousWhitney;
                elseif p_input == 5
                    source_model = SourceModel.ContinuousHdiv;
                elseif p_input == 6
                    source_model = SourceModel.ContinuousStVenant;
                else
                    source_model = SourceModel.Error;
                end

            end

            % If p_input is a character.

            if ischar(p_input) || isstring(p_input)

                if strcmp(p_input, '1')
                    source_model = SourceModel.Whitney;
                elseif strcmp(p_input, '2')
                    source_model = SourceModel.Hdiv;
                elseif strcmp(p_input, '3')
                    source_model = SourceModel.StVenant;
                elseif strcmp(p_input, '4')
                    source_model = SourceModel.ContinuousWhitney;
                elseif strcmp(p_input, '5')
                    source_model = SourceModel.ContinuousHdiv;
                elseif strcmp(p_input, '6')
                    source_model = SourceModel.ContinuousStVenant;
                else
                    source_model = SourceModel.Error;
                end

            end

            % If no valid source model was found along the way…

            if source_model == SourceModel.Error
                warning(strcat( ...
                    "The source model was not set properly. Needs to be initialized with one of the known values ", ...
                    "{" , num2str(KNOWN_INTEGERS), "}." ...
                ));
            end

        end % from

        function vars = variants()

            % SourceModel.variants
            %
            % A constant function that generates an array of the variants of the
            % SourceModel enumeration.
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

            source_model = SourceModel.Hdiv;

            % Generate the list of variants.

            vars = enumeration(source_model);

        end

    end % methods (Static)

    methods

        function str = to_string(variant)

            % SourceModel.to_string
            %
            % Converts a given SourceModel variant to a string.
            %
            % Input:
            %
            % - source_model
            %
            %   A SourceModel variant.
            %
            % Output
            %
            % - str
            %
            %   A string representation of the given variant. "None", if given
            %   variant does not exist.

            switch variant

                case SourceModel.Whitney

                    str = "Whitney";

                case SourceModel.Hdiv

                    str = "H(div)";

                case SourceModel.StVenant

                    str = "St. Venant";

                case SourceModel.ContinuousWhitney

                    str = "Continuous Whitney";

                case SourceModel.ContinuousHdiv

                    str = "Continuous H(div)";

                case SourceModel.ContinuousStVenant

                    str = "Continuous St. Venant";

                case SourceModel.Error

                    str = "Error";

                otherwise

                    str = "None";

            end % switch

        end % function

    end % methods

end % classdef
