function colorbar_from_fig_fn(figtool, filename_without_suffix, filetypes)
%
% colorbar_from_fig_fn
%
% Takes in a handle to a figure, extracts the colobar from it and saves it to
% files with given set of suffixes.
%
% NOTE: utilizes matlab.lang.internal.uuid, which might break at some point.
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
% Outputs:
%
% - None.
%

    arguments

        figtool (1,1) matlab.ui.Figure

        filename_without_suffix (1,1) string { mustBeValidVariableName }

        filetypes (:,1) string { mustBeMember(filetypes, [".png", ".pdf", ".eps"]) }

    end

    % Get figure tool colorbar.

    ftcb = findobj(figtool,'Tag','rightColorbar');

    % Generate unique-ish ID for a new figure. Turn off warnings emitted by base2dec.

    unwanted_warning_id = 'MATLAB:base2dec:InputExceedsFlintmax' ;

    warning ( "off", unwanted_warning_id ) ;

    uuid = double ( mod ( base2dec ( erase ( string ( matlab.lang.internal.uuid() ), "-" ), 16 ), 2^31-1 ) );

    warning ( "on", unwanted_warning_id ) ;

    % Generate new figure with the unique-ish ID. Also initialize figure
    % cleanup operations, in case of an interruption.

    fig = figure(uuid);

    cleanup_fn = @( hh ) close ( hh ) ;

    cleanup_obj = onCleanup ( @() cleanup_fn ( fig ) ) ;

    % Set new figure colormap.

    fig.Colormap = figtool.Colormap;

    % Generate axes into the new figure.

    ax = axes ( fig );

    % Attach a new colorbar to axes.

    colorbar ( ax ) ;

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

        exportgraphics(fig, filename_without_suffix + suffix, "Resolution", 400);

    end

end % function
