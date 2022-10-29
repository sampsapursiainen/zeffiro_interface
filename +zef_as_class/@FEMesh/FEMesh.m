classdef (Abstract) FEMesh

    %
    % FEMesh
    %
    % An abstract superclass for finite element meshes.
    %
    % Abstract properties
    %
    % - nodes
    %
    %   Cartesian triples of coordinates. Size is N × 3, although 3 × N might
    %   be better for processor cache locality, as Matlab arrays are stored in
    %   column-major order.
    %
    % - elements
    %
    %   N-tuples of node indices. For example, in a tetrahedral mesh this
    %   might be an M × 4 array of positive integers.
    %

    properties (Abstract)

        nodes (:,3) double { mustBeReal }

        elements (:,:) double { mustBeInteger, mustBePositive }

    end

end % classdef
