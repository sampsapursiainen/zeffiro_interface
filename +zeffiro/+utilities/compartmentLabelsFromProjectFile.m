function outputLabels = compartmentLabelsFromProjectFile(projectFilePath, compartmentNames, kwargs)
%
%   outputLabels = compartmentLabelsFromProjectFile(projectFilePath, compartmentNames, kwargs)
%
% Retrieves the compartment labels of a given set of compartment names from a given project file path.
%

    arguments
        projectFilePath (1,1) string { mustBeFile }
        compartmentNames (1,:) string
        kwargs.compartmentLabelFieldName (1,1) string = "domain_labels"
        kwargs.compartmentTagFieldName (1,1) string = "compartment_tags"
        kwargs.compartmentTagFieldSuffix (1,1) string = "_name"
    end

    matFile = matfile(projectFilePath) ;

    compartmentLabels = unique(matFile.(kwargs.compartmentLabelFieldName)) ;

    compartmentTags = matFile.(kwargs.compartmentTagFieldName) ;

    compartmentNameFields = compartmentTags + kwargs.compartmentTagFieldSuffix ;

    compartmentNamesInMatFile = repmat("", numel(compartmentLabels),1) ;

    for ii = 1 : numel(compartmentNameFields)

        compartmentNamesInMatFile(ii) = matFile.(compartmentNameFields(ii)) ;

    end % for

    outputLabels = zeros(size(compartmentNames)) ;

    for jj = 1 : numel(compartmentNames)

        possibleIndex = find(compartmentNames(jj) == compartmentNamesInMatFile) ;

        if not(isempty(possibleIndex))

            outputLabels(jj) = possibleIndex ;

        else

            warning("Ignoring compartment name " + compartmentNames(jj) + " because it was not found in the given project file. Setting the corresponding index to -1 in the output file.")

            outputLabels(jj) = -1 ;

        end % if

    end % for

end % function
