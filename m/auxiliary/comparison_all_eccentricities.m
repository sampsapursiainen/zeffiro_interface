
n_intervals = 15;
x_scale = 1.2;
ecc_min = 0;

n_s_p_1 = sqrt(sum(s_p_1.^2,2));
n_s_p_1 = repmat(n_s_p_1',3,1);
n_s_p_1 = n_s_p_1(:);
n_s_p_1 = n_s_p_1/max(n_s_p_1(:));

n_s_p_2 = sqrt(sum(s_p_2.^2,2));
n_s_p_2 = repmat(n_s_p_2',3,1);
n_s_p_2 = n_s_p_2(:);
n_s_p_2 = n_s_p_2/max(n_s_p_2(:));

n_s_p_3 = sqrt(sum(s_p_3.^2,2));
n_s_p_3 = repmat(n_s_p_3',3,1);
n_s_p_3 = n_s_p_3(:);
n_s_p_3 = n_s_p_3/max(n_s_p_3(:));

n_s_p_4 = sqrt(sum(s_p_4.^2,2));
n_s_p_4 = repmat(n_s_p_4',3,1);
n_s_p_4 = n_s_p_4(:);
n_s_p_4 = n_s_p_4/max(n_s_p_4(:));

index_vec_1 = zeros(size(n_s_p_1));
index_vec_2 = zeros(size(n_s_p_2));
index_vec_3 = zeros(size(n_s_p_3));
index_vec_4 = zeros(size(n_s_p_4));

tick_labels = cell(0);

for i = 1 : n_intervals

   I = find(n_s_p_1 >= ecc_min + (i-1)*(1-ecc_min)/n_intervals & n_s_p_1 <= ecc_min + i*(1-ecc_min)/n_intervals);
   index_vec_1(I) = i;

   I = find(n_s_p_2 >= ecc_min + (i-1)*(1-ecc_min)/n_intervals & n_s_p_2 <= ecc_min + i*(1-ecc_min)/n_intervals);
   index_vec_2(I) = i;

   I = find(n_s_p_3 >= ecc_min + (i-1)*(1-ecc_min)/n_intervals & n_s_p_3 <= ecc_min + i*(1-ecc_min)/n_intervals);
   index_vec_3(I) = i;

   I = find(n_s_p_4 >= ecc_min + (i-1)*(1-ecc_min)/n_intervals & n_s_p_4 <= ecc_min + i*(1-ecc_min)/n_intervals);
   index_vec_4(I) = i;


tick_labels{i} = round(ecc_min + 0.5*(i+(i-1))*(1-ecc_min)/n_intervals,3);

end

group_vec = [ones(size(index_vec_1)) ; 2*ones(size(index_vec_2)); 3*ones(size(index_vec_3)) ; 4*ones(size(index_vec_4))];

group_vec = categorical(group_vec);

figure(1); set(gcf,'renderer','painters');
h_rdm = boxchart(x_scale*[index_vec_1; index_vec_2; index_vec_3; index_vec_4],log10([rdm_v_1; rdm_v_2; rdm_v_3; rdm_v_4]),'GroupByColor',group_vec);
%set(gca,'yscale','log')
for i = 1 : length(h_rdm)
set(h_rdm(i),'MarkerStyle','.')
set(h_rdm(i),'MarkerSize',0.1)
set(h_rdm(i),'JitterOutliers','off')
set(h_rdm(i),'linewidth',0.25)
end
set(gca,'Xtick',x_scale*[1:n_intervals])
set(gca,'XtickLabels',tick_labels)
set(gca,'xlim',[x_scale/2 x_scale*(n_intervals+1/2)])
pbaspect([3 1 1])
set(gca,'fontsize',4)
set(gca,'linewidth',0.25)
set(gca,'xgrid','on')
set(gca,'ygrid','on')
set(gca,'box','on')
set(gca,'ylim',[-3 0])
set(gca,'ytick',log10([0.00001 0.00002 0.00004 0.00006 0.00008 0.0001 0.0002 0.0004 0.0006 0.0008 0.001 0.002 0.004 0.006 0.008 0.01 0.02 0.04 0.06 0.08 0.1 0.2 0.4 0.6 0.8 1 2 4 6 8 10]))
set(gca,'yticklabels',{'1E-5','2E-5','4E-5','6E-5','8E-5','1E-4','2E-4','4E-4','6E-4','8E-4','1E-3','2E-3','4E-3','6E-3','8E-3','1E-2','2E-2','4E-2','6E-2','8E-2','1E-1','2E-1','4E-1','6E-1','8E-1','1','2','4','6','8','10'})
set(gca,'ticklength',[0.0100 0.0250]/2)

legend({'Smoothed and refined','Smoothed','Regular grid'},'Orientation','Horizontal','Location','Northwest')

print(1,'-dpng','-r1200','rdm_all_eccentricities.png')


figure(2);  set(gcf,'renderer','painters');
h_mag = boxchart(x_scale*[index_vec_1; index_vec_2; index_vec_3; index_vec_4],log10(abs([mag_v_1; mag_v_2; mag_v_3; mag_v_4])),'GroupByColor',group_vec);
%set(gca,'yscale','log')
for i = 1 : length(h_mag)
set(h_mag(i),'MarkerStyle','.')
set(h_rdm(i),'MarkerSize',0.1)
set(h_mag(i),'JitterOutliers','off')
set(h_mag(i),'linewidth',0.25)
end
set(gca,'Xtick',x_scale*[1:n_intervals])
set(gca,'XtickLabels',tick_labels)
set(gca,'xlim',[0 x_scale*(n_intervals+1)])
pbaspect([3 1 1])
set(gca,'fontsize',4)
set(gca,'linewidth',0.25)
set(gca,'xgrid','on')
set(gca,'ygrid','on')
set(gca,'box','on')
set(gca,'ylim',[-3 0.5])
set(set(gca,'ytick',log10([0.00001 0.00002 0.00004 0.00006 0.00008 0.0001 0.0002 0.0004 0.0006 0.0008 0.001 0.002 0.004 0.006 0.008 0.01 0.02 0.04 0.06 0.08 0.1 0.2 0.4 0.6 0.8 1 2 4 6 8 10])))
set(gca,'yticklabels',{'1E-5','2E-5','4E-5','6E-5','8E-5','1E-4','2E-4','4E-4','6E-4','8E-4','1E-3','2E-3','4E-3','6E-3','8E-3','1E-2','2E-2','4E-2','6E-2','8E-2','1E-1','2E-1','4E-1','6E-1','8E-1','1','2','4','6','8','10'})
set(gca,'ticklength',[0.0100 0.0250]/2)
legend({'Smoothed and refined','Smoothed','Regular grid','Regular grid'},'Orientation','Horizontal','Location','Northwest')

print(2,'-dpng','-r1200','mag_all_eccentricities.png')
