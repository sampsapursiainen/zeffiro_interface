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

h = evalin('base','zef.h_edit129'); set(h,'string',num2str(zef.d1_scaling));
end

if zef.d2_on

zef.i = zef.i + 1;

zef.d2_points = zef.reuna_p{zef.i};
zef.d2_tetra = zef.reuna_t{zef.i};

zef.d2_scaling = 1.0;

h = evalin('base','zef.h_edit229'); set(h,'string',num2str(zef.d2_scaling));

end


if zef.d3_on

zef.i = zef.i + 1;

zef.d3_points = zef.reuna_p{zef.i};
zef.d3_tetra = zef.reuna_t{zef.i};

zef.d3_scaling = 1.0;

h = evalin('base','zef.h_edit329'); set(h,'string',num2str(zef.d3_scaling));

end


if zef.d4_on

zef.i = zef.i + 1;

zef.d4_points = zef.reuna_p{zef.i};
zef.d4_tetra = zef.reuna_t{zef.i};

zef.d4_scaling = 1.0;

h = evalin('base','zef.h_edit429'); set(h,'string',num2str(zef.d4_scaling));

end

if zef.d5_on

zef.i = zef.i + 1;

zef.d5_points = zef.reuna_p{zef.i};
zef.d5_tetra = zef.reuna_t{zef.i};

zef.d5_scaling = 1.0;

h = evalin('base','zef.h_d5_scaling'); set(h,'string',num2str(zef.d5_scaling));

end

if zef.d6_on

zef.i = zef.i + 1;

zef.d6_points = zef.reuna_p{zef.i};
zef.d6_tetra = zef.reuna_t{zef.i};

zef.d6_scaling = 1.0;

h = evalin('base','zef.h_d6_scaling'); set(h,'string',num2str(zef.d6_scaling));

end

if zef.d7_on

zef.i = zef.i + 1;

zef.d7_points = zef.reuna_p{zef.i};
zef.d7_tetra = zef.reuna_t{zef.i};

zef.d7_scaling = 1.0;

h = evalin('base','zef.h_d7_scaling'); set(h,'string',num2str(zef.d7_scaling));

end

if zef.d8_on

zef.i = zef.i + 1;

zef.d8_points = zef.reuna_p{zef.i};
zef.d8_tetra = zef.reuna_t{zef.i};

zef.d8_scaling = 1.0;

h = evalin('base','zef.h_d8_scaling'); set(h,'string',num2str(zef.d8_scaling));

end

if zef.d9_on

zef.i = zef.i + 1;

zef.d9_points = zef.reuna_p{zef.i};
zef.d9_tetra = zef.reuna_t{zef.i};

zef.d9_scaling = 1.0;

h = evalin('base','zef.h_d9_scaling'); set(h,'string',num2str(zef.d9_scaling));

end

if zef.d10_on

zef.i = zef.i + 1;

zef.d10_points = zef.reuna_p{zef.i};
zef.d10_tetra = zef.reuna_t{zef.i};

zef.d10_scaling = 1.0;

h = evalin('base','zef.h_d10_scaling'); set(h,'string',num2str(zef.d10_scaling));

end

if zef.d11_on

zef.i = zef.i + 1;

zef.d11_points = zef.reuna_p{zef.i};
zef.d11_tetra = zef.reuna_t{zef.i};

zef.d11_scaling = 1.0;

h = evalin('base','zef.h_d11_scaling'); set(h,'string',num2str(zef.d11_scaling));

end


if zef.d12_on

zef.i = zef.i + 1;

zef.d12_points = zef.reuna_p{zef.i};
zef.d12_tetra = zef.reuna_t{zef.i};

zef.d12_scaling = 1.0;

h = evalin('base','zef.h_d12_scaling'); set(h,'string',num2str(zef.d12_scaling));

end

if zef.d13_on

zef.i = zef.i + 1;

zef.d13_points = zef.reuna_p{zef.i};
zef.d13_tetra = zef.reuna_t{zef.i};

zef.d13_scaling = 1.0;

h = evalin('base','zef.h_d13_scaling'); set(h,'string',num2str(zef.d13_scaling));

end

if zef.w_on

zef.i = zef.i + 1;

zef.w_points = zef.reuna_p{zef.i};
zef.w_tetra = zef.reuna_t{zef.i};

zef.w_scaling = 1.0;

h = evalin('base','zef.h_edit29'); set(h,'string',num2str(zef.w_scaling));

end




if zef.g_on

zef.i = zef.i + 1;

zef.g_points = zef.reuna_p{zef.i};
zef.g_tetra = zef.reuna_t{zef.i};

zef.g_scaling = 1.0;

h = evalin('base','zef.h_edit36'); set(h,'string',num2str(zef.g_scaling));

end





if zef.c_on

zef.i = zef.i + 1;

zef.c_points = zef.reuna_p{zef.i};
zef.c_tetra = zef.reuna_t{zef.i};

zef.c_scaling = 1.0;

h = evalin('base','zef.h_edit50'); set(h,'string',num2str(zef.c_scaling));

end




if zef.sk_on

zef.i = zef.i + 1;

zef.sk_points = zef.reuna_p{zef.i};
zef.sk_tetra = zef.reuna_t{zef.i};

zef.sk_scaling = 1.0;

h = evalin('base','zef.h_edit57'); set(h,'string',num2str(zef.sk_scaling));

end




if zef.sc_on

zef.i = zef.i + 1;

zef.sc_points = zef.reuna_p{zef.i};
zef.sc_tetra = zef.reuna_t{zef.i};

zef.sc_scaling = 1.0;

h = evalin('base','zef.h_edit64'); set(h,'string',num2str(zef.sc_scaling));

end





















  



































 
 
 
 
 
 
 
 
 
















































































