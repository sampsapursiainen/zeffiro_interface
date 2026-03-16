function [subdomain_ind] = zef_find_subdomain_ind(domain_labels, domain_labels_with_subdomains)

unique_domain_labels = unique(domain_labels);
subdomain_ind = zeros(length(domain_labels),1);

for i = 1 : length(unique_domain_labels)

I_1 = find(domain_labels==unique_domain_labels(i));
subdomain_aux = domain_labels_with_subdomains(I_1);
[I_2,~,I_3] = unique(subdomain_aux);
I_4 = [1:length(I_2)];
subdomain_aux = I_4(I_3);
subdomain_ind(I_1) = subdomain_aux;

end

end
