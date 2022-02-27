%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%Script for plotting dipoles that SESAME estimates.

if size(zef.SESAME_time_serie,2) == 1
d_est = zef.SESAME_time_serie{1}.estimated_dipoles;
zef.inv_rec_source = repmat(zef.inv_rec_source(1,:),length(d_est),1);
zef.inv_rec_source(:,1:3) = zef.SESAME_time_serie{1}.dipole_positions;

for d_ind = 1 : length(d_est)
zef.inv_rec_source(d_ind,4:6) = zef.SESAME_time_serie{1}.QV_estimated(1+3*(d_ind-1):3*d_ind)/zef.SESAME_time_serie{1}.Q_estimated(d_ind);
end

zef.inv_rec_source(:,7)=zef.SESAME_time_serie{1}.Q_estimated;

zef.h_rec_source = zef_plot_source(2);

clear d_est d_ind
else
    h_axes_text = findobj(evalin('base','zef.h_zeffiro'),'tag','image_details');
    zef_boolean = 1;
    for zef_j = 1:size(zef.SESAME_time_serie,2)
        zef_time_val = evalin('base','zef.SESAME_time_1') + evalin('base','zef.SESAME_time_2')/2 + evalin('base','zef.SESAME_time_3')*(zef_j-1);
        d_est = zef.SESAME_time_serie{zef_j}.estimated_dipoles;
        zef.inv_rec_source = zeros(length(d_est),9);
        zef.inv_rec_source(1,9) = str2num(zef.SESAME_App.h_inv_rec_source_9.Value);
        zef.inv_rec_source(1,8) = str2num(zef.SESAME_App.h_inv_rec_source_8.Value);
        if size(zef.SESAME_time_serie{zef_j}.dipole_positions,1)>0
            zef.inv_rec_source(:,1:3) = zef.SESAME_time_serie{zef_j}.dipole_positions;
            for d_ind = 1 : length(d_est)
            zef.inv_rec_source(d_ind,4:6) = mean(zef.SESAME_time_serie{zef_j}.QV_estimated(1+3*(d_ind-1):3*d_ind,:),2);
            zef.inv_rec_source(d_ind,7) = norm(zef.inv_rec_source(d_ind,4:6));
            zef.inv_rec_source(d_ind,4:6) = zef.inv_rec_source(d_ind,4:6)./zef.inv_rec_source(d_ind,7);
            end
            %zef.inv_rec_source(:,7)=mean(zef.SESAME_time_serie{zef_j}.Q_estimated,2);

            zef.h_rec_source = zef_plot_source(2);
            zef_boolean = 1;
        else
            h_axes1 = evalin('base','zef.h_axes1');
            hold(h_axes1,'on');
            quiver3(h_axes1,[],[],[],[],[],[])
            hold(h_axes1,'off');
            zef_boolean = 0;
        end

        zef.h_synth_source = zef_plot_active_source(zef_time_val);

        if not(isempty(h_axes_text))
            delete(h_axes_text);
            h_axes_text = [];
        end
        h_axes_text = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
        set(h_axes_text,'tag','image_details');
        h_text = text(0, 0.5, ['Time: ' num2str(zef_time_val,'%0.6f') ' s, Frame: ' num2str(zef_j) ' / ' num2str(size(zef.SESAME_time_serie,2)) '.']);
        set(h_text,'visible','on');
        set(h_axes_text,'layer','bottom');
        axes(evalin('base','zef.h_axes1'));
        if zef_boolean == 1
            pause(0.5)
        else
            pause(0.01)
        end
    end
    clear d_est d_ind zef_j zef_boolean zef_time_val h_axes_text h_text h_axes1
end