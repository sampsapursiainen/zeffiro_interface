function out = directionalDerivative ( gradients, directions )
%
% out = directionalDerivative ( gradients, directions )
%
% Computes directional derivatives ∇f ⋅ d based on given gradients and direction vectors.
%

    out = sum ( gradients  .* directions, 2 ) ;

end % function
