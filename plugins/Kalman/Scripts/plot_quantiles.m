folder = '/media/datadisk/paavo/zeffiro_interface/figures';

sg_data = [];
lm_data = [];


for i = 1:50
    zef_import_figure(['rec_',num2str(i),'.fig'], folder)
    h = gcf;
    h_axes = findobj(h.Children, 'type', 'axes');
    sg = findobj(h_axes.Children, 'displayname', 'SG 006');
    lm = findobj(h_axes.Children, 'displayname', 'LH 023');
    sg_data = [sg_data;sg.YData];
    lm_data = [lm_data; lm.YData];
    x_data = sg.XData;
    close(h)
end
%%

sg_q = quantile(sg_data, [0.25, 0.5, 0.75],1);
lm_q = quantile(lm_data, [0.25, 0.5, 0.75],1);
%%
figure(3);
linewidth = 1.75;
faceAlpha = 0.35;
hold on
x2 = [x_data, fliplr(x_data)];
sg_area = [sg_q(1,:), fliplr(sg_q(3,:))];
h = fill(x2,sg_area, [1.00,0.50,0.20], 'EdgeColor', [1.00,0.50,0.20]);
h.FaceAlpha = faceAlpha;
a = plot(x_data,sg_q(2,:),'Color',[1.00,0.50,0.20], 'LineWidth', linewidth);

lh_area = [lm_q(1,:), fliplr(lm_q(3,:))];
h2 = fill(x2, lh_area, [0.86,0.08,0.08], 'EdgeColor', [0.86,0.08,0.08]);
h2.FaceAlpha = faceAlpha;
b = plot(x_data,lm_q(2,:),'Color',[0.86,0.08,0.08], 'LineWidth', linewidth);


%a =fill(x_data, sg_q(1,:), '--', x_data, sg_q(2,:), x_data, sg_q(3,:),'-.', 'Color',[1.00,0.50,0.20], 'LineWidth', linewidth, 'DisplayName', 'SG 006')
%b = plot(x_data, lm_q(1,:), '--', x_data, lm_q(2,:),  x_data, lm_q(3,:), '-.', 'Color',[0.86,0.08,0.08], 'LineWidth', linewidth, 'DisplayName', 'LH 023');
xlim([x_data(1) x_data(end)]);
set(gca,'ygrid','on')
legend([a,b], 'SG 006', 'LH 023')
title("SNR = Inf")
box off
hold off