function s_o = zef_minmax_svd_ori(s_roi,minmax,L,varargin)

radialRef = [];
if nargin>3
    radialRef = varargin{1};
end

if strcmp(minmax,'max')
    svd_max = true;
elseif strcmp(minmax,'min')
    svd_max = false;
else
    error('Argument must be "min" or "max"');
end

ori_all = zeros(size(s_roi,1),3,2);
for j=1:size(s_roi,1)
    
    [~, ~, V] = svd(L(:,s_roi(j)*3 + (0:2)-2));
    
    ori_all(j,:,:) = V(:,[1 3]);
    
end


   
if svd_max
    s_o = reshape(ori_all(:,:,1),size(s_roi,1),3);

else
    s_o = reshape(ori_all(:,:,2),size(s_roi,1),3);
       
end

%if we have a reference for radial direction, check if ori needs to be
%flipped
if ~isempty(radialRef)
    negIdx = (s_o * radialRef') < 0;  
    s_o(negIdx, :) = -s_o(negIdx, :);
 end    

end