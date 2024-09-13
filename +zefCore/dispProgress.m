function dispProgress (currentI, maxI, printInterval, kwargs)
%
% dispProgress (currentI, maxI, printInterval=100, kwargs.indent=2)
%
% Can be used to display the progress of a loop.
%

    arguments
        currentI (1,1) double { mustBeInterger, mustBePositive }
        maxI (1,1) double { mustBeInterger, mustBePositive, mustBeGreaterThanOrEqual(maxI,currentI) }
        printInterval (1,1) double { mustBeInteger, mustBePositive } = ceil (maxI / 100)
        kwargs.indent (1,1) double { mustBeInteger, mustBeNonnegative } = 2
    end

    indent = strjoin ( repmat ( " ", 1, kwargs.indent ), "" ) ;

    if currentI == 1 || currentI == maxI || mod ( currentI, printInterval ) == 0

        disp ( indent + currentI + " / " + maxI )

    end % if

end % function
