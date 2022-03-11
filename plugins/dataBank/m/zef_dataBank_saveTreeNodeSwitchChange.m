
zef.dataBank.save2disk=zef.dataBank.app.savetodiskSwitch.Value;

if strcmp(zef.dataBank.save2disk, 'Off') %deleting the files
   fwait= waitbar(0, 'loading and deleting the data. Please wait');
    zef.dataBank.tree=zef_dataBank_loadTreeNodes(zef.dataBank.tree);
    close(fwait);

end

if strcmp(zef.dataBank.save2disk, 'On') %saving the files
       fwait= waitbar(0, 'Saving the data. Please wait');
    zef.dataBank.tree=zef_dataBank_saveTreeNodes(zef.dataBank.tree, zef.dataBank.folder);
    close(fwait);
end

clear fwait
