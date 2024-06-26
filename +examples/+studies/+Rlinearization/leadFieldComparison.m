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

    tiledlayout (fig,2,1) ;

    realAx = nexttile ;

    imagAx = nexttile ;

    cleanupObj = onCleanup( @() cleanupFn (fig) );

    disp ("Starting data analysis...")

    aN = numel (dataFileNames) ;

    for ii = 1 : aN

        dataFileName = dataFileNames (ii) ;

        disp ("File " + dataFileName + "(" + ii + " / " + aN + ")") ;

        [ realDiff, imagDiff ] = performComparison (refL, dataFileName) ;

        realDiffDisp = realDiff ( realDiff >= quantile (realDiff,lowerQ) & realDiff <= quantile (realDiff,upperQ) ) ;

        imagDiffDisp = imagDiff ( imagDiff >= quantile (imagDiff,lowerQ) & imagDiff <= quantile (imagDiff,upperQ) ) ;

        disp ("Plotting histogram...")

        histogram ( realAx, realDiffDisp, kwargs.numBins, FaceColor=[0, 0.4470, 0.7410] ) ;

        histogram ( imagAx, imagDiffDisp, kwargs.numBins, FaceColor=[0.6350, 0.0780, 0.1840] ) ;

        outFilePath = fullfile ( outFolderName, dataFileName + ".fig" ) ;

        disp ("Saving figure to " + outFilePath) ;

        title (realAx, "real " + dataFileName, Interpreter="none" ) ;

        title (imagAx, "imag " + dataFileName, Interpreter="none" ) ;

        xlabel (imagAx,"( (LLin - Lref) - (Lnew - Lref) ) / (Lnew - Lref)", Interpreter="none") ;

        ylabel (realAx,"samples", Interpreter="none") ;

        ylabel (imagAx,"samples", Interpreter="none") ;

        savefig(fig, outFilePath) ;

        disp  ("Clearing axes for next round...")

        cla (realAx) ;

        cla (imagAx) ;

    end % for

    disp ("Done")

end % function

%% Helper functions.

function [ realDiff, imagDiff ] = performComparison (refL, dataFileName)

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

    realDiff = tests.relativeError (real(linDiff), real(refDiff)) ;

    imagDiff = tests.relativeError (imag(linDiff), imag(refDiff)) ;

end % function

function cleanupFn (fig)
    disp('Closing figure...')
    close(fig)
end % function
