function [A] = connectivity_matrix(source_positions, K, weighted_avg)
% Connectivity matrix
%SMOOTHING_MATRIX Summary of this function goes here
%   Detailed explanation goes here
% TODO: weighted avg
if nargin < 3
    weighted_avg = false;
end

MdlKDT = KDTreeSearcher(source_positions);
[IDX, D] = knnsearch(MdlKDT, source_positions, 'K', K);
A = sparse(size(source_positions,1), size(source_positions,1));

row_idx = 1:size(A,1);

for n_neighbor = 1:K
    n_neighbor_ind = IDX(:,n_neighbor);
    idx = sub2ind(size(A),row_idx' , n_neighbor_ind);
    A(idx) = 1/K;
    % if use weighted avg. D has distances, so it needs adaptation
    %A(idx) = D(:,n_neighbor);
end

% z is indexed as x_1,y_1,z_1,x_2,y_2,z_2,... so on.
% A has the factor for each point, but factors need to expand to each x,y
% and z component
A = kron(A,eye(3));
end

