function [orientations_roi,s_roi] = zef_get_normal_ori(procFile,s_o,varargin)


if nargin<3
    s_roi = procFile.s_ind_0;
    interp_ind = 1:size(procFile.s_ind_0,1);
else
    s_roi = varargin{1};

    %only indices that are interpolated
    s_roi = intersect(s_roi,procFile.s_ind_0);

    if isempty(s_roi)
        error('No interpolated sources found at specified position(s)!')
    end

    n = size(s_roi,1);

    interp_ind = zeros(n,1);
    for j=1:n
        interp_ind(j) = find(procFile.s_ind_0(:)==s_roi(j));
    end  
end



%sources with normal constraint 
constrained = procFile.s_ind_0(procFile.s_ind_4);
not_constrained = setdiff(procFile.s_ind_0,constrained);


[not_constrained_roi, not_constrained_roi_ind] = intersect(interp_ind,not_constrained);


if ~isempty(not_constrained_roi)
    fprintf("Normal constraint not applied to sources %s of %i\n", int2str(not_constrained_roi_ind'),n);
end

n_not = size(not_constrained_roi_ind,1);

%orientations of the sources
orientations_roi = procFile.source_directions(interp_ind,:);
orientations_roi(not_constrained_roi_ind,1) =  repmat(s_o(1),n_not,1);
orientations_roi(not_constrained_roi_ind,2) = repmat(s_o(2),n_not,1);
orientations_roi(not_constrained_roi_ind,3) = repmat(s_o(3),n_not,1);

end





