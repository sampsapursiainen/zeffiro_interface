classdef ZefSourceModel

    % An enumeration of the different source- or interpolation models used by
    % Zeffiro Interface.

    enumeration
        Hdiv, ...
        Whitney, ...
        StVenant, ...
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
                    otherwise
                        warning("I received an enum that is not a ZefSourceModel. Setting erraneous return value.")
                        source_model = ZefSourceModel.Error;
                end

                return

            end

            % If p_input is a real number.

            KNOWN_INTEGERS = [1, 2, 3];

            % Check for valid inputs.

            if isreal(p_input)

                if p_input == 1
                    source_model = ZefSourceModel.Whitney;
                elseif p_input == 2
                    source_model = ZefSourceModel.Hdiv;
                elseif p_input == 3
                    source_model = ZefSourceModel.StVenant;
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

    end % methods (Static)

end % classdef
