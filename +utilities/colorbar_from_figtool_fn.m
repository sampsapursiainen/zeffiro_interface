function colorbar_from_figtool_fn (figtool, filename_without_suffix, filetypes, kwargs)
%
% colorbar_from_figtool_fn (figtool, filename_without_suffix, filetypes, kwargs)
%
% Takes in a handle to a Zeffiro Interface Figure tool (possibly saved to a
% Matlab .fig file), extracts the colobar from it and saves it to files with
% given set of suffixes.
%
% Inputs:
%
% - figtool (1,1) matlab.ui.Figure
%
%   The Zeffiro Interface Figure tool handle.
%
% - filename_without_suffix (1,1) string { mustBeValidVariableName }
%
%   The name of the generated file name WITHOUT the suffix.
%
% - filetypes (:,1) string { mustBeMember(filetypes, [".png", ".pdf", ".eps"]) }
%
%   The file types which one wants to save.
%
% - kwargs.colormap (:,3) double { mustBeInRange( colormap, [0,1] ) } = []
%
%   The colormap that the colorbar will use. If this is empty, the colormap of
%   the given Figure tool handle will be used.
%
% - kwargs.fontsize (1,1) double { mustBePositive } = 20
%
%   The font size of the saved colorbar in points.
%
% - kwargs.resolution (1,1) double { mustBePositive } = 400
%
%   The resolution of the image, if PNG format is used to save the colorbar.
%
% - kwargs.decplaces (1,1) double { mustBeInteger, mustBeNonnegative } = 1
%
%   How many decimal places are to be included into the colorbar numbers.
%
% Outputs:
%
% - None.
%

    arguments

        figtool (1,1) matlab.ui.Figure

        filename_without_suffix (1,1) string

        filetypes (:,1) string { mustBeMember(filetypes, [".png", ".pdf", ".eps"]) }

        kwargs.colormap (:,3) double { mustBeInRange( kwargs.colormap, 0, 1 ) } = []

        kwargs.fontsize (1,1) double { mustBePositive } = 20

        kwargs.resolution (1,1) double { mustBePositive } = 400

        kwargs.decplaces (1,1) double { mustBeInteger } = 1

    end

    % Get figure tool colorbar.

    ftcb = findobj(figtool,'Tag','rightColorbar');

    % Generate new figure. Also initialize figure cleanup operations, in case
    % of an interruption.

    fig = figure ;

    cleanup_fn = @( hh ) close ( hh ) ;

    cleanup_obj = onCleanup ( @() cleanup_fn ( fig ) ) ;

    % Set new figure colormap.

    if not ( isempty ( kwargs.colormap ) )

        fig.Colormap = kwargs.colormap;

    else

        fig.Colormap = figtool.Colormap;

    end

    % Generate axes into the new figure.

    ax = axes ( fig );

    % Attach a new colorbar to axes with certain ticks and tick labels.

    cb = colorbar ( ax ) ;

    lowerlim = ftcb.Limits(1) ;

    upperlim = ftcb.Limits(2) ;

    delta = ( upperlim - lowerlim ) / 5 ;

    cb.Ticks = lowerlim : delta : upperlim ;

    if kwargs.decplaces >= 0
        cb.TickLabels = round ( cb.Ticks, kwargs.decplaces ) ;
    end
    % Set colorbar fontsize.

    cb.FontSize = kwargs.fontsize ;

    % Set color limits. The function caxis was renamed to clim in R2022b, so check for that first.

    matlab_release = version( '-release' ) ;

    release = matlab_release ( end - 4 : end ) ;

    year = double ( string ( release ( 1 : 4 ) ) );

    letter = release ( end ) ;

    if year >= 2023

        climits_fn = @clim ;

    elseif year == 2022 && letter == 'b'

        climits_fn = @clim ;

    else

        climits_fn = @caxis ;

    end

    climits_fn(ax, ftcb.Limits);

    % Set axis visibility to off, so only the colobar remains visible.

    ax.Visible = matlab.lang.OnOffSwitchState.off;

    % Save figures to files.

    for si = 1 : numel ( filetypes )

        suffix = filetypes ( si ) ;

        exportgraphics(fig, filename_without_suffix + ".colorbar" + suffix, "Resolution", kwargs.resolution);

    end

end % function
