function zef = zef_dataBank_set_reconstructions(zef,rec_cell,frame_number)

data_tree = zef.dataBank.tree;
rec_ind = 1;

fn = fieldnames(data_tree);
for k=1:numel(fn)
    if (strcmp(zef.dataBank.tree.(fn{k}).type, 'reconstruction'))
        zef.dataBank.tree.(fn{k}).data.reconstruction{frame_number} = rec_cell{rec_ind};
        rec_ind = rec_ind + 1;
    end
end

end