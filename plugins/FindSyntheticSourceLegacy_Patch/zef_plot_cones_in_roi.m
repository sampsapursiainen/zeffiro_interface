function h_synth_source = zef_plot_cones_in_roi(zef,s_length)
[~,s_ind_all,s_o_all,n] = zef_find_source_patch(zef);


fix_amp = eval('zef.inv_synth_source(1,15)');
  


radius = eval('zef.inv_synth_source(:,12)');
s_a = eval('zef.inv_synth_source(:,7)');

source_positions = eval('zef.source_positions');
arrow_type = 2; 
s_f = [];

if size(n,1)==1
    end_ind = 1;
else
    end_ind = size(n,1)-1;
end

for i=1:end_ind
    s_ind = s_ind_all(n(i):n(i+1)-1);
    if size(s_o_all,1)<size(s_ind_all,1)
        s_o = repmat(s_o_all(i,:),size(s_ind,1),1);
        if ~fix_amp
            s_f = [s_f;s_o*s_a(i)];
        else
            s_f = [s_f;s_o*s_a(i)/size(s_ind,1)];
        end
    else
        if ~fix_amp
            s_f = [s_f;[s_o_all(n(i):n(i+1)-1,:)*s_a(i)]];
        else
             s_f = [s_f;s_o_all(n(i):n(i+1)-1,:)*s_a(i)/size(s_ind,1)];
        end
    
    end
    
    
    
    s_p = source_positions(s_ind,:);
   
    
end
cone_scale = s_length/2*1/max(radius);
h_synth_source = coneplot(source_positions(s_ind_all,1),source_positions(s_ind_all,2),source_positions(s_ind_all,3),s_f(:,1),s_f(:,2),s_f(:,3),cone_scale,'nointerp');
end