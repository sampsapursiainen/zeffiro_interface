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

    disp("Extracting mesh nodes from " + projectFilePath + "...")

    nodes = matFile.nodes ;

    disp("Finding label of given compartment " + compartmentOfInterest + "...")

    compartmentLabelInMatFile = zeffiro.utilities.compartmentLabelsFromProjectFile(projectFilePath, compartmentOfInterest) ;

    disp("Finding tetra indices with label " + compartmentLabelInMatFile +  "...")

    compartmentTetraInds = find(matFile.domain_labels == compartmentLabelInMatFile) ;

    disp("Extracting tetra from " + projectFilePath + "...")

    tetra = matFile.tetra ;

    compartmentTetra = tetra(compartmentTetraInds,:) ;

    disp("Extracting mesh nodes from " + projectFilePath + "...")

    sourcePositionsInFile = matFile.source_positions ;

    disp("Finding facet-based neighbours of tetra within " + compartmentOfInterest + "...")

    [localElementNeighbours, localConnectingFacets] = zeffiro.geometry.findElementFacetNeighbours(compartmentTetra) ;

    localElementNeighbours(1:10,:)

    disp("Mapping local element neighbour indices to global ones...")

    globalElementNeighbours = localElementNeighbours ;

    globalElementNeighbours(:,1) = compartmentTetraInds(localElementNeighbours(:,1)) ;

    globalElementNeighbours(1:10,:)

    globalConnetingFacets = localConnectingFacets ;

    globalConnectingFacets(:,1) = compartmentTetraInds(localConnectingFacets(:,1)) ;

    disp("Counting elements in compartment adjacency array with all 4 neighbours within " + compartmentOfInterest + "...")

    counts = histcounts(localElementNeighbours(:,1), size(compartmentTetra,1)) ;

    counts = counts(:) ;

    disp("Taking elements which have 4 neighbours...")

    elementsWith4Neighbours = compartmentTetra(counts > 3,:) ;

    disp("Finding centroids of 4-neighbour elements...")

    centroidsOfElementsWith4Neighbours = transpose(zeffiro.geometry.elementCentroids(transpose(elementsWith4Neighbours),transpose(nodes))) ;

    sourcePositions = centroidsOfElementsWith4Neighbours ;

    disp("Finding nodes in mesh nearest to source positions...")

    nodesNearestToSourcePositions = knnsearch(nodes, sourcePositions) ;

    tetrasContainingNearestNodes = find(any(ismember(compartmentTetra, nodesNearestToSourcePositions),2)) ;

    % TODO: check which of the above tetras actually contains which source position.

    % TODO: move a source to the neighbouring element.

    % TODO: more things to come?

    error("Not fully implemented yet...")

end % function
