
if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{1})
    %Sigma 1

i%f isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{1} '?']),'Yes')
zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,4)))';
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data.avg,3,1);
zef.reconstruction = zef.reconstruction(:);
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{2})

    %Sigma 2
   % if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{2} '?']),'Yes')
zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,4)))';
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data_2.avg,3,1);
zef.reconstruction = zef.reconstruction(:);
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
    %end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{3})

    %Sigma 1, excl. surface
    %if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{3} '?']),'Yes')
zef.aux_vec_sigma_index = unique(zef.sigma(:,2));
zef.aux_vec_sigma_index = find(not(ismember(zef.brain_ind, find(ismember(zef.sigma(:,2),zef.aux_vec_sigma_index(end-1:end))))));
zef.sigma(zef.brain_ind(zef.aux_vec_sigma_index),1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,4)))';
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data.avg,3,1);
zef.reconstruction = zef.reconstruction(:);
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
 %   end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{4})

    %Sigma 2, excl. surface
 %   if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{4} '?']),'Yes')
zef.aux_vec_sigma_index = unique(zef.domain_labels);
zef.aux_vec_sigma_index = find(not(ismember(zef.brain_ind, find(ismember(zef.domain_labels,zef.aux_vec_sigma_index(end-1:end))))));
zef.sigma(zef.brain_ind(zef.aux_vec_sigma_index),1) = 1/4*(zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,1)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,2)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,3)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,4)))';
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data_2.avg,3,1);
zef.reconstruction = zef.reconstruction(:);
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%    end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{5})

    %Error, parallel
  %  if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{5} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);
zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
   % end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{6})

%Error, mag
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{6} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = abs(1- sqrt(sum(zef.aux_vec_L.^2))./sqrt((sum(zef.aux_vec_bg_data.^2))));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{7})

    %Error, orthogonal
  %  if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{7} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = (zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2)));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
   % end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{8})

    %Error, rdm
 %   if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{8} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = zef.aux_vec_L./sqrt(sum(zef.aux_vec_L.^2)) - repmat(zef.aux_vec_bg_data,1,size(zef.L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
    %end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{9})

    %Uncertainty error, parallel
  %  if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{9} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
 %   end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{10})

    %Uncertainty error, mag
 %   if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{10} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = abs(1- sqrt(sum(zef.aux_vec_L.^2))./sqrt((sum(zef.aux_vec_bg_data.^2))));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
 %   end

 elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{11})

         %Uncertainty error, orthogonal
      %   if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{11} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = (zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2)));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
    %     end

 elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{12})

         %Uncertainty error, rdm
 %        if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{12} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = zef.aux_vec_L./sqrt(sum(zef.aux_vec_L.^2)) - repmat(zef.aux_vec_bg_data,1,size(zef.L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
   %      end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{13})

      %Difference error, parallel
  %    if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{13} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
  %    end

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{14})

      %Difference error, mag
  %    if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{14} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = abs(1- sqrt(sum(zef.aux_vec_L.^2))./sqrt((sum(zef.aux_vec_bg_data.^2))));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
   %   end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{15})

    %Difference error, orthogonal
%    if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{15} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = (zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2)));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
 %   end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{16})

    %Difference error, rdm
   %    if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{16} '?']),'Yes')
zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

zef.reconstruction = zef.aux_vec_L./sqrt(sum(zef.aux_vec_L.^2)) - repmat(zef.aux_vec_bg_data,1,size(zef.L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2));

zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;
zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
   %    end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{17})

     %EEG lead field error, parallel
 %    if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{17} '?']),'Yes')
zef.aux_vec_L_1 = zef.eit_sensitivity_tool_L_EEG_1(1:end-2,:);
zef.aux_vec_L_2 = zef.eit_sensitivity_tool_L_EEG_2(1:end-2,:);
zef.aux_vec_L_1 = zef.aux_vec_L_1 - repmat(mean(zef.aux_vec_L_1),size(zef.L,1)-2,1);
zef.aux_vec_L_2 = zef.aux_vec_L_2 - repmat(mean(zef.aux_vec_L_2),size(zef.L,1)-2,1);

zef.reconstruction = abs(sum((zef.aux_vec_L_2-zef.aux_vec_L_1).*zef.aux_vec_L_1))./(sum(zef.aux_vec_L_1.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_1','aux_vec_L_2'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
 %    end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{18})

     %EEG lead field error, mag
    % if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{18} '?']),'Yes')
zef.aux_vec_L_1 = zef.eit_sensitivity_tool_L_EEG_1(1:end-2,:);
zef.aux_vec_L_2 = zef.eit_sensitivity_tool_L_EEG_2(1:end-2,:);
zef.aux_vec_L_1 = zef.aux_vec_L_1 - repmat(mean(zef.aux_vec_L_1),size(zef.L,1)-2,1);
zef.aux_vec_L_2 = zef.aux_vec_L_2 - repmat(mean(zef.aux_vec_L_2),size(zef.L,1)-2,1);

zef.reconstruction = abs(1- sqrt(sum(zef.aux_vec_L_2.^2))./sqrt(sum(zef.aux_vec_L_1.^2)));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_1','aux_vec_L_2'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
  %   end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{19})

%EEG lead field error, orthogonal
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{19} '?']),'Yes')
zef.aux_vec_L_1 = zef.eit_sensitivity_tool_L_EEG_1(1:end-2,:);
zef.aux_vec_L_2 = zef.eit_sensitivity_tool_L_EEG_2(1:end-2,:);
zef.aux_vec_L_1 = zef.aux_vec_L_1 - repmat(mean(zef.aux_vec_L_1),size(zef.L,1)-2,1);
zef.aux_vec_L_2 = zef.aux_vec_L_2 - repmat(mean(zef.aux_vec_L_2),size(zef.L,1)-2,1);

zef.reconstruction = (sum(zef.aux_vec_L_2.*zef.aux_vec_L_1))./sqrt((sum(zef.aux_vec_L_1.^2)));
zef.reconstruction = (zef.aux_vec_L_2 - repmat(zef.reconstruction,size(zef.aux_vec_L_2,1),1).*zef.aux_vec_L_1./sqrt(sum(zef.aux_vec_L_1.^2)) );
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_L_1.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_1','aux_vec_L_2'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{20})

%EEG lead field error, rdm
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{20} '?']),'Yes')
zef.aux_vec_L_1 = zef.eit_sensitivity_tool_L_EEG_1(1:end-2,:);
zef.aux_vec_L_2 = zef.eit_sensitivity_tool_L_EEG_2(1:end-2,:);
zef.aux_vec_L_1 = zef.aux_vec_L_1 - repmat(mean(zef.aux_vec_L_1),size(zef.L,1)-2,1);
zef.aux_vec_L_2 = zef.aux_vec_L_2 - repmat(mean(zef.aux_vec_L_2),size(zef.L,1)-2,1);

zef.reconstruction = zef.aux_vec_L_2./sqrt(sum(zef.aux_vec_L_2.^2)) - zef.aux_vec_L_1./sqrt(sum(zef.aux_vec_L_1.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_1','aux_vec_L_2'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{21})

%EIT lead field norm
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{21} '?']),'Yes')

zef.aux_vec_L = zef.eit_sensitivity_tool_L_EIT(1:end-2,:);
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);

zef.reconstruction = sqrt(sum(zef.aux_vec_L.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);

%end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{22})

%EEG lead field 1 norm
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{22} '?']),'Yes')
zef.aux_vec_L_1 = zef.eit_sensitivity_tool_L_EEG_1(1:end-2,:);
zef.aux_vec_L_1 = zef.aux_vec_L_1 - repmat(mean(zef.aux_vec_L_1),size(zef.L,1)-2,1);

zef.reconstruction = sqrt(sum(zef.aux_vec_L_1.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_1'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{23})

%EEG lead field 2 norm
%if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{23} '?']),'Yes')
zef.aux_vec_L_2 = zef.eit_sensitivity_tool_L_EEG_2(1:end-2,:);
zef.aux_vec_L_2 = zef.aux_vec_L_2 - repmat(mean(zef.aux_vec_L_2),size(zef.L,1)-2,1);

zef.reconstruction = sqrt(sum(zef.aux_vec_L_2.^2));

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L_2'});
zef.reconstruction = repmat(zef.reconstruction,3,1)./sqrt(3);
zef.reconstruction = zef.reconstruction(:);
%end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{24})

 if isequal(questdlg([zef.h_eit_sensitivity_tool_distribution.Items{24} '?']),'Yes')
zef.eit_sensitivity_tool_L_EIT = zef.L;
zef.eit_sensitivity_tool_L_EIT_source_ind = zef.source_ind;
zef.eit_sensitivity_tool_L_EIT_source_positions = zef.source_positions;
zef.eit_sensitivity_tool_L_EIT_source_interpolation_ind = zef.source_interpolation_ind;
zef.eit_sensitivity_tool_L_EIT_parcellation_interp_ind = zef.parcellation_interp_ind;
end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{25})

  if isequal(questdlg([zef.h_eit_sensitivity_tool_distribution.Items{25} '?']),'Yes')
zef.eit_sensitivity_tool_L_EEG_1 = zef.L;
zef.eit_sensitivity_tool_L_EEG_source_ind = zef.source_ind;
zef.eit_sensitivity_tool_L_EEG_source_positions = zef.source_positions;
zef.eit_sensitivity_tool_L_EEG_source_interpolation_ind = zef.source_interpolation_ind;
zef.eit_sensitivity_tool_L_EEG_parcellation_interp_ind = zef.parcellation_interp_ind;
  end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{26})

      if isequal(questdlg([zef.h_eit_sensitivity_tool_distribution.Items{26} '?']),'Yes')
zef.eit_sensitivity_tool_L_EEG_2 = zef.L;
      end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{27})

     % if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{27} '?']),'Yes')
zef.L = zef.eit_sensitivity_tool_L_EIT;
zef.source_ind = zef.eit_sensitivity_tool_L_EIT_source_ind;
zef.source_positions = zef.eit_sensitivity_tool_L_EIT_source_positions;
zef.source_interpolation_ind = zef.eit_sensitivity_tool_L_EIT_source_interpolation_ind;
zef.parcellation_interp_ind = zef.eit_sensitivity_tool_L_EIT_parcellation_interp_ind;
  %    end

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{28})

   %   if isequal(questdlg(['Apply: ' zef.h_eit_sensitivity_tool_distribution.Items{28} '?']),'Yes')
zef.L = zef.eit_sensitivity_tool_L_EEG_1;
zef.source_ind = zef.eit_sensitivity_tool_L_EEG_source_ind;
zef.source_positions = zef.eit_sensitivity_tool_L_EEG_source_positions;
zef.source_interpolation_ind = zef.eit_sensitivity_tool_L_EEG_source_interpolation_ind;
zef.parcellation_interp_ind = zef.eit_sensitivity_tool_L_EEG_parcellation_interp_ind;
      %end

end

