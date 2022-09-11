function fig_num = zef_fig_num

h_fig_aux = findobj(groot, '-property','ZefFig');

max_tag = 0;
for i = 1 : length(h_fig_aux)
tag_val = get(h_fig_aux(i),'ZefFig');
if not(isempty(tag_val))
    max_tag = max(max_tag,tag_val);
end
end

fig_num = max_tag + 1;

end
