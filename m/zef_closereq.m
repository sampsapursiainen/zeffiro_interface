if isequal(exist('zef'),1)
zef = zef_remove_object_handles(zef,[],cat(1,get(gcbo,'Children')));
end
closereq;