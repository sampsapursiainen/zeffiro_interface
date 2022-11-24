function isAnInverter(inverter_candidate)

    %
    % isAnInverter
    %
    % A validator function for checking whether the given argument
    % inverter_candidate is a subclass of inverse.CommonInverseParameters.
    % Throws and exception of this is not the case.
    %

    % This argument validation is here just to enforce exactly one input
    % argument.

    arguments

        inverter_candidate

    end

    if ~ isa(inverter_candidate, "inverse.CommonInverseParameters")

        eidType = 'isAnInverter:notAnInverter';

        msgType = 'Input must be a subclass of CommonInverseParameters.';

        throwAsCaller(MException(eidType,msgType))

    end

end % function
