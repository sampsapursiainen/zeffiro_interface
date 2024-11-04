function figuresWithSameColorScale(zef, zefFigureToolName, dataFilePaths, quantityName, measureFn, kwargs)
%
% figuresWithSameColorScale(zef, zefFigureToolName, dataFilePaths, quantityName, measureFn, kwargs)
%
% Scans a given set of data files for a quantity name, figures out its minima
% and maxima by some measure.
%

    arguments
        zef (1,1) struct
        zefFigureToolName (1,1) string { mustBeValidVariableName }
        dataFilePaths (:,1) string { mustBeFile }
        quantityName (:,1) string { mustBeValidVariableName }
        measureFn (1,1) function_handle
        kwargs.azimuth (1,1) double { mustBeFinite } = 0
        kwargs.elevation (1,1) double { mustBeFinite } = 90
        kwargs.outFileExtension (1,1) string { mustBeMember(kwargs.outFileExtension, [".pdf", ".jpg", ".png"]) } = ".png"
        kwargs.outFileResolution (1,1) double { mustBeFinite, mustBePositive } = 500
    end

    % Get the figure tool from zef.

    zefFigureTool = zef.(zefFigureToolName) ;

    axisView = [ kwargs.azimuth, kwargs.elevation ] ;

    % Go over data files and gather minima and maxima.

    minVal = Inf ;

    maxVal = - Inf ;

    fileN = numel (dataFilePaths) ;

    for ii = 1 : fileN

        filePath = dataFilePaths (ii) ;

        matFile = matfile (filePath) ;

        quantity = matFile.(quantityName) ;

        measure = measureFn (quantity) ;

        measureMin = min (measure) ;

        measureMax = max (measure) ;

        if measureMin < minVal

            minVal = measureMin ;

        end

        if measureMax > maxVal

            maxVal = measureMax ;

        end

    end % for ii

    cLimits = [ minVal, maxVal ] ;

    % Find axes and color bars in Zeffiro Figure Tool.

    zefAxes = zef.h_axes1 ;

    % Generate own colorbar

    % Plot the data in Zeffiro Figure Tool with the color limits set to the minima and maxima.

    for jj = 1 : fileN

        filePath = dataFilePaths (ii) ;

        matFile = matfile (filePath) ;

        quantity = matFile.(quantityName) ;

        measure = measureFn (quantity) ;

        zef.reconstruction = measure ;

        zef = zef_source_interpolation (zef) ;

        zef_plot_volume (zef) ;

        clim (zefAxes, cLimits) ;

        zefAxes.View = axisView ;

        [~, fileName, ~] = fileparts (filePath) ;

        outFileName = fileName + "-" + quantityName + kwargs.outFileExtension ;

        disp ("Drawing image " + outFileName + "...")

        exportgraphics ( zefFigureTool, outFileName, resolution=kwargs.outFileResolution ) ;

    end % for jj

end % function
