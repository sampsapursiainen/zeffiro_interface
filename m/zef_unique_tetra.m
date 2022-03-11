function [tetra, domain_labels] = zef_unique_tetra(tetra, domain_labels)

[~, I] = unique(sort(tetra,2),'rows');
tetra = tetra(I,:);
domain_labels = domain_labels(I,:);

end
