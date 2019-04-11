function [c_table,c_points] = zef_parcellation_default(void)

c_table = cell(0);
c_points = cell(0);
c_ind = 0;

if evalin('base','zef.parcellation_merge')
c_table = evalin('base','zef.parcellation_colortable');
c_points = evalin('base','zef.parcellation_points');
end

s_interp_ind = evalin('base','zef.source_interpolation_ind{1}');

t_ind = 1 + length(c_table);

c_table{t_ind}{1} = 'BM';
c_points_aux = evalin('base','zef.source_positions');
c_points_aux = [[0:size(c_points_aux,1)-1]' c_points_aux];
c_table{t_ind}{4} = zeros(size(c_points,1),1);

c_points{t_ind} = c_points_aux;

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
for k = 1 : 18   
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
        var_3 = 'zef.d1_visible';
    color_str = evalin('base','zef.d1_color');
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
        var_3 = 'zef.d2_visible';
        color_str = evalin('base','zef.d2_color');
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
        var_3 = 'zef.d3_visible';
        color_str = evalin('base','zef.d3_color');
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
        var_3 = 'zef.d4_visible';
        color_str = evalin('base','zef.d4_color');
     case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
        var_3 = 'zef.d5_visible';
    color_str = evalin('base','zef.d5_color');
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';   
        var_2 = 'zef.d6_priority';
        var_3 = 'zef.d6_visible';
        color_str = evalin('base','zef.d6_color');
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';   
        var_2 = 'zef.d7_priority';
        var_3 = 'zef.d7_visible';
        color_str = evalin('base','zef.d7_color');
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';   
        var_2 = 'zef.d8_priority';
        var_3 = 'zef.d8_visible';
        color_str = evalin('base','zef.d8_color');
 case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';
        var_2 = 'zef.d9_priority';
        var_3 = 'zef.d9_visible';
        color_str = evalin('base','zef.d9_color');
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';   
        var_2 = 'zef.d10_priority';
        var_3 = 'zef.d10_visible';
        color_str = evalin('base','zef.d10_color');
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';   
        var_2 = 'zef.d11_priority';
        var_3 = 'zef.d11_visible';
        color_str = evalin('base','zef.d11_color');
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';   
        var_2 = 'zef.d12_priority';
        var_3 = 'zef.d12_visible';
        color_str = evalin('base','zef.d12_color');
  case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';   
        var_2 = 'zef.d13_priority';
        var_3 = 'zef.d13_visible';
        color_str = evalin('base','zef.d13_color');
 case 14
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 15
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 16
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 17
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 18
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        color_str = evalin('base','zef.sc_color');
     end
on_val = evalin('base',var_0);      
if on_val
i = i + 1;

if k == 1 && evalin('base','zef.d1_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d1_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d1_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 2 && evalin('base','zef.d2_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d2_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d2_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 3 && evalin('base','zef.d3_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d3_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d3_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 4 && evalin('base','zef.d4_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d4_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d4_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 5 && evalin('base','zef.d5_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d5_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d5_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 6 && evalin('base','zef.d6_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d6_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d6_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 7 && evalin('base','zef.d7_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d7_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d7_color');
c_table{t_ind}{3}(c_ind,5) = i;
c_table{t_ind}{5}(c_ind,1) = i;
c_table{t_ind}{4}(J) = i;
end
if k == 8 && evalin('base','zef.d8_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d8_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d8_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 9 && evalin('base','zef.d9_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d9_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d9_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 10 && evalin('base','zef.d10_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d10_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d10_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 11 && evalin('base','zef.d11_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d11_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d11_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 12 && evalin('base','zef.d12_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d12_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d12_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 13 && evalin('base','zef.d13_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d13_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d13_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 14 && evalin('base','zef.wm_sources') && not(evalin('base','zef.wm_sources')==3)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.w_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.w_color');
c_table{t_ind}{3}(c_ind,5) = i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
if k == 15 && evalin('base','zef.g_sources')
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.g_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.g_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 16 && evalin('base','zef.c_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.c_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.c_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 17 && evalin('base','zef.sk_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.sk_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.sk_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) =  i;
end
if k == 18 && evalin('base','zef.sc_sources');
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.sc_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.sc_color');
c_table{t_ind}{3}(c_ind,5) =  i;
c_table{t_ind}{5}(c_ind,1) =  i;
c_table{t_ind}{4}(J) = i;
end
end

end

c_table{t_ind}{3}(:,1:3) = round(255*c_table{t_ind}{3}(:,1:3));
c_table{t_ind}{4} = c_table{t_ind}{4}(:);


