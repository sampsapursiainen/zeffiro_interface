classdef ZefSourceModel

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
            % ZefSourceModel based on given p_input. Generates a
            % ZefSourceModel.Error on invalid p_input.

            % Assume p_input is invalid. If valid p_input is found, this will
            % change to a valid return value.

            source_model = ZefSourceModel.Error;

            % Check that we receive p_input.

            if ~ nargin == 1
                warning('I accept exactly one p_input. Returning erraneous output.')
                return
            end

            % Function is idempotent with respect to given ZefSourceModel variants.

            if isenum(p_input)

                switch p_input
                    case ZefSourceModel.Error
                        source_model = p_input;
                    case ZefSourceModel.Whitney
                        source_model = p_input;
                    case ZefSourceModel.Hdiv
                        source_model = p_input;
                    case ZefSourceModel.StVenant
                        source_model = p_input;
                    case ZefSourceModel.ContinuousWhitney
                        source_model = p_input;
                    case ZefSourceModel.ContinuousHdiv
                        source_model = p_input;
                    case ZefSourceModel.ContinuousStVenant
                        source_model = p_input;
                    otherwise
                        warning("I received an enum that is not a ZefSourceModel. Setting erraneous return value.")
                        source_model = ZefSourceModel.Error;
                end

                return

            end

            % If p_input is a real number.

            KNOWN_INTEGERS = [1, 2, 3, 4, 5, 6];

            % Check for valid inputs.

            if isreal(p_input)

                if p_input == 1
                    source_model = ZefSourceModel.Whitney;
                elseif p_input == 2
                    source_model = ZefSourceModel.Hdiv;
                elseif p_input == 3
                    source_model = ZefSourceModel.StVenant;
                elseif p_input == 4
                    source_model = ZefSourceModel.ContinuousWhitney;
                elseif p_input == 5
                    source_model = ZefSourceModel.ContinuousHdiv;
                elseif p_input == 6
                    source_model = ZefSourceModel.ContinuousStVenant;
                else
                    source_model = ZefSourceModel.Error;
                end

            end

            % If p_input is a character.

            if ischar(p_input) || isstring(p_input)

                if strcmp(p_input, '1')
                    source_model = ZefSourceModel.Whitney;
                elseif strcmp(p_input, '2')
                    source_model = ZefSourceModel.Hdiv;
                elseif strcmp(p_input, '3')
                    source_model = ZefSourceModel.StVenant;
                elseif strcmp(p_input, '4')
                    source_model = ZefSourceModel.ContinuousWhitney;
                elseif strcmp(p_input, '5')
                    source_model = ZefSourceModel.ContinuousHdiv;
                elseif strcmp(p_input, '6')
                    source_model = ZefSourceModel.ContinuousStVenant;
                else
                    source_model = ZefSourceModel.Error;
                end

            end

            % If no valid source model was found along the way…

            if source_model == ZefSourceModel.Error
                warning(strcat( ...
                    "The source model was not set properly. Needs to be initialized with one of the known values ", ...
                    "{" , num2str(KNOWN_INTEGERS), "}." ...
                ));
            end

        end % from

        function vars = variants()

            % ZefSourceModel.variants
            %
            % A constant function that generates an array of the variants of the
            % ZefSourceModel enumeration.
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

            source_model = ZefSourceModel.Hdiv;

            % Generate the list of variants.

            vars = enumeration(source_model);

        end

    end % methods (Static)

    methods

        function str = to_string(variant)

            % ZefSourceModel.to_string
            %
            % Converts a given ZefSourceModel variant to a string.
            %
            % Input:
            %
            % - source_model
            %
            %   A ZefSourceModel variant.
            %
            % Output
            %
            % - str
            %
            %   A string representation of the given variant. "None", if given
            %   variant does not exist.

            switch variant

                case ZefSourceModel.Whitney

                    str = "Whitney";

                case ZefSourceModel.Hdiv

                    str = "H(div)";

                case ZefSourceModel.StVenant

                    str = "St. Venant";

                case ZefSourceModel.ContinuousWhitney

                    str = "Continuous Whitney";

                case ZefSourceModel.ContinuousHdiv

                    str = "Continuous H(div)";

                case ZefSourceModel.ContinuousStVenant

                    str = "Continuous St. Venant";

                case ZefSourceModel.Error

                    str = "Error";

                otherwise

                    str = "None";

            end % switch

        end % function

    end % methods

end % classdef
