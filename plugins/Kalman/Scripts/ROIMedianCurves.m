ROI_radius = 10;     %radius of the spherical region of interest, initial 2 cm diameter
load('AuditorySlowEP.mat')
measurements = measurements(1:1);
measurements{1} = empty;
activity = nan(size(positions,1),zef.number_of_frames,length(measurements));

K = size(positions,1);

%for q_value = logspace(-3,-13,11)
for k = 1:K
        ind{k} = sum((positions(k,:)-zef.source_positions).^2,2)<=ROI_radius^2;
end
for n = 1:length(measurements)
    zef.measurements = measurements{n};
    %[zef.reconstruction,~] = zef_KF; %Kalmani
    [zef.reconstruction,~] = zef_find_mne_reconstruction;
    %zef.reconstruction = z_inverse_results{n};
    %  [zef.reconstruction,~] = zef_CSM_iteration;      %sLORETA
    z = cell2mat(cellfun(@(x) sqrt(sum(reshape(x.^2,3,[])))',zef.reconstruction,'UniformOutput',false)');
    for k = 1:K
        activity(k,:,n)=mean(z(ind{k},:),1);
    end
disp([num2str(n),' out of ' num2str(length(measurements))])
end

t = zef.inv_time_1+(0:size(activity,2)-1)*zef.inv_time_3;

median_activity = mean(activity,3);
median_activity = median_activity/max(median_activity,[],'all');

f = figure;

t_span = linspace(0,t(end),size(q{1},2));
q_median = mean(cat(3, q{:}), 3);

subplot(2,1,1)
plot(t_span,abs(q_median(2,:))'/max(abs(q_median(2:4,:)),[],'all'),'--','Color','r','LineWidth',1.6)
hold on
plot(t_span,abs(q_median(3,:))'/max(abs(q_median(2:4,:)),[],'all'),'--','Color','g','LineWidth',1.6)
plot(t_span,abs(q_median(4,:))'/max(abs(q_median(2:4,:)),[],'all'),'--','Color','b','LineWidth',1.6)
plot(t,median_activity(1,:)','LineWidth',2.2,'Color','#A2142F')
plot(t,median_activity(2,:)','LineWidth',2.2,'Color','#77AC30')
plot(t,median_activity(3,:)','LineWidth',2.2,'Color','#0072BD')
title(['Right Hemisphere'])
a = gca;
a.XTick = 0:0.025:0.25;
box off
hold off
subplot(2,1,2)
plot(t_span,abs(q_median(5,:))'/max(abs(q_median(5:7,:)),[],'all'),'--','Color','y','LineWidth',1.6)
hold on
plot(t_span,abs(q_median(6,:))'/max(abs(q_median(5:7,:)),[],'all'),'--','Color','m','LineWidth',1.6)
plot(t_span,abs(q_median(7,:))'/max(abs(q_median(5:7,:)),[],'all'),'--','Color','c','LineWidth',1.6)
plot(t,median_activity(4,:)','LineWidth',2.2, 'Color', '#EDB120')
plot(t,median_activity(5,:)','LineWidth',2.2, 'Color', '#7E2F8E')
plot(t,median_activity(6,:)','LineWidth',2.2, 'Color', '#4DBEEE')
title('Left Hemisphere')
box off
hold off
f.Position(3) = 1000;
a = gca;
a.XTick = 0:0.025:0.25;
%end

%%
f2 = figure;
hold on
box off
plot(t_span, q_median(2,:) / max(abs(q_median(2:7,:)),[],'all'),'r', 'LineWidth',1.6)
plot(t_span, q_median(3,:) / max(abs(q_median(2:7,:)),[],'all'),'g', 'LineWidth',1.6)
plot(t_span, q_median(4,:) / max(abs(q_median(2:7,:)),[],'all'),'b', 'LineWidth',1.6)
plot(t_span, q_median(5,:) / max(abs(q_median(2:7,:)),[],'all'),'y', 'LineWidth',1.6)
plot(t_span, q_median(6,:) / max(abs(q_median(2:7,:)),[],'all'),'m', 'LineWidth',1.6)
plot(t_span, q_median(7,:) / max(abs(q_median(2:7,:)),[],'all'),'c', 'LineWidth',1.6)
f2.Position(3) = 1000;
a = gca;
a.XTick = 0:0.025:0.25;
hold off

xline(0.079, '-', {'0.079 ms'})
xline(0.097, '-', '0.097 ms')
xline(0.124, '-', '0.124 ms')
xline(0.139, '-',  '0.139 ms')
xline(0.159, '-', '0.159 ms')
xline(0.184, '-', '0.184 ms')


    