function leadFieldComparison(dataFilePattern,dataFileName,outFolderName,lowerQ,upperQ,kwargs)
%
% leadFieldComparison(dataFilePattern,dataFileName,outFolderName)
%
% Computes relative differences between Lnew - Lref and Llin - Lref,
% where the lead fields are stored in specific files.
%

    arguments
        dataFilePattern (1,1) string
        dataFileName (1,1) string { mustBeFile }
        outFolderName (1,1) string { mustBeFolder }
        lowerQ (1,1) double { mustBeInRange(lowerQ, 0, 1) } = 0.10
        upperQ (1,1) double { mustBeGreaterThan(upperQ,lowerQ), mustBeLessThanOrEqual(upperQ,1) } = 0.90
        kwargs.numBins (1,1) int32 { mustBePositive } = 50
        kwargs.figHandle (1,1) double { mustBeInteger, mustBePositive } = 100
        kwargs.initLName (1,1) string = "L"
        kwargs.refLName (1,1) string = "refL"
        kwargs.linLName (1,1) string = "linL"
        kwargs.comparisonFn (1,1) function_handle = @tests.relativeError
    end

    disp ("Loading reference lead field " + dataFileName + " from disk...") ;

    dataFile = matfile (dataFileName) ;

    disp ("Loading and transposing initial lead field...")

    refL = transpose ( dataFile.(kwargs.initLName) ) ;

    disp ("Reading data file names from " + dataFilePattern + "...") ;

    dataFolderStructs = dir (dataFilePattern) ;

    dataFileNames = arrayfun ( @(entry) string (entry.name), dataFolderStructs ) ;

    disp ("Generating figure, axes and their cleanup object...")

    fig = figure (kwargs.figHandle) ;

    tiledlayout (fig,2,1) ;

    realAx = nexttile ;

    imagAx = nexttile ;

    cleanupObj = onCleanup( @() cleanupFn (fig) );

    disp ("Starting data analysis...")

    aN = numel (dataFileNames) ;

    xString = string ( char (kwargs.comparisonFn) ) ;

    for ii = 1 : aN

        dataFileName = dataFileNames (ii) ;

        [ ~, fname, ~ ] = fileparts (dataFileName) ;

        disp ("File " + dataFileName + "(" + ii + " / " + aN + ")") ;

        [ realDiff, imagDiff ] = performComparison (refL, dataFileName,kwargs.refLName,kwargs.linLName,kwargs.comparisonFn) ;

        realDiffDisp = realDiff ( realDiff >= quantile (realDiff,lowerQ) & realDiff <= quantile (realDiff,upperQ) ) ;

        imagDiffDisp = imagDiff ( imagDiff >= quantile (imagDiff,lowerQ) & imagDiff <= quantile (imagDiff,upperQ) ) ;

        disp ("Plotting histogram...")

        histogram ( realAx, realDiffDisp, kwargs.numBins, FaceColor=[0, 0.4470, 0.7410] ) ;

        histogram ( imagAx, imagDiffDisp, kwargs.numBins, FaceColor=[0.6350, 0.0780, 0.1840] ) ;

        outFilePath = fullfile ( outFolderName, fname + ".fig" ) ;

        disp ("Saving figure to " + outFilePath) ;

        title (realAx, fname, Interpreter="none" ) ;

        xlabel (imagAx, xString, Interpreter="none") ;

        ylabel (realAx,"real samples", Interpreter="none") ;

        ylabel (imagAx,"imag samples", Interpreter="none") ;

        savefig(fig, outFilePath) ;

        disp  ("Clearing axes for next round...")

        cla (realAx) ;

        cla (imagAx) ;

    end % for

    disp ("Done")

end % function

%% Helper functions.

function [ realDiff, imagDiff ] = performComparison (origL, dataFileName, refLName, linLName, comparisonFn)

    arguments
        origL (:,:) double { mustBeFinite }
        dataFileName (1,1) string { mustBeFile }
        refLName (1,1) string
        linLName (1,1) string
        comparisonFn (1,1) function_handle
    end

    disp ("Opening file " + dataFileName + "...") ;

    dataFile = matfile (dataFileName) ;

    disp ("Loading and transposing " + refLName + "...")

    refL = dataFile.(refLName) ;

    refL = transpose (refL) ;

    disp ("Loading and transposing " + linLName + "...")

    linL = dataFile.(linLName) ;

    linL = transpose (linL) ;

    disp ("Computing differences between reference L...")

    refDiff = refL - origL ;

    linDiff = linL - origL ;

    disp ("Computing relative difference of differences...") ;

    realDiff = comparisonFn (real(linDiff), real(refDiff)) ;

    imagDiff = comparisonFn (imag(linDiff), imag(refDiff)) ;

end % function

function cleanupFn (fig)
    disp('Closing figure...')
    close(fig)
end % function
