function weight = EstepWeight(log_lh,post,weight)

log_lh = sum(post.*log_lh,2);

options = optimset('Display','off');
alpha = fminbnd(@(s) target_fun(s,weight,log_lh),0,4,options);
%disp(num2str(alpha))
weight = weight.^alpha;
weight = weight/sum(weight);
end

%%

function val = target_fun(s,weight,p)

weight = weight.^s;
weight = weight/sum(weight);
val = -sum(weight.*p,1);

end



