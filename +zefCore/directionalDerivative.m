function out = directionalDerivative ( gradients, directions )
%
% out = directionalDerivative ( gradients, directions )
%
% Computes directional derivatives ∇f ⋅ d based on given gradients and direction vectors.
%

    arguments
        gradients  (:,3) double { mustBeFinite }
        directions (:,3) double { mustBeFinite }
    end

    out = sum ( gradients  .* directions, 2 ) ;

end % function
