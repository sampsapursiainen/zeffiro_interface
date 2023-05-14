function [h_contour,h_text] = zef_plot_contour(zef,rel_val,surf_func,triangles,nodes,varargin)

if not(eval('zef.show_contour_text'))
    h_text = [];
end

n_iter = eval('zef.contour_n_smoothing');
line_width = eval('zef.contour_line_width');
if not(isempty(varargin))
    n_iter = varargin{1};
    if length(varargin) > 1
    end
end

h_fig = gcf;
h_axes = findobj(h_fig.Children,'Tag','axes1');
hold_status = ishold(h_axes);

colormap_size = length(rel_val);
colortune_param = eval('zef.colortune_param');
colormap_cell = eval('zef.colormap_cell');
c_map = eval([colormap_cell{eval('zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']);

if isequal(size(surf_func(:),1),size(nodes,1))
    surf_func = (1/3)*(surf_func(triangles(:,1),:) + surf_func(triangles(:,2),:) + surf_func(triangles(:,3),:));
elseif isequal(size(surf_func(:),1),3*size(triangles,1))
    surf_func = mean(reshape(surf_func,3,size(triangles,1)),1);
end

min_val = min(surf_func,[],'all');
max_val = max(surf_func,[],'all');

nodes_orig = nodes;

for j = 1 : length(rel_val)

    nodes = nodes_orig;
    thresh_val = min_val + rel_val(j)*(max_val - min_val);
    I = find(surf_func <= thresh_val);
    edges_aux = [triangles(I,[1 2]); triangles(I,[2 3]); triangles(I,[3 1])];
    edges_aux = sort(edges_aux,2);
    edges_aux = sortrows(edges_aux);
    ind_diff = sum(abs(edges_aux(1:end-1,:) - edges_aux(2:end,:)),2);
    ind_diff = min([ind_diff ; 1],[1 ; ind_diff]);
    I = find(ind_diff);
    edges_aux = edges_aux(I,:);

    [nodes_edge_1,~,nodes_edge_1_ind] = unique(edges_aux);
    nodes_edge_2 = [1 : length(nodes_edge_1)]';
    nodes_edge_3 = zeros(length(nodes_edge_1),1);
    edges_contour = cell(0);
    edges_aux_ind = reshape(nodes_edge_1_ind,size(edges_aux));

    E = sparse([edges_aux_ind(:,2); edges_aux_ind(:,1)],[edges_aux_ind(:,1) ; edges_aux_ind(:,2)],ones(2*size(edges_aux,1),1),length(nodes_edge_1),length(nodes_edge_1));
    nodes_found = 0;
    node_ind = [];

    if not(hold_status)
        hold(h_axes,'on');
    end

    loop_start = 0;
    while ismember(0,nodes_edge_3)

        if isempty(node_ind)
            node_ind = find(not(ismember(nodes_edge_2,nodes_edge_3)),1);

            if not(isempty(node_ind))
                nodes_found = nodes_found + 1;
                nodes_edge_3(nodes_found) = node_ind;
                loop_start = loop_start + 1;
                edges_found = 1;
                edges_contour{loop_start} = zeros(size(edges_aux));
            end
        end

        if not(isempty(node_ind))
            edges_contour{loop_start}(edges_found,1) = node_ind;
            node_neighbor = find(E(:,node_ind));
            node_ind = node_neighbor(find(not(ismember(node_neighbor,nodes_edge_3)),1));
            if isempty(node_ind)
                node_ind = node_neighbor(find(ismember(node_neighbor, edges_contour{loop_start}(1)),1));
            end
            if not(isempty(node_ind))
                %loop_nodes = loop_nodes + 1;
                nodes_found = nodes_found + 1;
                nodes_edge_3(nodes_found) = node_ind;
                edges_contour{loop_start}(edges_found,2) = node_ind;
            end
        end

        edges_found = edges_found + 1;

    end

    for loop_start = 1 : length(edges_contour)
        I = find(min(edges_contour{loop_start},[],2));
        edges_contour{loop_start} = edges_contour{loop_start}(I,:);
        size_edges = size(edges_contour{loop_start});
        edges_contour{loop_start} = reshape(nodes_edge_1(edges_contour{loop_start}),size_edges);

        for i = 1 : n_iter
            nodes_mean = 0.5*(nodes(edges_contour{loop_start}(:,1),:)+nodes(edges_contour{loop_start}(:,2),:));
            nodes(edges_contour{loop_start}(:,1),:) = (nodes(edges_contour{loop_start}(:,1),:) + nodes_mean)/2;
            nodes(edges_contour{loop_start}(:,2),:) = (nodes(edges_contour{loop_start}(:,2),:) + nodes_mean)/2;
        end

        if size(edges_contour{loop_start},1) > 0

            edges_contour{loop_start} = edges_contour{loop_start}';
            edges_contour{loop_start} = edges_contour{loop_start}(:);

            h_contour(loop_start,j) = plot3(h_axes,nodes(edges_contour{loop_start},1),nodes(edges_contour{loop_start},2),nodes(edges_contour{loop_start},3));
            set(h_contour(loop_start,j),'linewidth',line_width)
            set(h_contour(loop_start,j),'color',c_map(j,:))
            set(h_contour(loop_start,j),'tag','contour')

            uistack(h_contour(loop_start,j),'top');

            if eval('zef.show_contour_text')
                h_text(loop_start,j) = text(h_axes,nodes(edges_contour{loop_start}(1,1),1),nodes(edges_contour{loop_start}(1,1),2),nodes(edges_contour{loop_start}(1,1),3),[sprintf('%0.3g',100*rel_val(j)) ' %']);
                set(h_text(loop_start,j),'FontSize',h_axes.FontSize);
                h_text(loop_start,j).Tag = 'contour_text';
                uistack(h_text(loop_start,j),'top');
            end
        end

    end


end



if not(hold_status)
    hold(h_axes,'off');
end



end
