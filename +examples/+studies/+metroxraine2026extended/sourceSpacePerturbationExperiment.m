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

    localConnectingFacets(1:10,:)

    disp("Mapping local element neighbour indices to global ones...")

    globalElementNeighbours = localElementNeighbours ;

    globalElementNeighbours(:,1) = compartmentTetraInds(localElementNeighbours(:,1)) ;

    globalElementNeighbours(1:10,:)

    globalConnetingFacets = localConnectingFacets ;

    globalConnectingFacets(:,1) = compartmentTetraInds(localConnectingFacets(:,1)) ;

    disp("Counting elements in compartment adjacency array with all 4 neighbours within " + compartmentOfInterest + "...")

    neighbourCounts = histcounts(localElementNeighbours(:,1), size(compartmentTetra,1)) ;

    neighbourCounts = neighbourCounts(:) ;

    disp("Taking elements which have 4 neighbours...")

    elementsWith4Neighbours = compartmentTetra(neighbourCounts > 3,:) ;

    size(elementsWith4Neighbours)

    disp("Finding vertices of 4-neighbour elements...")

    verticesOfElementsWith4Neighbours = zeffiro.geometry.elementVertices(transpose(elementsWith4Neighbours),transpose(nodes)) ;

    disp("Taking first vertices of each element...")

    firstVertices = verticesOfElementsWith4Neighbours(:,1,:) ;

    disp("Finding vertices opposing first vertices in adjacent tetra...")

    % Local facet ii of each tetra opposes node ii within the same tetrahedron,
    % so we first find out where tetra connect to others through node 1 and then
    % index in the other direction to find which facet in a neighbouring tetrahedron
    % connects back to the original one. Then pick the opposing node corresponding to this facet.

    localStartElements = localConnectingFacets(:,1) ;

    firstFacetMask = localConnectingFacets(:,2) == 1 ;

    neighboursThroughFacet1 = localElementNeighbours(firstFacetMask,2) ;

    backEdgeMask = ismember(localElementNeighbours(:,1), neighboursThroughFacet1) ...
        & ismember(localElementNeighbours(:,2), localStartElements) ;

    localFacetsConnectingBack = localConnectingFacets( ...
        backEdgeMask, ...
        2 ...
    ) ;

    % TODO: find out why this does not work. The intention is to one column from each vertex array page.

    secondVertices = verticesOfElementsWith4Neighbours(:,localFacetsConnectingBack,:)

    % TODO: form linspaces between first verticves of start elements and opposing vertices in neighbours corresponding to localFacetsConnectingBack.

    % TODO: more things to come?

    error("Not fully implemented yet...")

end % function
