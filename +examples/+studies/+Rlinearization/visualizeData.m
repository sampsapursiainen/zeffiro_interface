function visualizeData (dataFilePattern, dataFieldNames,outFolderName,lowerQ,upperQ,kwargs)
%
% visualizeData (dataFilePattern, dataFieldNames,outFolderName,lowerQ,upperQ,kwargs)
%
% Performs a visualization of given data via a histogram.
%

    arguments
        dataFilePattern (1,1) string
        dataFieldNames (:,1) string
        outFolderName (1,1) string { mustBeFolder }
        lowerQ (1,1) double { mustBeInRange(lowerQ, 0, 1) } = 0
        upperQ (1,1) double { mustBeGreaterThan(upperQ,lowerQ), mustBeLessThanOrEqual(upperQ,1) } = 1
        kwargs.numBins (1,1) int32 { mustBePositive } = 50
        kwargs.figHandle (1,1) double { mustBeInteger, mustBePositive } = 999
        kwargs.xlabels (:,1) string = dataFieldNames
        kwargs.ylabels (:,1) string = repmat ("samples", numel(dataFieldNames), 1)
        kwargs.xinterpreter (1,1) string { mustBeMember(kwargs.xinterpreter, ["none", "tex", "latex"]) } = "none"
        kwargs.yinterpreter (1,1) string { mustBeMember(kwargs.yinterpreter, ["none", "tex", "latex"]) } = "none"
    end

    fieldN = numel (dataFieldNames) ;

    xlabelN = numel (kwargs.xlabels) ;

    ylabelN = numel (kwargs.ylabels) ;

    assert (fieldN == xlabelN, "The number of data field names need to coincide with that of kwargs.xlabels.")

    assert (fieldN == ylabelN, "The number of data field names need to coincide with that of kwargs.ylabels.")

    disp ("Reading data file names from " + dataFilePattern + "...") ;

    dataFolderStructs = dir (dataFilePattern) ;

    dataFileDirs = arrayfun ( @(entry) string (entry.folder), dataFolderStructs ) ;

    dataFileNames = arrayfun ( @(entry) string (entry.name), dataFolderStructs ) ;

    fileN = numel (dataFileNames) ;

    dataFilePaths = fullfile ( dataFileDirs, dataFileNames ) ;

    disp ("Generating figure, axes and their cleanup object...")

    fig = figure (kwargs.figHandle) ;

    tiledlayout (fig,1,1) ;

    ax = nexttile ;

    cleanupObj = onCleanup( @() cleanupFn (fig) );

    disp ("Starting data analysis...")

    for ii = 1 : fileN

        dataFileName = dataFilePaths (ii) ;

        [ ~, fname, ~ ] = fileparts (dataFileName) ;

        disp ("File " + dataFileName + " (" + ii + " / " + fileN + ")") ;

        dataMatFile = matfile (dataFileName) ;

        matFieldNames = string ( fieldnames (dataMatFile) ) ;

        for jj = 1 : fieldN

            fieldName = dataFieldNames (jj) ;

            xLabel = kwargs.xlabels (jj) ;

            yLabel = kwargs.ylabels (jj) ;

            if ~ ismember (fieldName, matFieldNames)

                disp ("Could not find the field " + fieldName + " in " + dataFileName + ". Skipping...") ;

                continue

            end % if

            disp ( fieldName + " / " + xLabel + " (" + jj + "/" + fieldN + ")" ) ;

            fieldData = dataMatFile.(fieldName) ;

            filteredData = fieldData ( fieldData >= quantile (fieldData,lowerQ) & fieldData <= quantile (fieldData,upperQ) ) ;

            disp ("Plotting histogram...")

            histogram ( ax, filteredData, kwargs.numBins, FaceColor=[0, 0.4470, 0.7410] ) ;

            outFilePrefix = fname + "-" + fieldName + "-lowerQ=" + lowerQ + "-upperQ=" + upperQ ;

            figFilePath = fullfile ( outFolderName, outFilePrefix + ".fig" ) ;

            pdfFilePath = fullfile ( outFolderName, outFilePrefix + ".pdf" ) ;

            xlabel (ax, xLabel, Interpreter=kwargs.xinterpreter) ;

            ylabel (ax, yLabel, Interpreter=kwargs.yinterpreter) ;

            disp ("Saving figure to " + figFilePath) ;

            savefig (fig, figFilePath) ;

            disp ("Saving PDF to " + pdfFilePath) ;

            exportgraphics (fig, pdfFilePath, ContentType="vector") ;

            disp  ("Clearing axes for next round...")

            cla (ax) ;

        end % for jj

    end % for ii

    disp ("Done")

end % function

%% Helper functions.

function cleanupFn (fig)
    disp('Closing figure...')
    close(fig)
end % function
