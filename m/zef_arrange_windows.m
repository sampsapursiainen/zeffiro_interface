%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_arrange_windows(varargin)

arrange_function = 'tile';
arrange_target = 'windows';
arrange_mode = 'on-screen';

if not(isempty(varargin))
arrange_function = varargin{1};

if length(varargin) > 1
arrange_target = varargin{2};
end

if length(varargin) > 2
arrange_mode = varargin{3};
end

end
n_tiles = 20;
h_aux = [];

if isequal(arrange_mode,'on-screen')
    if isequal(arrange_target,'windows')
h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface:*'',''WindowState'',''normal'')');
elseif isequal(arrange_target,'figs')
    h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface: Figure tool*'',''WindowState'',''normal'')');
 elseif isequal(arrange_target,'tools')
     h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface:*'',''WindowState'',''normal'')');
    h_aux = h_aux(find(not(ismember(h_aux, evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface: Figure tool*'',''WindowState'',''normal'')')))));
    end
elseif isequal(arrange_mode,'all')
    if isequal(arrange_target,'windows')
h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface:*'')');
elseif isequal(arrange_target,'figs')
h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface: Figure tool*'')');
 elseif isequal(arrange_target,'tools')
    h_aux = evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface:*'')');
    h_aux = h_aux(find(not(ismember(h_aux, evalin('base','findall(groot,''-regexp'',''Name'',''ZEFFIRO Interface: Figure tool*'',''WindowState'',''normal'')')))));
    end
end

if isequal(arrange_function,'tile')

tile_mat = [1 : n_tiles];
tile_mat = tile_mat'*tile_mat;
screen_size = get(0, 'ScreenSize');
thresh_val_1 = ceil(screen_size(4)/screen_size(3));
thresh_val_2 = ceil(screen_size(3)/screen_size(4));
for i = 1 : n_tiles
tile_mat(i,thresh_val_1*i+1:end) = Inf;
tile_mat(thresh_val_2*i+1:end,i) = Inf;
end

tile_mat(find(tile_mat < length(h_aux))) = Inf;
[~, tile_mat_ind] = min(abs(tile_mat(:)-length(h_aux)));
[n_1,n_2] = ind2sub(size(tile_mat),tile_mat_ind);
[position_grid_1, position_grid_2] = meshgrid(linspace(0,1-1/n_1,n_1),linspace(0,1-1/n_2,n_2));
for i = 1 : length(h_aux)
unit_mode = get(h_aux(i),'units');
if isequal(arrange_mode,'all')
    set(h_aux(i),'WindowState','normal');
end
if isequal(unit_mode,'pixels')
    set(h_aux(i),'position',round([position_grid_1(i)*screen_size(3) position_grid_2(i)*screen_size(4) screen_size(3)/n_1 screen_size(4)/n_2]))
else
    set(h_aux(i),'position',[position_grid_1(i) position_grid_2(i) 1/n_1 1/n_2])
end
end

for i = 1 : length(h_aux)
figure(h_aux(i));
evalin('base',get(h_aux(i),'SizeChangedFcn'));
end

for i = 1 : length(h_aux)
figure(h_aux(i));
evalin('base',get(h_aux(i),'SizeChangedFcn'));
end

figure(evalin('base','zef.h_zeffiro_window_main'));

end

if isequal(arrange_function,'maximize')
    for i = 1 : length(h_aux)
    set(h_aux(i),'WindowState','normal');
    end
end

if isequal(arrange_function,'minimize')
    for i = 1 : length(h_aux)
    if not(contains(get(h_aux(i),'Name'),'ZEFFIRO Interface: Segmentation tool'))
    set(h_aux(i),'WindowState','minimized');
    end
    end
end

if isequal(arrange_function,'close')
    for i = 1 : length(h_aux)
    if not(contains(get(h_aux(i),'Name'),'ZEFFIRO Interface: Segmentation tool'))
    close(h_aux(i));
    end
    end
end

end
