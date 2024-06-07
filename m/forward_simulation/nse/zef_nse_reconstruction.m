function [reconstruction, reconstruction_info] = zef_nse_reconstruction(nse_field,type)

reconstruction = cell(0);
reconstruction_info = cell(0);

if isequal(type,1)

    for i = 1 : size(nse_field.bp_vessels,2)

        aux_vec = zef_nse_threshold_distribution(nse_field.bp_vessels{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
        reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
        reconstruction{i} = reconstruction{i}(:);

    end

elseif isequal(type,2)

    for i = 1 : size(nse_field.bv_vessels_1,2)
        aux_vec_1 = zef_nse_threshold_distribution(nse_field.bv_vessels_1{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
        aux_vec_2 = zef_nse_threshold_distribution(nse_field.bv_vessels_2{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
        aux_vec_3 = zef_nse_threshold_distribution(nse_field.bv_vessels_3{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

        reconstruction{i} = (1/sqrt(3))*[aux_vec_1 aux_vec_2 aux_vec_3]';
        reconstruction{i} = reconstruction{i}(:);

    end

elseif isequal(type,3)

    for i = 1 : size(nse_field.mu_vessels,2)

        aux_vec = zef_nse_threshold_distribution(nse_field.mu_vessels{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

        reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
        reconstruction{i} = reconstruction{i}(:);

    end

elseif isequal(type,4)

    for i = 1 : size(nse_field.bf_capillaries,2)

        aux_vec = zef_nse_threshold_distribution(nse_field.bf_capillaries{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

        reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
        reconstruction{i} = reconstruction{i}(:);

    end

    elseif isequal(type,5)

    for i = 1 : size(nse_field.dh_capillaries,2)

        aux_vec = zef_nse_threshold_distribution(nse_field.dh_capillaries{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

        reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
        reconstruction{i} = reconstruction{i}(:);

    end

elseif isequal(type,6)

    reconstruction{1} = zeros(3,size(nse_field.bp_vessels{1}(:),1));

    for i = 1 : size(nse_field.bp_vessels,2)

        aux_vec = nse_field.bp_vessels{i}(:);
        reconstruction{1} = reconstruction{1} + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    reconstruction{1} = reconstruction{1}(:)/size(nse_field.bp_vessels,2);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

elseif isequal(type,7)

    reconstruction{1} = zeros(3,size(nse_field.bp_vessels{1}(:),1));

    for i = 1 : size(nse_field.bp_vessels,2)

        aux_vec = nse_field.bp_vessels{i}(:);
        reconstruction{1} = max(reconstruction{1},(1/sqrt(3))*aux_vec(:,[1 1 1])');

    end

    reconstruction{1} = reconstruction{1}(:);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


elseif isequal(type,8)

    mean_data = zeros(3,size(nse_field.bp_vessels{1}(:),1));

    for i = 1 : size(nse_field.bp_vessels,2)

        aux_vec = nse_field.bp_vessels{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile;
        mean_data = mean_data + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    mean_data = mean_data/size(nse_field.bp_vessels,2);

    reconstruction{1} = zeros(3,size(nse_field.bp_vessels{1}(:),1));


    for i = 1 : size(nse_field.bp_vessels,2)

        aux_vec = nse_field.bp_vessels{i}(:);
        reconstruction{1}  =  reconstruction{1} + ((1/sqrt(3))*aux_vec(:,[1 1 1])' - mean_data).^2;

    end

    reconstruction{1} = sqrt(reconstruction{1}(:)/size(nse_field.bp_vessels,2));
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


elseif isequal(type,9)

    reconstruction{1} = zeros(3,size(nse_field.bv_vessels_1{1}(:),1));

    for i = 1 : size(nse_field.bv_vessels_1,2)

        aux_vec_1 = nse_field.bv_vessels_1{i}(:);
        aux_vec_2 = nse_field.bv_vessels_2{i}(:);
        aux_vec_3 = nse_field.bv_vessels_3{i}(:);

        reconstruction{1} = reconstruction{1} + (1/sqrt(3))*[aux_vec_1 aux_vec_2 aux_vec_3]';

    end

    reconstruction{1} = reconstruction{1}(:)/size(nse_field.bv_vessels_1,2);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

elseif isequal(type,10)

    reconstruction{1} = zeros(3,size(nse_field.bv_vessels_1{1}(:),1));

    for i = 1 : size(nse_field.bv_vessels_1,2)

        aux_vec_1 = nse_field.bv_vessels_1{i}(:);
        aux_vec_2 = nse_field.bv_vessels_2{i}(:);
        aux_vec_3 = nse_field.bv_vessels_3{i}(:);

        reconstruction{1} = max(reconstruction{1},(1/sqrt(3))*[aux_vec_1 aux_vec_2 aux_vec_3]');

    end

    reconstruction{1} = reconstruction{1}(:);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);



elseif isequal(type,11)

    mean_data = zeros(3,size(nse_field.bv_vessels_1{1}(:),1));

    for i = 1 : size(nse_field.bv_vessels_1,2)

        aux_vec_1 = nse_field.bv_vessels_1{i}(:);
        aux_vec_2 = nse_field.bv_vessels_2{i}(:);
        aux_vec_3 = nse_field.bv_vessels_3{i}(:);

        mean_data = mean_data + (1/sqrt(3))*[aux_vec_1 aux_vec_2 aux_vec_3]';


    end

    mean_data = mean_data/size(nse_field.bv_vessels_1,2);

    reconstruction{1} = zeros(3,size(nse_field.bv_vessels_1{1}(:),1));
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


    for i = 1 : size(nse_field.bv_vessels_1,2)

        aux_vec = nse_field.bv_vessels_1{i}(:);
        reconstruction{1}  =  reconstruction{1} + ((1/sqrt(3))*aux_vec(:,[1 1 1])' - mean_data).^2;

    end

    reconstruction{1} = sqrt(reconstruction{1}(:)/size(nse_field.bv_vessels_1,2));
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);



elseif isequal(type,12)

    reconstruction{1} = zeros(3,size(nse_field.mu_vessels{1}(:),1));

    for i = 1 : size(nse_field.mu_vessels,2)

        aux_vec = nse_field.mu_vessels{i}(:);
        reconstruction{1} = reconstruction{1} + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    reconstruction{1} = reconstruction{1}(:)/size(nse_field.mu_vessels,2);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


elseif isequal(type,13)

    reconstruction{1} = zeros(3,size(nse_field.mu_vessels{1}(:),1));

    for i = 1 : size(nse_field.mu_vessels,2)

        aux_vec = nse_field.mu_vessels{i}(:);
        reconstruction{1} = max(reconstruction{1}, (1/sqrt(3))*aux_vec(:,[1 1 1])');

    end

    reconstruction{1} = reconstruction{1}(:);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


elseif isequal(type,14)

    mean_data = zeros(3,size(nse_field.mu_vessels{1}(:),1));

    for i = 1 : size(nse_field.mu_vessels,2)

        aux_vec = nse_field.mu_vessels{i}(:);
        mean_data = mean_data + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    mean_data = mean_data/size(nse_field.mu_vessels,2);

    reconstruction{1} = zeros(3,size(nse_field.mu_vessels{1}(:),1));
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


    for i = 1 : size(nse_field.mu_vessels,2)

        aux_vec = nse_field.mu_vessels{i}(:);
        reconstruction{1}  =  reconstruction{1} + ((1/sqrt(3))*aux_vec(:,[1 1 1])' - mean_data).^2;

    end

    reconstruction{1} = sqrt(reconstruction{1}(:)/size(nse_field.mu_vessels,2));

elseif isequal(type,15)

    reconstruction{1} = zeros(3,size(nse_field.bf_capillaries{1}(:),1));

    for i = 1 : size(nse_field.bf_capillaries,2)

        aux_vec = min(max(0,abs(nse_field.bf_capillaries{i}(:))),1);
        reconstruction{1} = reconstruction{1} + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    reconstruction{1} = reconstruction{1}(:)/size(nse_field.bf_capillaries,2);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);



elseif isequal(type,16)

    reconstruction{1} = zeros(3,size(nse_field.bf_capillaries{1}(:),1));

    for i = 1 : size(nse_field.bf_capillaries,2)

        aux_vec = min(max(0,abs(nse_field.bf_capillaries{i}(:))),1);
        reconstruction{1} = max(reconstruction{1},(1/sqrt(3))*aux_vec(:,[1 1 1])');

    end

    reconstruction{1} = reconstruction{1}(:);
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);


elseif isequal(type,17)

    mean_data = zeros(3,size(nse_field.bf_capillaries{1}(:),1));

    for i = 1 : size(nse_field.bf_capillaries,2)

        aux_vec = min(max(0,abs(nse_field.bf_capillaries{i}(:))),1);
        mean_data = mean_data + (1/sqrt(3))*aux_vec(:,[1 1 1])';

    end

    mean_data = mean_data/size(nse_field.bp_vessels,2);

    reconstruction{1} = zeros(3,size(nse_field.bf_capillaries{1}(:),1));

    for i = 1 : size(nse_field.bf_capillaries,2)

        aux_vec = min(max(0,abs(nse_field.bf_capillaries{i}(:))),1);
        reconstruction{1}  =  reconstruction{1} + ((1/sqrt(3))*aux_vec(:,[1 1 1])' - mean_data).^2;

    end

    reconstruction{1} = sqrt(reconstruction{1}(:)/size(nse_field.bf_capillaries,2));
    reconstruction{1} = zef_nse_threshold_distribution(reconstruction{1},nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);




end


end
