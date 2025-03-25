function [z] = zef_postProcessInverseClassObj(z_inverse, procFile)
%zef_postProcessInverse reorders the inverse output z_inverse to fit the
%visibility options. The procFile is given by zef_processLeadfield
source_direction_mode=procFile.source_direction_mode;
source_directions=procFile.source_directions;
s_ind_1=transpose(3*procFile.s_ind_0-[2,1,0]);
s_ind_1=s_ind_1(:);
s_ind_2 = s_ind_1;  %1 and 2 have the same origin at the moment (07.02.25)
s_ind_4 = procFile.s_ind_4;
if ismember(source_direction_mode,[2])
    s_ind_5=transpose(3*procFile.s_ind_4-[2,1,0]);
    s_ind_5 = s_ind_5(:);
end
sizeL2=procFile.sizeL2;

z=cell(size(z_inverse));
for f_ind=1:length(z_inverse)
z_vec=z_inverse{f_ind};

    if ismember(source_direction_mode, [1,2])
        z_aux = zeros(sizeL2,1);
    end
    if source_direction_mode == 3
        z_aux = zeros(3*sizeL2,1);
    end

    if ismember(source_direction_mode,[2])
        z_vec_aux = sum(reshape(z_vec(s_ind_5),3,[]))'/3;
        smart_directions = source_directions(s_ind_4,1:3)';
        z_vec(s_ind_5) = repelem(z_vec_aux,3).*smart_directions(:);
    end

    if ismember(source_direction_mode,[3])
        smart_directions = source_directions';
        z_vec = z_vec.*smart_directions;
    end

    if ismember(source_direction_mode,[1 2])
        z_aux(s_ind_1) = z_vec;
    end
    if ismember(source_direction_mode,[3])
        z_aux(s_ind_2) = z_vec;
    end

%    if number_of_frames > 1
        z{f_ind} = z_aux;
%     else
%         z = z_aux;
%     end

end
