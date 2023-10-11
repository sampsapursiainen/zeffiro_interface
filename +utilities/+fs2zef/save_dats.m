function save_dats(out_dir)

    arguments

        out_dir (1,1) string { mustBeFolder }

    end

    dir_name = fullfile(out_dir);

    a = dlmread(fullfile(dir_name, 'lh_labels_76.asc'),' ', 2, 0);

    a = a(:,[1,3,5,7]);

    save(fullfile(dir_name, 'lh_points_76.dat'), '-ascii', 'a');

    a = dlmread(fullfile(dir_name, 'rh_labels_76.asc'),' ', 2, 0);

    a = a(:,[1,3,5,7]);

    save(fullfile(dir_name, 'rh_points_76.dat'), '-ascii', 'a');

    a = dlmread(fullfile(dir_name, 'lh_labels_36.asc'),' ', 2, 0);

    a = a(:,[1,3,5,7]);

    save(fullfile(dir_name, 'lh_points_36.dat'), '-ascii', 'a');

    a = dlmread(fullfile(dir_name, 'rh_labels_36.asc'), ' ', 2, 0);

    a = a(:,[1,3,5,7]);

    save(fullfile(dir_name, 'rh_points_36.dat'), '-ascii', 'a');

end % function
