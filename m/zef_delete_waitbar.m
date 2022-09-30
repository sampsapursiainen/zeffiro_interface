function zef_delete_waitbar

h_waitbar = findall(groot,'-property','ZefWaitbarStartTime');
set(h_waitbar,'DeleteFcn','');
delete(h_waitbar);

end