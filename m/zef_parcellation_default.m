function [c_table,c_points] = zef_parcellation_default(void)

c_table = cell(0);
c_points = cell(0);
c_ind = 0;

submesh_ind = evalin('base','zef.submesh_ind');
if isempty(submesh_ind)
    submesh_ind = ones(size(evalin('base','zef.brain_ind')));
end

if evalin('base','zef.parcellation_merge')
c_table = evalin('base','zef.parcellation_colortable');
c_points = evalin('base','zef.parcellation_points');
else
evalin('base','zef.parcellation_selected = [];');
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
for k = 1 : 27   
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
        var_0 = 'zef.d14_on';
        var_1 = 'zef.d14_sigma';
        var_2 = 'zef.d14_priority';
        var_3 = 'zef.d14_visible';
    color_str = evalin('base','zef.d14_color');
     case 15
        var_0 = 'zef.d15_on';
        var_1 = 'zef.d15_sigma';   
        var_2 = 'zef.d15_priority';
        var_3 = 'zef.d15_visible';
        color_str = evalin('base','zef.d15_color');
     case 16
        var_0 = 'zef.d16_on';
        var_1 = 'zef.d16_sigma';   
        var_2 = 'zef.d16_priority';
        var_3 = 'zef.d16_visible';
        color_str = evalin('base','zef.d16_color');
     case 17
        var_0 = 'zef.d17_on';
        var_1 = 'zef.d17_sigma';   
        var_2 = 'zef.d17_priority';
        var_3 = 'zef.d17_visible';
        color_str = evalin('base','zef.d17_color');
 case 18
        var_0 = 'zef.d18_on';
        var_1 = 'zef.d18_sigma';
        var_2 = 'zef.d18_priority';
        var_3 = 'zef.d18_visible';
        color_str = evalin('base','zef.d18_color');
     case 19
        var_0 = 'zef.d19_on';
        var_1 = 'zef.d19_sigma';   
        var_2 = 'zef.d19_priority';
        var_3 = 'zef.d19_visible';
        color_str = evalin('base','zef.d19_color');
     case 20
        var_0 = 'zef.d20_on';
        var_1 = 'zef.d20_sigma';   
        var_2 = 'zef.d20_priority';
        var_3 = 'zef.d20_visible';
        color_str = evalin('base','zef.d20_color');
     case 21
        var_0 = 'zef.d21_on';
        var_1 = 'zef.d21_sigma';   
        var_2 = 'zef.d21_priority';
        var_3 = 'zef.d21_visible';
        color_str = evalin('base','zef.d21_color');
  case 22
        var_0 = 'zef.d22_on';
        var_1 = 'zef.d22_sigma';   
        var_2 = 'zef.d22_priority';
        var_3 = 'zef.d22_visible';
        color_str = evalin('base','zef.d22_color');
 case 23
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 24
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 25
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 26
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 27
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        color_str = evalin('base','zef.sc_color');
     end
on_val = evalin('base',var_0);      
if on_val
i = i + 1;

switch k 
    case 1
        c_str = 'd1';
    case 2
        c_str = 'd2';
    case 3
        c_str = 'd3';
    case 4
        c_str = 'd4';
    case 5 
        c_str = 'd5';
    case 6
        c_str = 'd6';
    case 7
        c_str = 'd7';
    case 8
        c_str = 'd8';
    case 9
        c_str = 'd9';
    case 10
        c_str = 'd10';
    case 11
        c_str = 'd11';
    case 12
        c_str = 'd12';
    case 13
        c_str = 'd13';
    case 14
        c_str = 'd14';
    case 15
        c_str = 'd15';
    case 16
        c_str = 'd16';
    case 17
        c_str = 'd17';
    case 18
        c_str = 'd18';
    case 19
        c_str = 'd19';
    case 20
        c_str = 'd20';
    case 21
        c_str = 'd21';
    case 22
        c_str = 'd22';
    case 23
        c_str = 'w';
    case 24
        c_str = 'g';
    case 25
        c_str = 'c';
    case 26
        c_str = 'sk';
    case 27
        c_str = 'sc';
end
    
if ismember(evalin('base',['zef.' c_str '_sources']),[1 2])
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==i);
submesh_ind_aux = unique(submesh_ind(I));
if isempty(submesh_ind_aux)
    submesh_ind_aux = 1;
end

for ell_ind = 1 : length(submesh_ind_aux)
c_ind = c_ind + 1;
I_aux = find(submesh_ind(I)==submesh_ind_aux(ell_ind));
J = unique(s_interp_ind(I(I_aux),:));
if length(submesh_ind_aux) > 1
c_table{t_ind}{2}{c_ind,1} = [evalin('base',['zef.' c_str '_name']) ' ' num2str(submesh_ind_aux(ell_ind))];
else
c_table{t_ind}{2}{c_ind,1} = [evalin('base',['zef.' c_str '_name'])];    
end
c_table{t_ind}{3}(c_ind,1:3) = evalin('base',['zef.' c_str '_color']);
c_table{t_ind}{3}(c_ind,5) =  c_ind;
c_table{t_ind}{5}(c_ind,:) = [i submesh_ind_aux(ell_ind)];
c_table{t_ind}{4}(J) = c_ind;
end
end
end

end

c_table{t_ind}{3}(:,1:3) = round(255*c_table{t_ind}{3}(:,1:3));
c_table{t_ind}{4} = c_table{t_ind}{4}(:);

end


