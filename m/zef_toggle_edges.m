function zef_toggle_edges

h = get(gcf,'Children');
h = findobj(h,'Tag','axes1');
h = get(h,'Children');
for i = 1 : length(h);
    if find(ismember(properties(h(i)),'EdgeColor'));
        if isequal(h(i).EdgeColor,[1 1 1])
        set(h(i),'edgecolor','none');
        else
            set(h(i),'edgecolor',[1 1 1]);
        end
    end

end