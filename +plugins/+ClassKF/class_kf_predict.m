function [m, P] = class_kf_predict(KFclassObj)
% kf_predict is the prediction step of kalman filter
    % Skip multiplications if A is Indentity
    if (isdiag(KFclassObj.state_transition_model_A) && all(diag(KFclassObj.state_transition_model_A) - 1) < eps)
        P = KFclassObj.prev_step_posterior_cov  + KFclassObj.evolution_cov;
    else
        % Basic kalman prediction steps
        m = KFclassObj.state_transition_model_A * self.prev_step_reconstruction;
        P = KFclassObj.state_transition_model_A * KFclassObj.prev_step_posterior_cov * KFclassObj.state_transition_model_A' + KFclassObj.evolution_cov;
    end
end
