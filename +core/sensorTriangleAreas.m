function Asums = sensorTriangleAreas (triangles, triA, s2nI)
%
% Asums = sensorTriangleAreas (triangles, triA, s2nI)
%
% Finds the triangles that each electrode is attached to and
% computes the sum of their areas.
%
% Inputs:
%
% - nodes
%
%   Finite element nodes.
%
% - triangles
%
%   Triples of node indices indicating which nodes form each
%   triangle.
%
% - triA
%
%   Areas of the triangles in a vector.
%
% - s2nI
%
%   An index vector, where s2nI (i) gives the index of the node
%   that sensor i is attached to.
%
% Outputs:
%
% - Asums
%
%   A vector where Asums (i) gives a sum of the areas of the
%   triangles that are attached to sensor i via the finite
%   element nodes.
%

    arguments
        triangles (3,:) uint32 { mustBePositive }
        triA      (:,1) double { mustBePositive, mustBeFinite }
        s2nI      (:,1) uint32 { mustBePositive }
    end

    Ns = numel (s2nI) ;

    Asums = zeros ( Ns, 1 ) ;

    for sI = 1 : Ns

        % Find node index corresponding to current sensor.

        nI = s2nI ( sI ) ;

        % Find triangles that are touching this sensor.

        triI = any ( ismember ( triangles, nI ), 1 ) ;

        % Sum up their areas.

        Asums (sI) = sum ( triA ( triI ) ) ;

    end % for

end % function
