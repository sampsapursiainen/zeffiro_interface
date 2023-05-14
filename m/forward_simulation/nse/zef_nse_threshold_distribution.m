function d = zef_nse_threshold_distribution(d,quantile_min,quantile_max)

a = quantile(abs(d),quantile_min);
b = quantile(abs(d),quantile_max);
d(find(abs(d)<a))=a;
d(find(abs(d)>b))=b;

end
