function Z = electrodeImpedance (R, f, C)
%
% Z = electrodeImpedance (R, f, C)
%
% Computes the impedance of an electrode from a resistance R, input frequency f
% and capacitance C, assuming the following circuit diagram describes the
% entire electrode structure:
%
%       - R -
%   S - |   | - W
%       - C -
%
% Here S is skin, and W is the electrode wire, leading to a voltage source. In
% other words, our assumption is that any electrolyte gel is incorporated into
% the capacitive double-layer structure of the electrode.
%
%
    arguments
        R (:,1) double { mustBeFinite, mustBePositive }
        f (:,1) double { mustBeNonnegative, mustBeReal }
        C (:,1) double { mustBeReal, mustBeNonnegative }
    end

    % Make sure no division by zero occurs, and that a user can express the
    % lack of capacitive effects by feeding in zero frequencies and
    % capacitances.

    nonZeroC = C ;

    nonZeroC (C < eps) = Inf ;

    nonZeroF = f ;

    nonZeroF (f < eps) = Inf ;

    % Compute capacitive reactances.

    Xc = 1i / 2 / pi / nonZeroF / nonZeroC ;

    % Compute final impedances.

    Z = R - Xc ;

end % function
