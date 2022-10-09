% Calculates the mean of the 50 rec of the project file
n_classes = 6; 
frame_number = 1; 
n_filter = 11;

z_inverse_results = cell(0);

data_tree = zef.dataBank.tree;
rec_ind = 1;

fn = fieldnames(data_tree);
for k=1:numel(fn)
    node = data_tree.(fn{k});
    if (strcmp(node.type, 'reconstruction'))
        rec = node.data.reconstruction;
        number_of_frames = size(rec,2);
            z_inverse_results{rec_ind} = rec{frame_number};
        rec_ind = rec_ind + 1;
    end
end

avg_set_ind = [1:length(z_inverse_results)];

z_max_points = zeros(length(z_inverse_results),3);
for k = 1 : length(z_inverse_results)

    z_max_points(k,:) = zef_rec_maximizer(z_inverse_results{k},zef.source_positions);
    
end

for j = 1 : n_filter

z_avg_rec = zeros(size(z_inverse_results{1}));
for k = 1 : length(avg_set_ind)

    z_avg_rec = z_avg_rec + z_inverse_results{avg_set_ind(k)};

end


z_max_avg_point = zef_rec_maximizer(z_inverse_results{k},zef.source_positions);

[~, max_ind] = max(sqrt(sum((z_max_points(avg_set_ind,:) - z_max_avg_point).^2,2)));

max_ind
avg_set_ind = setdiff(avg_set_ind,avg_set_ind(max_ind));

end

% class_vec = kmeans(z_max_points,n_classes);
% 
% z_max_means = zeros(n_classes,3);
% for k = 1 : n_classes
% 
% z_max_means(k,:) = mean(z_max_points(class_vec == k,:));
%     
% end
% 
% z_average_recs = cell(0);
% for k = 1 : n_classes
%     j_set = find(class_vec==k);
%     z_average_recs{k} = zeros(size(z_inverse_results{1}{1}));
%     for j = 1 : length(j_set)
%         j_ind = j_set(j);
%    z_average_recs{k} = z_average_recs{k} + z_inverse_results{1}{j_ind};
%     end
% end