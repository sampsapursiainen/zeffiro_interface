function leadFieldComparison(dataFolderName,refFileName,outFolderName,lowerQ,upperQ,kwargs)
%
% leadFieldComparison(dataFolderName,refFileName,outFolderName)
%
% Computes relative differences between Lnew - Lref and Llin - Lref,
% where the lead fields are stored in specific files.
%

    arguments
        dataFolderName (1,1) string { mustBeFolder }
        refFileName (1,1) string { mustBeFile }
        outFolderName (1,1) string { mustBeFolder }
        lowerQ (1,1) double { mustBeInRange(lowerQ, 0, 1) } = 0.10
        upperQ (1,1) double { mustBeGreaterThan(upperQ,lowerQ), mustBeLessThanOrEqual(upperQ,1) } = 0.90
        kwargs.numBins (1,1) int32 { mustBePositive } = 30
        kwargs.figHandle (1,1) int32 { mustBePositive } = 100
    end

    refFile = matfile (refFileName) ;

    refL = transpose (refFile.L) ;

    dataFolderStructs = dir (dataFolderName) ;

    dataFileNames = arrayfun ( @(entry) string (entry.name), dataFolderStructs ) ;

    fig = figure (kwargs.figHandle) ;

    ax = axes (fig) ;

    cleanupObj = onCleanup( @() cleanupFn (fig) );

    for ii = 1 : numel (dataFileNames)

        dataFileName = dataFileNames (ii) ;

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
