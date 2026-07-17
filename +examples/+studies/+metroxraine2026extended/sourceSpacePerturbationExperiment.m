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

    elementNeighbours(1:20,:)

    localConnectingFacets(1:20,:)

    disp("Finding elements with all 4 neighbours...")

    counts = histcounts(elementNeighbours(:,1), size(compartmentTetra,1)) ;

    counts(1:20)

    size(counts)

    size(compartmentTetra)

    elementsWith4Neighbours = find(counts > 3) ;

    elementsWith4Neighbours(end)

end % function
