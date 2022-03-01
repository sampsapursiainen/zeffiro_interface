if isfield(zef,'h_scroll_bar')
    delete(zef.h_scroll_bar);
end
zef.h_scroll_bar=uicontrol(zef.h_zeffiro,'style','slider','units','normalized','position',[0.09375 0.31 0.8125 0.05]);
set(zef.h_scroll_bar,'callback','set(zef.h_axes1,''xlim'',(1-zef.filter_zoom)*double(size(zef.processed_data,2))./zef.filter_sampling_rate*get(gcbo,''value'') + [0 zef.filter_zoom*double(size(zef.processed_data,2))./zef.filter_sampling_rate]);');
