function S = zef_hdiv_stencil(tetrahedra,sub_ind,varargin)

K = length(sub_ind);
K2 = size(tetrahedra,1);

if not(isempty(varargin))
    value_vec = varargin{1};
else
    value_vec = ones(K2,1);
end


%An auxiliary matrix for picking up the correct nodes from tetrahedra
ind_m = [ 2 3 4 ;
    3 4 1 ;
    4 1 2 ;
    1 2 3 ];

% Next find nodes that share a face
Ind_cell = cell(1,3);

for i = 1 : 4
    % Find the global node indices for each tetrahedra
    % that correspond to indices ind_m(i,:) and set them to increasing order
    Ind_mat_fi_1 = sort(tetrahedra(sub_ind,ind_m(i,:)),2);
    for j = i + 1 : 4
        % The same for indices ind_m(j,:)
        Ind_mat_fi_2 = sort(tetrahedra(sub_ind,ind_m(j,:)),2);
        % Set both matrices in one variable, including element index and which node it corresponds
        Ind_mat = sortrows([ Ind_mat_fi_1 sub_ind(:) i*ones(K,1) ; Ind_mat_fi_2 sub_ind(:) j*ones(K,1) ]);
        % Find the rows that have the same node indices, i.e. share a face
        I = find(sum(abs(Ind_mat(1:end-1,1:3)-Ind_mat(2:end,1:3)),2)==0);
        Ind_cell{i}{j} = [ Ind_mat(I,4) Ind_mat(I+1,4)  Ind_mat(I,5) Ind_mat(I+1,5) ]; %% Make this better

    end
end

clear Ind_mat_fi_1 Ind_mat_fi_2;
% Set the node indices and element indices in one matrix
Ind_mat = [ Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; Ind_cell{2}{3} ; Ind_cell{2}{4} ; Ind_cell{3}{4} ];
clear Ind_cell;
% Drop the double and triple rows
[Ind_mat_fi_2,I] = unique(Ind_mat(:,1:2),'rows');
clear Ind_mat_fi_2;
Ind_mat = Ind_mat(I,:);
% Here we check that all of the elements were from brain layer
Ind_mat = Ind_mat(find(sum(ismember(Ind_mat(:,1:2),sub_ind),2)),:);
S = spdiags(value_vec, 0, K2, K2);
S = S + sparse(Ind_mat(:,1),Ind_mat(:,2),value_vec(Ind_mat(:,2)), K2, K2);
S = S + sparse(Ind_mat(:,2),Ind_mat(:,1),value_vec(Ind_mat(:,1)), K2, K2);

end
