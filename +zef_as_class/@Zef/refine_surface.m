function self = refine_surface(self, n_of_refinements)

% Zef.refine_surface
%
% Refines active compartment surfaces a given number of times.
%
% Inputs:
%
% - self
%
%   The Zef object calling this method.
%
% - n_of_refinements
%
%   The numbers of refinements that are to be performed for each compartment
%   in an array. A value of 0 at index I indicates that the compartment at
%   that index is not to be refined.
%
%   NOTE: if N is the number of compartments, the array should actually
%   contain N+1 values. The last one indicates how many times all active
%   compartments are to be refined.
%
% Output
%
% - self
%
%   The Zef object that called the method.

    arguments

        self zef_as_class.Zef

        n_of_refinements (:,1) double { mustBeInteger, mustBeNonnegative } = zeros(numel(self.compartments) + 1, 1);

    end

    % Declare initial values.

    n_of_compartments = numel(self.compartments);

    if numel(n_of_refinements) ~= n_of_compartments + 1

        error("The size of n_of_refinements must match the size of self.compartments + 1. Aborting...");

    end

    self.mesh_generation_phase = "refinement";

    % First go over individual compartments.

    for cind = 1 : n_of_compartments

        iterations_for_this_compartment = n_of_refinements(cind);

        for n_of_ref = 1 : iterations_for_this_compartment

            self = perform_refinement(self, cind);

            self = self.label_mesh();

        end % for

    end % for

    % Then go over all active compartments, if specified.

    for cind = self.active_compartment_inds()

        n_of_refs = n_of_refinements(end);

        for ref = 1 : n_of_refs

            self = perform_refinement(self, cind);

            self = self.label_mesh();

        end

    end

end % function

%% Local helper functions.

function self = perform_refinement(self, compartment_ind)

    % perform_refinement
    %
    % Does the actual surface refinement for a given compartment index.
    %
    % Input:
    %
    % - self
    %
    %   The instance of Zef that called Zef.refine_surface.
    %
    % - compartment_ind
    %
    %   The index of the compartment that is to be refined.
    %
    % Output:
    %
    % - self
    %
    %   The instance of Zef that called Zef.refine_surface.

    arguments

        self zef_as_class.Zef

        compartment_ind (1,1) double { mustBeInteger, mustBePositive }

    end

    mesh_generation_phase = self.mesh_generation_phase;

    tetra = self.tetra;

    nodes = self.nodes;

    domain_labels = self.domain_labels;

    length_waitbar = 11;

    % Initialize waitbar and cleanup object, if necessary.

    if self.use_gui

        wb = waitbar(0, 'Surface refinement.');

        cu_fn = @(h) close(h);

        cu_obj = onCleanup(@() cu_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar("Surface refinement", length_waitbar);

    end

    J_c = [];

    ind_m = [
        2 4 3 ;
        1 3 4 ;
        1 4 2 ;
        1 2 3
    ];

    tetra_sort = [
        tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]';
        tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]';
        tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]';
        tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';
    ];

    tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
    tetra_sort = sortrows(tetra_sort,[1 2 3]);
    tetra_ind = zeros(size(tetra_sort,1),1);

    I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);

    tetra_ind(I) = 1;

    tetra_ind(I+1) = 1;

    I = find(tetra_ind == 0);

    tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));

    surface_triangles = [ tetra(tetra_ind)];

    J_c = [J_c ;  unique(surface_triangles)];

    if self.use_gui

        waitbar(1/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    tetra_vec = sum(ismember(tetra,J_c),2);

    J = find(tetra_vec);

    ind_aux = unique(tetra(J,:));

    J = find(sum(ismember(tetra,ind_aux),2)==4);

    ind_aux = unique(tetra(J,:));

    ind_aux = ismember(tetra,ind_aux);

    sum_aux = sum(ind_aux,2);

    J_2 = find(sum_aux==2);

    J_3 = find(sum_aux==3);

    if self.use_gui

        waitbar(2/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    J_aux = [J; J_2; J_3];

    aux_vec = [ones(size(J)); 2*ones(size(J_2)); 3*ones(size(J_3))];

    edge_ind = zeros(6*length(J_aux),6);

    aux_ind = [1 2 ; 1 3 ; 1 4 ; 2 3 ; 2 4 ; 3 4];

    for i = 1 : 6
        edge_ind((i-1)*length(J_aux) + 1:i*length(J_aux),[1 2 3 5 6]) = [tetra(J_aux, aux_ind(i,:)) J_aux aux_vec i*ones(length(J_aux),1)];
    end

    edge_ind(:,1:2) = sort(edge_ind(:,1:2),2);

    edge_ind = sortrows(edge_ind,[1 2 5]);

    new_node_ind = 0;

    current_edge = [0 0];

    if self.use_gui

        waitbar(3/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    for i = 1 : size(edge_ind,1)

        if edge_ind(i,5) == 1

            if edge_ind(i,1:2) == current_edge

                edge_ind(i,4) = new_node_ind;

            else

                new_node_ind = new_node_ind + 1;

                current_edge = edge_ind(i,1:2);

                edge_ind(i,4) = new_node_ind;

            end % if

        else

            if edge_ind(i,1:2) == current_edge

                edge_ind(i,4) = new_node_ind;

            end

        end % if

    end % for

    if self.use_gui

        waitbar(4/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    [edge_val_aux edge_ind_2] = unique(edge_ind(:,4));

    edge_ind_2 = edge_ind_2(2:end,:);

    nodes_new = (1/2)*(nodes(edge_ind(edge_ind_2,1),:) + nodes(edge_ind(edge_ind_2,2),:));

    size_nodes = size(nodes,1);

    nodes = [nodes ; nodes_new];

    if self.use_gui

        waitbar(5/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    I =find(edge_ind(:,4));

    edge_ind(I,4) = edge_ind(I,4) + size_nodes;

    edge_ind = sortrows(edge_ind,[5 3 6]);

    edge_mat = reshape(edge_ind(:,4),6,length(J_aux))';

    if self.use_gui

        waitbar(6/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    t_ind_1 = [
        1     5     6     7
        7     9     6    10
        6     8     3    10
        2     9     8     5
        4     7    10     9
        5     6     9     8
        6     9     8    10
        7     9     5     6
    ];

    t_ind_2 = [tetra(J,:) edge_mat(1:length(J),:)];

    tetra_new = [];

    domain_labels_new = [];

    for i = 1 : 7

        tetra_new = [ tetra_new ; t_ind_2(:,t_ind_1(i,:)) ];

        domain_labels_new = [domain_labels_new ; domain_labels(J,:)];

    end

    tetra(J,:) = [ t_ind_2(:,t_ind_1(8,:)) ];

    if self.use_gui

        waitbar(7/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    tetra = [tetra ; tetra_new ];

    domain_labels = [domain_labels ; (domain_labels_new)];

    if self.use_gui

        waitbar(8/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    ind_aux = length(J) + [1 : length(J_2)]';
    tetra_new = [];
    domain_labels_new = [];

    for i = 1 : 6

        switch i
            case 1
                nodes_aux_vec = [1 2 3 4];
            case 2
                nodes_aux_vec = [1 3 2 4];
            case 3
                nodes_aux_vec = [1 4 2 3];
            case 4
                nodes_aux_vec = [2 3 1 4];
            case 5
                nodes_aux_vec = [2 4 1 3];
            case 6
                nodes_aux_vec = [3 4 1 2];
        end

        I = find(edge_mat(ind_aux,i));

        tetra_new = [tetra_new ; edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,1)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];

        domain_labels_new = [domain_labels_new ; domain_labels(J_2(I),:)];

        tetra(J_2(I),:) = [edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,2)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];

    end

    tetra = [tetra ; tetra_new];

    domain_labels = [domain_labels ; (domain_labels_new)];

    if self.use_gui

        waitbar(9/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    ind_aux = length(J) + length(J_2) + [1 : length(J_3)]';

    tetra_new = [];

    domain_labels_new = [];

    for i = 1 : 4

        switch i
            case 1
                nodes_ind_aux = [1 2 3 4];
                col_ind_aux = [1 4 2];
            case 2
                nodes_ind_aux = [1 2 4 3];
                col_ind_aux = [1 5 3];
            case 3
                nodes_ind_aux = [1 3 4 2];
                col_ind_aux = [2 6 3];
            case 4
                nodes_ind_aux = [2 3 4 1];
                col_ind_aux = [4 6 5];
        end

        I = find(sum(not(edge_mat(ind_aux,col_ind_aux)),2)==0);

        if length(I) > 0
            tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,1))  edge_mat(ind_aux(I),col_ind_aux(1)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
            tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,2))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(1)) tetra(J_3(I),nodes_ind_aux(:,4))];
            tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,3))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
            domain_labels_new = [domain_labels_new ; repmat(domain_labels(J_3(I),:),3,1)];
            tetra(J_3(I),:) = [edge_mat(ind_aux(I),col_ind_aux(1))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
        end

        I = find(sum(not(edge_mat(ind_aux,col_ind_aux)),2)==1);

        if length(I)>0

            for j_ind = 1 : length(I)

                [zero_ind_aux, ~] = find(edge_mat(ind_aux(I(j_ind)),col_ind_aux)' == 0);

                switch zero_ind_aux
                case 1
                    col_ind_aux_2 = col_ind_aux([2 3]);
                    k_ind = 3;
                    i_ind = [1 2];
                case 2
                    col_ind_aux_2 = col_ind_aux([1 3]);
                    k_ind = 1;
                    i_ind = [3 2];
                case 3
                    col_ind_aux_2 = col_ind_aux([2 1]);
                    k_ind = 2;
                    i_ind = [1 3];
                end

                if tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1))) > tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(2)))
                    i_ind = fliplr(i_ind);
                    col_ind_aux_2 = fliplr(col_ind_aux_2);
                end


                tetra_new = [tetra_new ; tetra(J_3(I(j_ind)),nodes_ind_aux(k_ind))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(2)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];

                tetra_new = [tetra_new ; tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1)))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(2)) edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];

                domain_labels_new = [domain_labels_new ; repmat(domain_labels(J_3(I(j_ind)),:),2,1)];

                tetra(J_3(I(j_ind)),:) = [tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1))) tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(2)))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];

            end % for

        end % if

    end % for

    tetra = [tetra ; tetra_new];

    domain_labels = [domain_labels ; (domain_labels_new)];

    if self.use_gui

        waitbar(10/length_waitbar,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    tilavuus = zef_as_class.Zef.tetra_volume(nodes, tetra);

    I = find(tilavuus > 0);

    tetra(I,:) = tetra(I,[2 1 3 4]);

    if mesh_generation_phase == "post-processing"

        brain_ind = [];

        for k = 1 : length(self.compartments)

            compartment = self.compartments(k);

            if compartment.sources > 0

                if not(aux_compartment_ind(k)==0) && not(compartment.sources==3)

                    [brain_ind] = [brain_ind ; find(domain_labels==aux_compartment_ind(k))];

                end

            end % if

        end % for

        if sum(aux_compartment_ind) == 0

            brain_ind = find(domain_labels);

        end

        sigma = sigma_vec(domain_labels);

    end % if

    if self.use_gui

        waitbar(1,wb,'Surface refinement.');

    else

        wb = wb.progress();

    end

    tetra_vec = sum(ismember(tetra,J_c),2);

    J = find(tetra_vec);

    J_c = unique(tetra(J,:));

    tetra_vec = sum(ismember(tetra,J_c),2);

    if mesh_generation_phase == "post-processing"

        non_source_ind = find(tetra_vec > 2);

        non_source_ind = intersect(brain_ind, non_source_ind);

    end

    if mesh_generation_phase == "post-processing"

        [nodes,optimizer_flag] = self.fix_negatives(nodes, tetra);

        if optimizer_flag == 1

            [tetra, optimizer_flag] = self.inverted_tetra(nodes, tetra, thresh_val);

        end

    end % if

    self.nodes = nodes;

    self.tetra = tetra;

    self.label_ind = tetra;

    self.domain_labels = domain_labels;

end % function

function subcompartment_ind = compartment_to_subcompartment(self, compartment_ind)

% compartment_to_subcompartment
%
% TODO
%
% Inputs:
%
% - self
%
%   The instance of Zef that called Zef.refine_surface.
%
% - compartment_ind
%
%   TODO
%
% Outputs:
%
% - subcompartment_ind
%
%   TODO

    compartments = self.compartments;

    subcompartment_ind = [];

    compartment_counter = 0;

    subcompartment_counter = 0;

    for i = 1 : length(compartments)

        compartment = compartments(i);

        if compartment.is_on

            submesh_ind = compartment.submesh_ind;

            compartment_counter = compartment_counter + 1;

            if ismember(compartment_counter, compartment_ind)

                subcompartment_ind = [
                    subcompartment_ind ;
                    [subcompartment_counter(end) + 1 : subcompartment_counter(end) + length(submesh_ind)]'
                ];

            end

            subcompartment_counter = subcompartment_counter + length(submesh_ind);

        end

    end

end
