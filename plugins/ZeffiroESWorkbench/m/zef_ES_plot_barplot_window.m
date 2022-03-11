function zef_ES_plot_barplot_window(varargin)
if not(isempty(varargin))
    if length(varargin) == 2
        [y,x] = varargin{1:2};
        window_size = 3;
    elseif length(varargin) == 3
        [y,x,window_size] = varargin{:};
    else
        error('Not enough arguments (Expected 2 or 3 arguments).')
    end
else
    [~,y,x] = zef_ES_objective_function;
    window_size = 3;
end

    y_ES = evalin('base','zef.y_ES_interval.y_ES');

%% Ensure window is of odd length and that the contents to print are within the calculated range
if not(mod(window_size,2))
    window_size = window_size+1;
    warning('Expected window_size argument to be an odd number, instead an even number was provided. Adding +1 to this value.');
end
if x <= floor(window_size/2)
    x = ceil(window_size/2);
end
if y <= floor(window_size/2)
    y = ceil(window_size/2);
end
if x > size(y_ES,2)-floor(window_size/2)
    x = size(y_ES,2)-floor(window_size/2);
end
if y > size(y_ES,1)-floor(window_size/2)
    y = size(y_ES,1)-floor(window_size/2);
end

%% Prepare the [x,y] index of the calculated values
us_x = ones(window_size);
us_y = ones(window_size);
for i = 1:window_size
    us_x(i,:) = x-floor(window_size/2);
    x = x+1;
end
for i = 1:window_size
    us_y(i,:) = y-floor(window_size/2);
    y = y+1;
end

y_ES_idx = cell(window_size);
for i = 1:length(us_x(1,:))
    for j = 1:length(us_y(1,:))
        y_ES_idx(i,j) = y_ES(us_y(j),us_x(i));
    end
end
%% Printing
f = figure('Name','ZEFFIRO Interface: Electrode potentials tool','NumberTitle','off', ...
    'ToolBar','figure','MenuBar','none');
win_temp = findobj('type','figure','name','ZEFFIRO Interface: Error chart tool');
win_temp = get(win_temp(1),'Position');
f.Position(1) = win_temp(1)+win_temp(3);
f.Position(2) = win_temp(2)+(win_temp(4)-f.Position(4));

us_y = us_y';
for i = 1:numel(y_ES_idx)
    y_ES = cell2mat(y_ES_idx(i));
    subplot(length(us_x),length(us_y),i)
    zef_ES_plot_barplot(y_ES,us_y(i),us_x(i));
    title(['[' num2str(us_y(i)) ',' num2str(us_x(i)) ']' ])
end
end
