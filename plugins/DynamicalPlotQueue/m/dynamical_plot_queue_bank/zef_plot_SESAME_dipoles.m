function zef_plot_SESAME_dipoles
%A dynamic plot of dipoles reconstructed by SESAME  

zef = evalin('base','zef');
h_axes_image = evalin('caller','h_axes_image');
f_ind = evalin('caller','f_ind');

rec_vec_init = [0 0 0 0 0 0 0 str2num(zef.SESAME_App.h_inv_rec_source_8.Value) str2num(zef.SESAME_App.h_inv_rec_source_9.Value)];

d_est = zef.SESAME_time_serie{f_ind}.estimated_dipoles;

    zef.inv_rec_source = repmat(rec_vec_init,length(d_est),1);
    zef.inv_rec_source(:,1:3) = zef.SESAME_time_serie{f_ind}.dipole_positions;

    for d_ind = 1 : length(d_est)
        zef.inv_rec_source(d_ind,4:6) = zef.SESAME_time_serie{f_ind}.QV_estimated(1+3*(d_ind-1):3*d_ind)/zef.SESAME_time_serie{f_ind}.Q_estimated(d_ind);
    end

    zef.inv_rec_source(:,7)=zef.SESAME_time_serie{f_ind}.Q_estimated;
    zef_plot_3D_stem_reconstructed_source;
    clear d_est d_ind
     
end