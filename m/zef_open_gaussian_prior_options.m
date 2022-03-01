zef_init_gaussian_prior_options;

zef_data = zef_gaussian_prior_options;

zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
if find(ismember(properties(zef.(zef.fieldnames{zef_i})),'ValueChangedFcn'))
zef.(zef.fieldnames{zef_i}).ValueChangedFcn = 'zef_update_gaussian_prior_options;';
end
end

zef = rmfield(zef,'fieldnames');

clear zef_data;

zef.h_plot_hyperprior.ButtonPushedFcn = 'zef_plot_hyperprior';
zef.h_inv_hyperprior_weight.ItemsData = [1:length(zef.h_inv_hyperprior_weight.Items)];
zef.h_inv_hyperprior_weight.Value = zef.inv_hyperprior_weight;
zef.h_inv_hyperprior.ItemsData = [1:length(zef.h_inv_hyperprior.Items)];
zef.h_inv_hyperprior.Value = zef.inv_hyperprior;
zef.h_inv_hyperprior_tail_length_db.Value = num2str(zef.inv_hyperprior_tail_length_db);
zef.h_inv_snr.Value = num2str(zef.inv_snr);
zef.h_inv_prior_over_measurement_db.Value = num2str(zef.inv_prior_over_measurement_db);
zef.h_inv_amplitude_db.Value = num2str(-zef.inv_amplitude_db);

zef.h_zef_gaussian_prior_options.Name = 'ZEFFIRO Interface: Gaussian prior options';
set(findobj(zef.h_zef_gaussian_prior_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_zef_gaussian_prior_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_zef_gaussian_prior_options,'AutoResizeChildren','off');
zef.gaussian_prior_options_current_size = get(zef.h_zef_gaussian_prior_options,'Position');
set(zef.h_zef_gaussian_prior_options,'SizeChangedFcn','zef.gaussian_prior_options_current_size = zef_change_size_function(zef.h_zef_gaussian_prior_options,zef.gaussian_prior_options_current_size);');

clear zef_data;