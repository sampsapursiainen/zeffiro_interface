function [tetra, flag_val, nodes_ind] = inverted_tetra(self, nodes, tetra, thresh_val)

% inverted_tetra (tetra_turn)
%
% Finds out which tetra have been inverted, as in which tetra have vertices
% that have been pulled through their opposite face, inverting the sign of the
% volume of the tetrahedron during mesh smoothing.
%
% Also modifies the tetra by scaling them with the discovered volume ratios
% and returns them.
%
% Inputs
%
% - self
%
%   The instance of Zef which called one of the Zef refinement methods.
%
% - nodes
%
%   Nodes in the Zef finite element mesh.
%
% - tetra
%
%   Node index quadruplets in the finite element mesh.
%
% - thresh_val
%
%   The tolarance of interpreting whether a tetra has inverted.
%
% Outputs:
%
% - tetra
%
%   The modified tetra.
%
% - flag_val
%
%   A logical flag which tells whether the condition numbers of each tetra was
%   within the tolerance adjusted by the given thresh_val.
%
% - nodes_ind
%
%   The indices of tetra whose codition numbers are within the given
%   tolerance.

    arguments

        self zef_as_class.Zef

        nodes (:,3) double

        tetra (:,4) double { mustBeInteger, mustBePositive }

        thresh_val (1,1) double { mustBeReal, mustBePositive }

    end

    flag_val = 1;

    if self.use_gui

        wb = waitbar(0,'Mesh optimization'.);

        cleanup_fn = @(wb) close(wb);

        cleanup_obj = onCleanup(@() cleanup_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar("Mesh optimization", self.mesh_optimization_repetitions);

    end

    tetra_ind = 0;

    iter_ind_aux_0 = 0;

    [condition_number, tilavuus] = self.condition_number(nodes,tetra);

    while not(isempty(tetra_ind)) & iter_ind_aux_0 < self.mesh_optimization_repetitions

        iter_ind_aux_0 =  iter_ind_aux_0 + 1;

        condition_number_thresh = max(0,thresh_val*max(condition_number));

        tetra_ind = find(condition_number < condition_number_thresh);

        rejected_elements = length(tetra_ind);

        if not(isempty(tetra_ind))

            roi_ind = find(sum(ismember(tetra,tetra(tetra_ind,:)),2)==3);

            tetra_aux_1 = tetra(tetra_ind,:);

            for i = 1 : length(tetra_ind)

                flipped_tetra = 0;

                if tilavuus(tetra_ind(i)) > 0
                    flipped_tetra = 1;
                end

                [tetra_aux_ind] = find(sum(ismember(tetra(roi_ind,:),tetra_aux_1(i,:)),2)==3);

                tetra_aux_ind = roi_ind(tetra_aux_ind);

                tilavuus_aux_1 = zef_as_class.Zef.tetra_volume( ...
                    nodes, ...
                    tetra, ...
                    false, ...
                    tetra_aux_ind ...
                );

                tetra_aux_ind = tetra_aux_ind(find(tilavuus_aux_1<0));

                tetra_aux_3 = zeros(2,4,3,length(tetra_aux_ind));
                tilavuus_ratio = zeros(3,length(tetra_aux_ind));
                tilavuus_ratio_old = zeros(length(tetra_aux_ind));

                for j = 1 : length(tetra_aux_ind)

                    tetra_aux_2 = tetra(tetra_aux_ind(j),:);

                    node_ind_3 = intersect(tetra_aux_1(i,:), tetra_aux_2);

                    node_ind_1 = setdiff(tetra_aux_1(i,:), node_ind_3);

                    node_ind_2 = setdiff(tetra_aux_2, node_ind_3);

                    tilavuus_ratio_old(j) = abs(1 - tilavuus(tetra_ind(i))/tilavuus(tetra_aux_ind(j)));

                    for k = 1 : 3

                        tetra_aux_3(:,:,k,j) = [
                            node_ind_1 node_ind_3(mod(k,3)+1) node_ind_2 node_ind_3(mod(k+1,3)+1); ...
                            node_ind_1 node_ind_2 node_ind_3(mod(k,3)+1) node_ind_3(mod(k+2,3)+1)
                        ];

                        tilavuus_aux_2 = zef_as_class.Zef.tetra_volume( ...
                            self.nodes, ...
                            tetra_aux_3
                        );

                        if tilavuus_aux_2 > 0

                            tetra_aux_3(:,:,k,j) = tetra_aux_3(:,[1 3 2 4],k,j);

                            tilavuus_aux_2 = - tilavuus_aux_2;

                        end % if

                        if tilavuus_aux_2 < 0

                            tilavuus_ratio(k,j) = abs(1 - tilavuus_aux_2(1)/tilavuus_aux_2(2));

                            if not(flipped_tetra) & tilavuus_ratio(k,j) > tilavuus_ratio_old(j)

                                tilavuus_ratio(k,j) = Inf;

                            end

                        else

                            tilavuus_ratio(k,j) = Inf;

                        end % if

                    end % for

                end % for

                k_min_1 = 0;
                k_min_2 = 0;

                [min_vec_aux, k_min_1] = min(tilavuus_ratio);
                [min_val, k_min_2] = min(min_vec_aux);

                if [k_min_1 k_min_2] > 0 & min_val < Inf

                    tetra_1 = reshape(tetra_aux_3(1,:,k_min_1(k_min_2),k_min_2),1,4);

                    tetra_2 = reshape(tetra_aux_3(2,:,k_min_1(k_min_2),k_min_2),1,4);

                    tetra(tetra_ind(i),:) = tetra_1;

                    tetra(tetra_aux_ind(k_min_2),:) = tetra_2;

                    condition_number([tetra_ind(i); tetra_aux_ind(k_min_2)]) = ...
                        self.condition_number(nodes,[tetra_1 ; tetra_2]);

                    %tetra = zef_fix_inverted_pair([tetra_ind(i); tetra_aux_ind(k_min_2)],tetra,nodes);

                end % if

            end % for

        end % if

        if self.use_gui

            if mod(i,ceil(length(tetra_ind)/100)) == 0

                waitbar(i/length(tetra_ind),wb,['Mesh optimization. Rejected elements: ' num2str(rejected_elements)]);

            end

        else

            wb = wb.progress();

        end % if

    end % while

    % Determine whether tetra has inverted or not.

    if min(condition_number) < max(0,thresh_val*max(condition_number))

        flag_val = -1;

    else

        flag_val = 1;

    end

    nodes_ind = unique(tetra(find(condition_number < max(0,thresh_val*max(condition_number))),:));

end
