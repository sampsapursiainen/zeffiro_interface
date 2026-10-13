
function ori = zef_get_radial_orientation(s_roi,minmax,L,varargin)

s_ref = [];
source_positions = [];

if nargin==5
    s_ref = varargin{1};
    source_positions = varargin{2};
end
   

if strcmp(minmax,'max')
    
    %get the orientations but they might be +- flipped
    ori = zef_minmax_svd_ori(s_roi,minmax,L);

    %check whether the max signal is positive or negative
    for j = 1:size(s_roi,1)
        y_max = L(:, s_roi(j)*3 + (0:2)-2) * ori(j,:)';
        [~, max_idx] = max(abs(y_max));
        if y_max(max_idx)<0
            ori(j,:)=-ori(j,:);
        end
    end

else
    
    
    if  isempty(s_ref)  || isempty(source_positions)
        error('Need reference position.')
    end

    % use this to estimate the correct radial direction
    centerEst = mean(source_positions, 1);

    s_p = source_positions(s_ref,:);

    radialRef = (s_p - centerEst)/norm(s_p - centerEst);

    %then use here as reference
    ori = zef_minmax_svd_ori(s_roi,minmax,L,radialRef);
    

    %double check using the leadfield magnitude
    d = sqrt(sum((source_positions - repmat(s_p,size(source_positions,1),1)).^2,2));

    d_sorted = sort(d);
    d_min = d_sorted(2);
    
    search_lim = 5;
    for i = 1:search_lim
        ind_plus = dsearchn(source_positions, s_p+(radialRef/norm(radialRef))*d_min*i);      
        ind_minus = dsearchn(source_positions, s_p-(radialRef/norm(radialRef))*d_min*i);
        if ind_plus ~=s_ref && ind_minus ~=s_ref
            break;
        end
    end

    % give warnings if orientation cant be reliably determined
    if ind_plus == s_ref || ind_minus == s_ref
        warning('\nSource orientation might be flipped if center estimate is incorrect: [%s].\n',num2str(centerEst)')
    else
    	
        %give warnings if leadfield contradicts center estimate
        m_1 = norm(L(:, ind_minus*3-2: ind_minus*3), 'fro');
        m_2 = norm(L(:, s_ref*3-2: s_ref*3), 'fro');
        m_3 = norm(L(:, ind_plus*3-2: ind_plus*3), 'fro');

        if ~(m_1<m_2 && m_2<m_3) %if leadfield magnitude seems to decrease towards skull
            warning('\nSource orientation might be flipped if center estimate is incorrect: [%s].\n',num2str(centerEst));
        end        
    end
end