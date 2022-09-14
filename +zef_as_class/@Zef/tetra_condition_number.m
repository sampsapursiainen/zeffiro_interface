function [condition_number, volume, longest_edge] = tetra_condition_number(nodes, tetra)

% tetra_condition_number
%
% Computes the condition numbers of the tetrahedra in the finite element mesh.
%
% Inputs:
%
% - nodes
%
%   The nodes in the finite element mesh.
%
% - tetra
%
%   The node index quadruplets in the finite element mesh.
%
% Outputs:
%
% - condition_number
%
%   The condition numbers of the given tetra.
%
% - volume
%
%   The volumes of the given tetra.
%
% - longest_edge
%
%   The longest edge in the finite element mesh.

    arguments

        nodes (:,3) double

        tetra (:,4) double { mustBeInteger, mustBePositive }

    end

    volume = zef_as_class.Zef.tetra_volume(nodes, tetra);

    longest_edge = zef_as_class.Zef.tetra_longest_edge(nodes, tetra);

    condition_number = - 12*volume(:)./(sqrt(2)*longest_edge.^3);

end
