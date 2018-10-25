%Copyright © 2018, Sampsa Pursiainen
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);

if ismember(evalin('base','zef.imaging_method'), [2 3])
zef.s_points = zef.sensors(:,1:3);
if size(zef.sensors,2) > 3
zef.s_directions = zef.sensors(:,4:end);
end
else 
zef.s_points = zef.sensors;
end


zef.s_scaling= 1.0;
zef.s_zx_rotation= 0;
zef.s_yz_rotation= 0;
zef.s_xy_rotation= 0;
zef.s_z_correction= 0;
zef.s_y_correction= 0;
zef.s_x_correction= 0;

h = evalin('base','zef.h_edit15'); set(h,'string',num2str(zef.s_scaling));
h = evalin('base','zef.h_edit3'); set(h,'string',num2str(zef.s_x_correction)) ;
h = evalin('base','zef.h_edit6'); set(h,'string',num2str(zef.s_y_correction));
h = evalin('base','zef.h_edit7'); set(h,'string',num2str(zef.s_z_correction));
h = evalin('base','zef.h_edit12'); set(h,'string',num2str(zef.s_xy_rotation));
h = evalin('base','zef.h_edit13'); set(h,'string',num2str(zef.s_yz_rotation));
h = evalin('base','zef.h_edit14'); set(h,'string',num2str(zef.s_zx_rotation));


zef.i = 0;

if zef.d1_on

zef.i = zef.i + 1;

zef.d1_points = zef.reuna_p{zef.i};
zef.d1_tetra = zef.reuna_t{zef.i};

zef.d1_scaling = 1.0;
zef.d1_zx_rotation= 0;
zef.d1_yz_rotation= 0;
zef.d1_xy_rotation= 0;
zef.d1_z_correction= 0;
zef.d1_y_correction= 0;
zef.d1_x_correction= 0;

h = evalin('base','zef.h_edit129'); set(h,'string',num2str(zef.d1_scaling));
h = evalin('base','zef.h_edit123'); set(h,'string',num2str(zef.d1_x_correction));
h = evalin('base','zef.h_edit124'); set(h,'string',num2str(zef.d1_y_correction));
h = evalin('base','zef.h_edit125'); set(h,'string',num2str(zef.d1_z_correction));
h = evalin('base','zef.h_edit126'); set(h,'string',num2str(zef.d1_xy_rotation));
h = evalin('base','zef.h_edit127'); set(h,'string',num2str(zef.d1_yz_rotation));
h = evalin('base','zef.h_edit128'); set(h,'string',num2str(zef.d1_zx_rotation));

end

if zef.d2_on

zef.i = zef.i + 1;

zef.d2_points = zef.reuna_p{zef.i};
zef.d2_tetra = zef.reuna_t{zef.i};

zef.d2_scaling = 1.0;
zef.d2_zx_rotation= 0;
zef.d2_yz_rotation= 0;
zef.d2_xy_rotation= 0;
zef.d2_z_correction= 0;
zef.d2_y_correction= 0;
zef.d2_x_correction= 0;

h = evalin('base','zef.h_edit229'); set(h,'string',num2str(zef.d2_scaling));
h = evalin('base','zef.h_edit223'); set(h,'string',num2str(zef.d2_x_correction));
h = evalin('base','zef.h_edit224'); set(h,'string',num2str(zef.d2_y_correction));
h = evalin('base','zef.h_edit225'); set(h,'string',num2str(zef.d2_z_correction));
h = evalin('base','zef.h_edit226'); set(h,'string',num2str(zef.d2_xy_rotation));
h = evalin('base','zef.h_edit227'); set(h,'string',num2str(zef.d2_yz_rotation));
h = evalin('base','zef.h_edit228'); set(h,'string',num2str(zef.d2_zx_rotation));

end


if zef.d3_on

zef.i = zef.i + 1;

zef.d3_points = zef.reuna_p{zef.i};
zef.d3_tetra = zef.reuna_t{zef.i};

zef.d3_scaling = 1.0;
zef.d3_zx_rotation= 0;
zef.d3_yz_rotation= 0;
zef.d3_xy_rotation= 0;
zef.d3_z_correction= 0;
zef.d3_y_correction= 0;
zef.d3_x_correction= 0;

h = evalin('base','zef.h_edit329'); set(h,'string',num2str(zef.d3_scaling));
h = evalin('base','zef.h_edit323'); set(h,'string',num2str(zef.d3_x_correction));
h = evalin('base','zef.h_edit324'); set(h,'string',num2str(zef.d3_y_correction));
h = evalin('base','zef.h_edit325'); set(h,'string',num2str(zef.d3_z_correction));
h = evalin('base','zef.h_edit326'); set(h,'string',num2str(zef.d3_xy_rotation));
h = evalin('base','zef.h_edit327'); set(h,'string',num2str(zef.d3_yz_rotation));
h = evalin('base','zef.h_edit328'); set(h,'string',num2str(zef.d3_zx_rotation));

end


if zef.d4_on

zef.i = zef.i + 1;

zef.d4_points = zef.reuna_p{zef.i};
zef.d4_tetra = zef.reuna_t{zef.i};

zef.d4_scaling = 1.0;
zef.d4_zx_rotation= 0;
zef.d4_yz_rotation= 0;
zef.d4_xy_rotation= 0;
zef.d4_z_correction= 0;
zef.d4_y_correction= 0;
zef.d4_x_correction= 0;

h = evalin('base','zef.h_edit429'); set(h,'string',num2str(zef.d4_scaling));
h = evalin('base','zef.h_edit423'); set(h,'string',num2str(zef.d4_x_correction));
h = evalin('base','zef.h_edit424'); set(h,'string',num2str(zef.d4_y_correction));
h = evalin('base','zef.h_edit425'); set(h,'string',num2str(zef.d4_z_correction));
h = evalin('base','zef.h_edit426'); set(h,'string',num2str(zef.d4_xy_rotation));
h = evalin('base','zef.h_edit427'); set(h,'string',num2str(zef.d4_yz_rotation));
h = evalin('base','zef.h_edit428'); set(h,'string',num2str(zef.d4_zx_rotation));

end

if zef.w_on

zef.i = zef.i + 1;

zef.w_points = zef.reuna_p{zef.i};
zef.w_tetra = zef.reuna_t{zef.i};

zef.w_scaling = 1.0;
zef.w_zx_rotation= 0;
zef.w_yz_rotation= 0;
zef.w_xy_rotation= 0;
zef.w_z_correction= 0;
zef.w_y_correction= 0;
zef.w_x_correction= 0;

h = evalin('base','zef.h_edit29'); set(h,'string',num2str(zef.w_scaling));
h = evalin('base','zef.h_edit23'); set(h,'string',num2str(zef.w_x_correction));
h = evalin('base','zef.h_edit24'); set(h,'string',num2str(zef.w_y_correction));
h = evalin('base','zef.h_edit25'); set(h,'string',num2str(zef.w_z_correction));
h = evalin('base','zef.h_edit26'); set(h,'string',num2str(zef.w_xy_rotation));
h = evalin('base','zef.h_edit27'); set(h,'string',num2str(zef.w_yz_rotation));
h = evalin('base','zef.h_edit28'); set(h,'string',num2str(zef.w_zx_rotation));

end




if zef.g_on

zef.i = zef.i + 1;

zef.g_points = zef.reuna_p{zef.i};
zef.g_tetra = zef.reuna_t{zef.i};

zef.g_scaling = 1.0;
zef.g_zx_rotation= 0;
zef.g_yz_rotation= 0;
zef.g_xy_rotation= 0;
zef.g_z_correction= 0;
zef.g_y_correction= 0;
zef.g_x_correction= 0;

h = evalin('base','zef.h_edit36'); set(h,'string',num2str(zef.g_scaling));
h = evalin('base','zef.h_edit30'); set(h,'string',num2str(zef.g_x_correction));
h = evalin('base','zef.h_edit31'); set(h,'string',num2str(zef.g_y_correction));
h = evalin('base','zef.h_edit32'); set(h,'string',num2str(zef.g_z_correction));
h = evalin('base','zef.h_edit33'); set(h,'string',num2str(zef.g_xy_rotation));
h = evalin('base','zef.h_edit34'); set(h,'string',num2str(zef.g_yz_rotation));
h = evalin('base','zef.h_edit35'); set(h,'string',num2str(zef.g_zx_rotation));

end





if zef.c_on

zef.i = zef.i + 1;

zef.c_points = zef.reuna_p{zef.i};
zef.c_tetra = zef.reuna_t{zef.i};

zef.c_scaling = 1.0;
zef.c_zx_rotation= 0;
zef.c_yz_rotation= 0;
zef.c_xy_rotation= 0;
zef.c_z_correction= 0;
zef.c_y_correction= 0;
zef.c_x_correction= 0;

h = evalin('base','zef.h_edit50'); set(h,'string',num2str(zef.c_scaling));
h = evalin('base','zef.h_edit44'); set(h,'string',num2str(zef.c_x_correction));
h = evalin('base','zef.h_edit45'); set(h,'string',num2str(zef.c_y_correction));
h = evalin('base','zef.h_edit46'); set(h,'string',num2str(zef.c_z_correction));
h = evalin('base','zef.h_edit47'); set(h,'string',num2str(zef.c_xy_rotation));
h = evalin('base','zef.h_edit48'); set(h,'string',num2str(zef.c_yz_rotation));
h = evalin('base','zef.h_edit49'); set(h,'string',num2str(zef.c_zx_rotation));

end




if zef.sk_on

zef.i = zef.i + 1;

zef.sk_points = zef.reuna_p{zef.i};
zef.sk_tetra = zef.reuna_t{zef.i};

zef.sk_scaling = 1.0;
zef.sk_zx_rotation= 0;
zef.sk_yz_rotation= 0;
zef.sk_xy_rotation= 0;
zef.sk_z_correction= 0;
zef.sk_y_correction= 0;
zef.sk_x_correction= 0;

h = evalin('base','zef.h_edit57'); set(h,'string',num2str(zef.sk_scaling));
h = evalin('base','zef.h_edit51'); set(h,'string',num2str(zef.sk_x_correction));
h = evalin('base','zef.h_edit52'); set(h,'string',num2str(zef.sk_y_correction));
h = evalin('base','zef.h_edit53'); set(h,'string',num2str(zef.sk_z_correction));
h = evalin('base','zef.h_edit54'); set(h,'string',num2str(zef.sk_xy_rotation));
h = evalin('base','zef.h_edit55'); set(h,'string',num2str(zef.sk_yz_rotation));
h = evalin('base','zef.h_edit56'); set(h,'string',num2str(zef.sk_zx_rotation));

end




if zef.sc_on

zef.i = zef.i + 1;

zef.sc_points = zef.reuna_p{zef.i};
zef.sc_tetra = zef.reuna_t{zef.i};

zef.sc_scaling = 1.0;
zef.sc_zx_rotation= 0;
zef.sc_yz_rotation= 0;
zef.sc_xy_rotation= 0;
zef.sc_z_correction= 0;
zef.sc_y_correction= 0;
zef.sc_x_correction= 0;

h = evalin('base','zef.h_edit64'); set(h,'string',num2str(zef.sc_scaling));
h = evalin('base','zef.h_edit58'); set(h,'string',num2str(zef.sc_x_correction));
h = evalin('base','zef.h_edit59'); set(h,'string',num2str(zef.sc_y_correction));
h = evalin('base','zef.h_edit60'); set(h,'string',num2str(zef.sc_z_correction));
h = evalin('base','zef.h_edit61'); set(h,'string',num2str(zef.sc_xy_rotation));
h = evalin('base','zef.h_edit62'); set(h,'string',num2str(zef.sc_yz_rotation));
h = evalin('base','zef.h_edit63'); set(h,'string',num2str(zef.sc_zx_rotation));

end





















  



































 
 
 
 
 
 
 
 
 
















































































