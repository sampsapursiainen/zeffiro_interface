function [firstVertices, secondVertices] = sourceSpacePerturbationExperiment(projectFilePath, compartmentOfInterest)
%
%   [firstVertices, secondVertices] = sourceSpacePerturbationExperiment(projectFilePath, compartmentOfInterest)
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

    disp("Extracting tetra from " + projectFilePath + "...")

    tetra = matFile.tetra ;

    disp("Extracting active compartment indices...")

    compartmentTypeTable = matFile.reuna_type

    compartmentActivityVector = cell2mat(compartmentTypeTable(:,1)) ;

    activeCompartmentLabels = find(compartmentActivityVector > 0 & compartmentActivityVector < 3)

    disp("Extracting domain labels from " + projectFilePath + "...")

    domainLabels = matFile.domain_labels ;

    disp("Selecting active tetrahedra...")

    activeTetraMask = ismember(domainLabels(:), activeCompartmentLabels) ;

    activeTetraIndices = find(activeTetraMask) ;

    activeTetra = tetra(activeTetraMask,:) ;

    disp("Finding facet-based neighbours of tetra within active compartments...")

    [localElementNeighbours, localConnectingFacets] = zeffiro.geometry.findElementFacetNeighbours(activeTetra) ;

    localElementNeighbours(1:10,:)

    localConnectingFacets(1:10,:)

    disp("Mapping local element neighbour indices to global ones...")

    globalElementNeighbours = localElementNeighbours ;

    globalElementNeighbours(:,1) = activeTetraIndices(localElementNeighbours(:,1)) ;

    globalConnetingFacets = localConnectingFacets ;

    globalConnectingFacets(:,1) = activeTetraIndices(localConnectingFacets(:,1)) ;

    disp("Counting elements in compartment adjacency array with all 4 neighbours within " + compartmentOfInterest + "...")

    neighbourCounts = histcounts(localElementNeighbours(:,1), size(activeTetra,1)) ;

    neighbourCounts = neighbourCounts(:) ;

    disp("Taking elements which have 4 neighbours...")

    elementsWith4Neighbours = activeTetra(neighbourCounts > 3,:) ;

    size(elementsWith4Neighbours)

    disp("Finding vertices of 4-neighbour elements...")

    verticesOfElementsWith4Neighbours = zeffiro.geometry.elementVertices(transpose(elementsWith4Neighbours),transpose(nodes)) ;

    disp("Taking first vertices of each element...")

    firstVertices = squeeze(verticesOfElementsWith4Neighbours(:,1,:)) ;

    disp("Finding vertices opposing first vertices in adjacent tetra...")

    % Local facet ii of each tetra opposes node ii within the same tetrahedron,
    % so we first find out where tetra connect to others through node 1 and then
    % index in the other direction to find which facet in a neighbouring tetrahedron
    % connects back to the original one. Then pick the opposing node corresponding to this facet.

    [dimension, vertexN, cellN] = size(verticesOfElementsWith4Neighbours) ;

    localStartElements = localConnectingFacets(:,1) ;

    firstFacetMask = localConnectingFacets(:,2) == 1 ;

    neighboursThroughFacet1 = localElementNeighbours(firstFacetMask,2) ;

    disp("Finding back edges...")

    backEdgeMask = ismember(localElementNeighbours(:,1), neighboursThroughFacet1) ...
        & ismember(localElementNeighbours(:,2), localStartElements) ;

    localFacetsConnectingBack = localConnectingFacets( ...
        backEdgeMask, ...
        2 ...
    ) ;

    disp("Finding opposing vertices in neighbours based on facet indices...")

    secondVertices = inf(dimension, cellN) ;

    for ii = 1 : cellN

        secondVertices(:,ii) = verticesOfElementsWith4Neighbours(:, localFacetsConnectingBack(ii), ii) ;

    end % for

    % TODO: form linspaces between first vertices of start elements and opposing vertices in neighbours corresponding to localFacetsConnectingBack.

    % TODO: more things to come?

    warning("Not fully implemented yet...")

end % function
