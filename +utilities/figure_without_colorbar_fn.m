function figure_without_colorbar_fn(figtool, filename, filetypes, resolution, kwargs)
%
% figure_without_colorbar_fn(figtool, filename, filetypes, resolution, kwargs)
%
% Saves a given Zeffiro Interface figure tool image without the colobar
% included.
%
% Inputs:
%
%
% - figtool (1,1) matlab.ui.Figure
%
%   An instace of a Zeffiro Interface Figure tool.
%
% - filename (1,1) string { mustBeValidVariableName }
%
%   The name of the saved file WITHOUT the suffix.
%
% - filetypes (:,1) string { mustBeMember ( filetypes, [".pdf", ".eps", ".png"] ) }
%
%   The list of file types that will be saved, given as a list of suffixes.
%
% - resolution
%
%   The resolution used for saving the image.
%
% - kwargs.colorLims = []
%
%   The color limits for the axes in the given figure tool. If this is empty,
%   the existing color limis in the axes themselves will be used.
%
% Outputs:
%
% - None.
%

    arguments

        figtool (1,1) matlab.ui.Figure

        filename (1,1) string

        filetypes (:,1) string { mustBeMember( filetypes, [".pdf", ".eps", ".png", ".jpg"] ) }

        resolution (1,1) double { mustBePositive } = 400

        kwargs.colorLims (2,:) double { mustBeFinite } = []

    end

    if strlength ( filename ) == 0

        error ( "A filname must not be empty. Call this function with a valid filename as the 2nd argument." ) ;

    end

    % Set visibility of all possible colorbars in the figure as off.

    cbars = findobj ( figtool, "Type", "colorbar" ) ;

    for bi = 1 : numel ( cbars )

        cbar = cbars ( bi ) ;

        cbar.Visible = false ;

    end

    % Find all axes in the figure tool and set their color limits to the specified ones.

    allAxesInFigure = findall (figtool, 'type', 'axes') ;

    axisN = numel (allAxisInFigure) ;

    [ ~, colorLimN ] = size (kwargs.colorLims) ;

    for ii = 1 : axisN

        axes = allAxesInFigure (ii) ;

        if axisN > colorLimN && colorLimN == 1

            axes.Clim = colorLimN (:,1) ;

        elseif axisN == colorLimN

            axes.Clim = kwargs.colorLims (:,ii) ;

        else

            % Nothing to do.

        end % if

    end % for ii

    % Export figure in desired formats.

    for si = 1 : numel ( filetypes )

        suffix = filetypes ( si ) ;

        exportgraphics ( figtool, filename + suffix, "Resolution", resolution) ;

    end

end % functions
