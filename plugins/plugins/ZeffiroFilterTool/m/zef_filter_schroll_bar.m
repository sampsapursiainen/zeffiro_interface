if isfield(zef,'h_scroll_bar')
    delete(zef.h_scroll_bar);
end
zef.h_scroll_bar=uicontrol(zef.h_zeffiro,'style','slider','units',zef.h_axes1.Units,'position',[zef.h_axes1.Position(1:3) 0.05*zef.h_axes1.Position(4)]);
zef.h_scroll_bar.Position(2) = zef.h_axes1.Position(2)-0.1*zef.h_axes1.Position(4);
set(zef.h_scroll_bar,'callback','set(zef.h_axes1,''xlim'',(1-zef.filter_zoom)*double(size(zef.processed_data,2))./zef.filter_sampling_rate*get(gcbo,''value'') + [0 zef.filter_zoom*double(size(zef.processed_data,2))./zef.filter_sampling_rate]);');
