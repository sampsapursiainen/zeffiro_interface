function out = paramFromZefCompartments (zef,paramName)
%
% out = paramFromZefCompartments (zef,paramName)
%
% Reads a parameter such as conductivity from the zef struct fields
% zef.<compartment_tag>_parameter. Requires dynamic construction of variable
% names. Shudder.
%

    arguments
        zef (1,1) struct
        paramName (1,1) string
    end

    % The compartment tags cell array is flipped in relation to the listing
    % seen in the segmentation tool, so we flip it here as well.

    cTags = flip (zef.compartment_tags) ;

    nTags = numel (cTags) ;

    cLabels = zef.domain_labels ;

    nTetra = size (zef.tetra,1) ;

    out = zeros (nTetra,1) ;

    for ii = 1 : nTags

        ctag = cTags {ii} ;

        fieldName = ctag + "_" + paramName ;

        paramVal = zef.(fieldName) ;

        paramI = cLabels == ii ;

        out (paramI) = paramVal ;

    end % for ii

end % function
