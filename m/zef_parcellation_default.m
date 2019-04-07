function [c_table,c_points] = zef_parcellation_default(void)

c_table = cell(0);
c_points = cell(0);

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
for k = 1 : 18  
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
  case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';   
        var_2 = 'zef.d6_priority';
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';   
        var_2 = 'zef.d7_priority';
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';   
        var_2 = 'zef.d8_priority';
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';
        var_2 = 'zef.d9_priority';
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';   
        var_2 = 'zef.d10_priority';
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';   
        var_2 = 'zef.d11_priority';
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';   
        var_2 = 'zef.d12_priority';
      case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';   
        var_2 = 'zef.d13_priority';
    case 14
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
    case 15
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
    case 16
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
     case 17
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
     case 18
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
     end
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);  
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
if k == 1;
    aux_brain_ind(3) = i;
end
if k == 2;
    aux_brain_ind(4) = i;
end
if k == 3;
    aux_brain_ind(5) = i;
end
if k == 4;
    aux_brain_ind(6) = i;
end
if k == 5;
    aux_brain_ind(7) = i;
end
if k == 6;
    aux_brain_ind(8) = i;
end
if k == 7;
    aux_brain_ind(9) = i;
end
if k == 8;
    aux_brain_ind(10) = i;
end
if k == 9;
    aux_brain_ind(11) = i;
end
if k == 10;
    aux_brain_ind(12) = i;
end
if k == 11;
    aux_brain_ind(13) = i;
end
if k == 12;
    aux_brain_ind(14) = i;
end
if k == 13;
    aux_brain_ind(15) = i;
end
if k == 14;
    aux_brain_ind(1) = i;
end
if k == 15;
    aux_brain_ind(2) = i;
end
if k == 16;
    aux_brain_ind(16) = i;
end
if k == 17;
    aux_brain_ind(17) = i;
end
if k == 18;
    aux_brain_ind(18) = i;
end
if k == 17;
    aux_skull_ind = i;
end
end
end

c_ind = 0;

if evalin('base','zef.wm_sources') && not(evalin('base','zef.wm_sources')==3)
if not(aux_brain_ind(1)==0) 
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(1));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.w_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.w_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(1);
c_table{t_ind}{4}(J) =  aux_brain_ind(1);
end
end
if evalin('base','zef.g_sources')
if not(aux_brain_ind(2)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(2));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.g_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.g_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(2);
c_table{t_ind}{4}(J) =  aux_brain_ind(2);
end
end
if evalin('base','zef.d1_sources')
if not(aux_brain_ind(3)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(3));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d1_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d1_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(3);
c_table{t_ind}{4}(J) =  aux_brain_ind(3);
end
end
if evalin('base','zef.d2_sources')
if not(aux_brain_ind(4)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(4));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d2_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d2_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(4);
c_table{t_ind}{4}(J) =  aux_brain_ind(4);
end
end
if evalin('base','zef.d3_sources')
if not(aux_brain_ind(5)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(5));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d3_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d3_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(5);
c_table{t_ind}{4}(J) =  aux_brain_ind(5);
end
end
if evalin('base','zef.d4_sources')
if not(aux_brain_ind(6)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(6));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d4_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d4_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(6);
c_table{t_ind}{4}(J) =  aux_brain_ind(6);
end
end
if evalin('base','zef.d5_sources')
if not(aux_brain_ind(7)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(7));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d5_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d5_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(7);
c_table{t_ind}{4}(J) =  aux_brain_ind(7);
end
end
if evalin('base','zef.d6_sources')
if not(aux_brain_ind(8)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(8));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d6_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d6_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(8);
c_table{t_ind}{4}(J) =  aux_brain_ind(8);
end
end
if evalin('base','zef.d7_sources')
if not(aux_brain_ind(9)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(9));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d7_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d7_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(9);
c_table{t_ind}{4}(J) =  aux_brain_ind(9);
end
end
if evalin('base','zef.d8_sources')
if not(aux_brain_ind(10)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(10));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d8_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d8_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(10);
c_table{t_ind}{4}(J) =  aux_brain_ind(10);
end
end
if evalin('base','zef.d9_sources')
if not(aux_brain_ind(11)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(11));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d9_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d9_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(11);
c_table{t_ind}{4}(J) =  aux_brain_ind(11);
end
end
if evalin('base','zef.d10_sources')
if not(aux_brain_ind(12)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(12));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d10_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d10_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(12);
c_table{t_ind}{4}(J) =  aux_brain_ind(12);
end
end
if evalin('base','zef.d11_sources')
if not(aux_brain_ind(13)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(13));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d11_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d11_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(13);
c_table{t_ind}{4}(J) =  aux_brain_ind(13);
end
end
if evalin('base','zef.d12_sources')
if not(aux_brain_ind(14)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(14));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d12_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d12_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(14);
c_table{t_ind}{4}(J) =  aux_brain_ind(14);
end
end
if evalin('base','zef.d13_sources')
if not(aux_brain_ind(15)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(15));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.d13_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.d13_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(15);
c_table{t_ind}{4}(J) =  aux_brain_ind(15);
end
end
if evalin('base','zef.c_sources')
if not(aux_brain_ind(16)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(16));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.c_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.c_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(16);
c_table{t_ind}{4}(J) =  aux_brain_ind(16);
end
end
if evalin('base','zef.sk_sources')
if not(aux_brain_ind(17)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(17));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.sk_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.sk_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(17);
c_table{t_ind}{4}(J) =  aux_brain_ind(17);
end
end
if evalin('base','zef.sc_sources')
if not(aux_brain_ind(18)==0)
c_ind = c_ind + 1;
I = find(evalin('base','zef.sigma(zef.brain_ind,2)')==aux_brain_ind(18));
J = unique(s_interp_ind(I,:));
c_table{t_ind}{2}{c_ind,1} = evalin('base','zef.sc_name');
c_table{t_ind}{3}(c_ind,1:3) = evalin('base','zef.sc_color');
c_table{t_ind}{3}(c_ind,5) =  aux_brain_ind(18);
c_table{t_ind}{4}(J) =  aux_brain_ind(18);
end
end

c_table{t_ind}{3}(:,1:3) = round(255*c_table{t_ind}{3}(:,1:3));
c_table{t_ind}{4} = c_table{t_ind}{4}(:);

end

