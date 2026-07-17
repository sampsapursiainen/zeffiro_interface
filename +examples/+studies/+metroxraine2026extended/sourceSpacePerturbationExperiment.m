function sourceSpacePerturbationExperiment(projectFilePath, compartmentOfInterest)
%
% sourceSpacePerturbationExperiment(projectFilePath, compartmentOfInterest)
%
% Tehdään koe, jossa lähdepaikkaa siirretään etäisyyden $\Delta\sourcePosition$ verran ja sitten katsotaan, miten $\leadFieldMatrix$:n normi ko lähdepisteessä eroaa vanhasta.
%

    arguments
        projectFilePath (1,1) string { mustBeFile }
        compartmentOfInterest (1,1) string = "CEREBRAL-CORTEX"
    end

    disp("Opening " + projectFilePath + "...")

    matFile = matfile(projectFilePath) ;

    disp("Finding label of given compartment " + compartmentOfInterest + "...")

    compartmentLabelInMatFile = zeffiro.utilities.compartmentLabelsFromProjectFile(projectFilePath, compartmentOfInterest) ;

    disp("Finding tetra indices with label " + compartmentLabelInMatFile +  "...")

    compartmentTetraInds = find(matFile.domain_labels == compartmentLabelInMatFile) ;

    disp("Extracting tetra from " + projectFilePath + "...")

    tetra = matFile.tetra ;

    compartmentTetra = tetra(compartmentTetraInds,:) ;

    disp("Finding facet-based neighbours of tetra within " + compartmentOfInterest + "...")

    [elementNeighbours, localConnectingFacets] = zeffiro.geometry.findElementFacetNeighbours(compartmentTetra) ;

    disp("Finding elements with all 4 neighbours within " + compartmentOfInterest + "...")

    counts = histcounts(elementNeighbours(:,1), size(compartmentTetra,1)) ;

    elementsWith4Neighbours = find(counts > 3) ;

    disp("Finding nodes in mesh nearest to source positions...")

    nodes = matFile.nodes ;

    sourcePositions = matFile.source_positions ;

    nodesNearestToSourcePositions = knnsearch(nodes, sourcePositions) ;

    tetrasContainingNearestNodes = find(any(ismember(tetra, nodesNearestToSourcePositions),2)) ;

    % TODO: check which of the above tetras actually contains which source position.

    % TODO: move a source to the neighbouring element.

    % TODO: more things to come?

    error("Not fully implemented yet...")

end % function
