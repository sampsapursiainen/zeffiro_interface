function [fig, ax] = box_plots_with_differing_whiskers_fn( ...
    data_cells, ...
    outlier_limits, ...
    x_tick_labels, ...
    x_label, ...
    y_label ...
)

    %
    % box_plots_with_differing_whiskers_fn
    %
    % Generates a figure–axes pair that contains a series of box plots with
    % whiskers of differing sizes.
    %
    % NOTE: boxplot draws points as outliers if they are greater than q3 + w ×
    % (q3 – q1) or less than q1 – w × (q3 – q1), where w is the multiplier
    % Whisker, and q1 and q3 are the 25th and 75th percentiles of the sample
    % data, respectively.
    %

    arguments

        data_cells (:,1) cell

        outlier_limits (:,1) double

        x_tick_labels (:,1) string

        x_label (1,1) string

        y_label (1,1) string

    end % arguments

    assert ( numel( data_cells ) == numel ( outlier_limits ), "There need to be as many data cells as there are outlier limits" );

    assert ( numel( data_cells ) == numel ( x_tick_labels ), "There need to be as many data cells as there are x-tick labels." );

    % Create figure and places axes in it.

    fig = figure();

    ax = axes(fig);

    xlabel(x_label, "Interpreter", "latex");

    ylabel(y_label, "Interpreter", "latex");

    % Add box plots to the same axes.

    hold( ax, "on" )

    index_range = 1 : numel(data_cells);

    for ii = index_range

        % Compute upper whisker size based on the algorithm given in box plot
        % documentation.

        q25 = quantile(data_cells{ii}, 0.25) ;

        q75 = quantile(data_cells{ii}, 0.75)

        ol = outlier_limits(ii)

        upper_whisker = ( ol - q75 )  / ( q75 - q25 )

        computation_worked = abs ( ol - ( q75 + upper_whisker * (q75 - q25) ) ) <= eps( ol ) ;

        assert ( computation_worked, "The upper whisker limit must be greater than the 75 % quantile of data series " + ii + "." ) ;

        % Add box plot to axes.

        bp = boxplot( ...
            ax, ...
            data_cells{ii}, ...
            "Positions", ii, ...
            "Whisker", upper_whisker ...
        ) ;

    end % for

    xticks(ax, index_range) ;

    xticklabels(ax, x_tick_labels) ;

    grid(ax, "on")

    hold( ax, "off" )

end % function
