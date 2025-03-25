function [q] = find_evolution_prior(L, f_data, likelihood_std, evolution_prior_db,evolution_mode)
% q to evolution prior

switch evolution_mode
    case 1
    %Since R = likelihood_std^2*eye, we have 
    % A_noise = (1/(p*A_signal))*A_signal => SNR = p^2*A_signal^2 =
    % (q||L||^2)^2/E[||noise||^2]
    % => E[dy^2] -> sqrt(E[dy^2])
        f = sqrt(mean(diff(f_data').^2,2))*10^(evolution_prior_db/20);
        f = [f;f(end)];
        q = transpose((1-likelihood_std^2)*f./repelem(sum(reshape(sum(L.^2),3,[])),3));
    case 2
        %case 1 but spatial sensitivity is averaged
        f = sqrt(mean(diff(f_data').^2,2))*10^(evolution_prior_db/20);
        f = [f;f(end)];
        q = transpose((1-likelihood_std^2)*f/mean(repelem(sum(reshape(sum(L.^2),3,[])),3)));
    case 3
        %Mathematically quarantees a good tracking but numerically instable
        %in 2024
        [~,S,V] =  svd(L,"econ");
        f = diff(f_data')';
        f = 10^(evolution_prior_db/20)*sum(f.^2,2)./sum(f_data.^2,2);         
        S = max((diag(S).^2),likelihood_std^2/(1-likelihood_std^2));
        q = (V.*(f./S)')*V';
    case 4
        %averaged signal space contribution
        S =  svd(L);
        f = diff(f_data')';
        f = sum(f.^2,2)./sum(f_data.^2,2);         
        S = max(S.^2,likelihood_std^2/(1-likelihood_std^2));
        q = mean(f./S)*10^(evolution_prior_db/20);
    case 5
        q = time_step*(svds(L,1).^(2)/sum(L(:).^2))*10^(evolution_prior_db/20);
end
end

