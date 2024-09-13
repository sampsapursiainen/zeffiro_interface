classdef ZefSourceModel

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
        % Converts a struct or a ZefSourceModel loaded from a .mat file into a
        % valid in-memory object of this type.
        %

            arguments
                obj_or_struct (1,1)
            end

            classname = string ( class ( obj_or_struct ) ) ;

            % Set a default return value if all else fails.

            self = zefCore.ZefSourceModel.Hdiv ;

            if endsWith ( classname, "ZefSourceModel" )

                self = obj_or_struct ;

            elseif classname == "struct"

                if isfield ( obj_or_struct, "ValueNames" )

                    self = zefCore.ZefSourceModel.from ( obj_or_struct.ValueNames ) ;

                end

            end % if

        end % function

    end % methods

    methods (Static)

        function source_model = from(p_input)

            % A function that creates an instance of the enumeration
            % zefCore.ZefSourceModel based on given p_input. Generates a
            % zefCore.ZefSourceModel.Error on invalid p_input.

            % Assume p_input is invalid. If valid p_input is found, this will
            % change to a valid return value.

            source_model = zefCore.ZefSourceModel.Error;

            % Check that we receive p_input.

            if ~ nargin == 1
                warning('I accept exactly one p_input. Returning erraneous output.')
                return
            end

            % Function is idempotent with respect to given zefCore.ZefSourceModel variants.

            if isenum(p_input)

                switch p_input
                    case zefCore.ZefSourceModel.Error
                        source_model = p_input;
                    case zefCore.ZefSourceModel.Whitney
                        source_model = p_input;
                    case zefCore.ZefSourceModel.Hdiv
                        source_model = p_input;
                    case zefCore.ZefSourceModel.StVenant
                        source_model = p_input;
                    case zefCore.ZefSourceModel.ContinuousWhitney
                        source_model = p_input;
                    case zefCore.ZefSourceModel.ContinuousHdiv
                        source_model = p_input;
                    case zefCore.ZefSourceModel.ContinuousStVenant
                        source_model = p_input;
                    otherwise
                        warning("I received an enum that is not a zefCore.ZefSourceModel. Setting erraneous return value.")
                        source_model = zefCore.ZefSourceModel.Error;
                end

                return

            end

            % If p_input is a real number.

            KNOWN_INTEGERS = [1, 2, 3, 4, 5, 6];

            % Check for valid inputs.

            if isreal(p_input)

                if p_input == 1
                    source_model = zefCore.ZefSourceModel.Whitney;
                elseif p_input == 2
                    source_model = zefCore.ZefSourceModel.Hdiv;
                elseif p_input == 3
                    source_model = zefCore.ZefSourceModel.StVenant;
                elseif p_input == 4
                    source_model = zefCore.ZefSourceModel.ContinuousWhitney;
                elseif p_input == 5
                    source_model = zefCore.ZefSourceModel.ContinuousHdiv;
                elseif p_input == 6
                    source_model = zefCore.ZefSourceModel.ContinuousStVenant;
                else
                    source_model = zefCore.ZefSourceModel.Error;
                end

            end

            % If p_input is a character.

            if ischar(p_input) || isstring(p_input)

                if strcmp(p_input, '1')
                    source_model = zefCore.ZefSourceModel.Whitney;
                elseif strcmp(p_input, '2')
                    source_model = zefCore.ZefSourceModel.Hdiv;
                elseif strcmp(p_input, '3')
                    source_model = zefCore.ZefSourceModel.StVenant;
                elseif strcmp(p_input, '4')
                    source_model = zefCore.ZefSourceModel.ContinuousWhitney;
                elseif strcmp(p_input, '5')
                    source_model = zefCore.ZefSourceModel.ContinuousHdiv;
                elseif strcmp(p_input, '6')
                    source_model = zefCore.ZefSourceModel.ContinuousStVenant;
                else
                    source_model = zefCore.ZefSourceModel.Error;
                end

            end

            % If no valid source model was found along the way…

            if source_model == zefCore.ZefSourceModel.Error
                warning(strcat( ...
                    "The source model was not set properly. Needs to be initialized with one of the known values ", ...
                    "{" , num2str(KNOWN_INTEGERS), "}." ...
                    ));
            end

        end % from

        function vars = variants()

            % zefCore.ZefSourceModel.variants
            %
            % A constant function that generates an array of the variants of the
            % zefCore.ZefSourceModel enumeration.
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

            source_model = zefCore.ZefSourceModel.Hdiv;

            % Generate the list of variants.

            vars = enumeration(source_model);

        end

    end % methods (Static)

    methods

        function str = to_string(variant)

            % zefCore.ZefSourceModel.to_string
            %
            % Converts a given zefCore.ZefSourceModel variant to a string.
            %
            % Input:
            %
            % - source_model
            %
            %   A zefCore.ZefSourceModel variant.
            %
            % Output
            %
            % - str
            %
            %   A string representation of the given variant. "None", if given
            %   variant does not exist.

            switch variant

                case zefCore.ZefSourceModel.Whitney

                    str = "Whitney";

                case zefCore.ZefSourceModel.Hdiv

                    str = "H(div)";

                case zefCore.ZefSourceModel.StVenant

                    str = "St. Venant";

                case zefCore.ZefSourceModel.ContinuousWhitney

                    str = "Continuous Whitney";

                case zefCore.ZefSourceModel.ContinuousHdiv

                    str = "Continuous H(div)";

                case zefCore.ZefSourceModel.ContinuousStVenant

                    str = "Continuous St. Venant";

                case zefCore.ZefSourceModel.Error

                    str = "Error";

                otherwise

                    str = "None";

            end % switch

        end % function

    end % methods

end % classdef
