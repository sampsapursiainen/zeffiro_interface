function leadFieldComparison(dataFilePattern,refFileName,outFolderName,lowerQ,upperQ,kwargs)
%
% leadFieldComparison(dataFilePattern,refFileName,outFolderName)
%
% Computes relative differences between Lnew - Lref and Llin - Lref,
% where the lead fields are stored in specific files.
%

    arguments
        dataFilePattern (1,1) string
        refFileName (1,1) string { mustBeFile }
        outFolderName (1,1) string { mustBeFolder }
        lowerQ (1,1) double { mustBeInRange(lowerQ, 0, 1) } = 0.10
        upperQ (1,1) double { mustBeGreaterThan(upperQ,lowerQ), mustBeLessThanOrEqual(upperQ,1) } = 0.90
        kwargs.numBins (1,1) int32 { mustBePositive } = 30
        kwargs.figHandle (1,1) double { mustBeInteger, mustBePositive } = 100
    end

    disp ("Loading reference lead field " + refFileName + " from disk...") ;

    refFile = matfile (refFileName) ;

    disp ("Transposing reference lead field...")

    refL = transpose (refFile.L) ;

    disp ("Reading data file names from " + dataFilePattern + "...") ;

    dataFolderStructs = dir (dataFilePattern) ;

    dataFileNames = arrayfun ( @(entry) string (entry.name), dataFolderStructs ) ;

    disp ("Generating figure, axes and their cleanup object...")

    fig = figure (kwargs.figHandle) ;

    ax = axes (fig) ;

    cleanupObj = onCleanup( @() cleanupFn (fig) );

    disp ("Starting data analysis...")

    aN = numel (dataFileNames) ;

    for ii = 1 : aN

        dataFileName = dataFileNames (ii) ;

        disp ("File " + dataFileName + "(" + ii + " / " + aN + ")") ;

        rDD = performComparison (refL, dataFileName) ;

        relDiffDisp = rDD ( rDD >= quantile (rDD,lowerQ) & rDD <= quantile (rDD,upperQ) ) ;

        disp ("Plotting histogram...")

        title (ax, dataFileName) ;

        xlabel(ax,"Volume current xyz-coordinates") ;

        ylabel ("electrode") ;

        histogram ( ax, relDiffDisp, kwargs.numBins ) ;

        outFilePath = fullfile ( outFolderName, dataFileName + ".fig" ) ;

        disp ("Saving figure to " + outFilePath) ;

        savefig(fig, outFilePath) ;

        disp  ("Clearing axes for next round...")

        cla (ax) ;

    end % for

    disp ("Done")

end % function

%% Helper functions.

function relDiffDiff = performComparison (refL, dataFileName)

    arguments
        refL (:,:) double { mustBeFinite }
        dataFileName (1,1) string { mustBeFile }
    end

    disp ("Opening file " + dataFileName + "...") ;

    dataFile = matfile (dataFileName) ;

    disp ("Loading and transposing newL...")

    newL = transpose (dataFile.newL) ;

    disp ("Loading and transposing newLLin...")

    newLLin = transpose (dataFile.newLLin) ;

    disp ("Computing differences between reference L...")

    refDiff = newL - refL ;

    linDiff = newLLin - refL ;

    disp ("Computing relative difference of differences...") ;

    relDiffDiff = tests.relativeDifference (linDiff, refDiff) ;

end % function

function cleanupFn (fig)
    disp('Closing figure...')
    close(fig)
end % function
