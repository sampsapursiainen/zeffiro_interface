function max_point = zef_rec_maximizer(rec_arr,s_pos)

[~, max_ind] = max(sqrt(sum(reshape(rec_arr,3,length(rec_arr(:))/3).^2)),[],2);
    max_point = s_pos(max_ind,:);
    
end