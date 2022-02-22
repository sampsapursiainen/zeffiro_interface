function val = validatedPropValue(cluster, prop, type, defaultValue)

% This function will be used to determine the value of a property,
% whether it is an assigned value or a default value.  If no property
% value is assgined by the user, a default value for that data type will
% be used.  Some properties will have a different default value, so for 
% those values, we will include a default value we want them to be set to.

% Copyright 2019 The MathWorks, Inc.

% Determine if the property exists
if isprop(cluster.AdditionalProperties, prop)
    val = cluster.AdditionalProperties.(prop);
    typeVal = class(val);
    % If the property does exist and it is not empty, we want to verify
    % that it is set to the correct type: char, double, or logical.
    if ~isempty(val)
        if strcmp(type, 'char') && ~isa(val, 'char')
            error('Expected property value for ''%s'' should be string, but is %s.', prop, typeVal)
        elseif strcmp(type, 'double') && ~isa(val, 'double')
            error('Expected property value for ''%s'' should be double, but is %s.', prop, typeVal)
        elseif strcmp(type, 'bool') && ~isa(val, 'logical')
            error('Expected property value for ''%s'' should be bool, but is %s.', prop, typeVal)
        else
            % The property exists and is not empty, bail out
            return
        end
    end
else
    % The property does not exist.  Based on the type, set value to a default value.
    switch type
        case 'char'
            val = '';
        case 'double'
            val = 0;
        case 'bool'
            val = false;
        otherwise
            error('Not a valid data type')
    end
end

% If we pass in a defaultValue, that means we want this property
% to be set to a specific value.
if nargin == 4
    val = defaultValue;
end
