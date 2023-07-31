function [b_coord, det] = zef_volume_barycentric(nodes,tetra,p_ind,det)
%
% zef_volume_barycentric
%
% TODO: Sampsa should document this.
%
% Inputs:
%
% - nodes
%
%   TODO: explanation.
%
% - tetra
%
%   TODO: explanation.
%
% - p_ind
%
%   TODO: explanation.
%
% - det
%
%   TODO: explanation.
%
% Outputs:
%
% - b_coord
%
%   TODO: explanation.
%
% - det
%
%   TODO: explanation.
%

b_coord = [];
det_1 = [];
det_2 = [];
I = [1 2 3 4];

if nargin == 2
    p_ind = [];
    [~,~,~,det] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
        reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
        reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3));
else

    if nargin > 2


        if nargin < 4
            det = [];
        end

        if isequal(length(p_ind),1)
            p_val = zeros(size(tetra));
            J_2 = [];
            p_val(:,p_ind) = 1;
            if isequal(p_ind,4)
                I = [4 1 2 3];
            end
        else
            p_val = zeros(size(tetra));
            p_ind = p_ind(:);
            J_2 = find(p_ind == 4);
            J_1 = setdiff([1:size(tetra,1)]',J_2);
            p_ind_aux = sub2ind(size(tetra),[1:size(tetra,1)]',p_ind);
            p_val(p_ind_aux) = 1;
        end

    end

    if isempty(J_2)

        if isempty(det)
            [x,y,z,det] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
                reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
                reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3),...
                p_val(:,I(1:3)));
        else
            [x,y,z] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
                reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
                reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3),...
                p_val(:,I(1:3)),det);
        end

        b_coord = [x y z p_val(:,I(4))-x.*nodes(tetra(:,I(4)),1)-y.*nodes(tetra(:,I(4)),2)-z.*nodes(tetra(:,I(4)),3)];


    else

        if isempty(det)
            [x,y,z,det_1] = zef_3by3_solver(reshape(nodes(tetra(J_1,I(1:3)),1)-nodes(tetra(J_1,I([4 4 4])),1),length(J_1),3),...
                reshape(nodes(tetra(J_1,I(1:3)),2)-nodes(tetra(J_1,I([4 4 4])),2),length(J_1),3),...
                reshape(nodes(tetra(J_1,I(1:3)),3)-nodes(tetra(J_1,I([4 4 4])),3),length(J_1),3),...
                p_val(J_1,I(1:3)));
        else
            [x,y,z] = zef_3by3_solver(reshape(nodes(tetra(J_1,I(1:3)),1)-nodes(tetra(J_1,I([4 4 4])),1),length(J_1),3),...
                reshape(nodes(tetra(J_1,I(1:3)),2)-nodes(tetra(J_1,I([4 4 4])),2),length(J_1),3),...
                reshape(nodes(tetra(J_1,I(1:3)),3)-nodes(tetra(J_1,I([4 4 4])),3),length(J_1),3),...
                p_val(J_1,I(1:3)),det(J_1));
        end

        b_coord = zeros(size(tetra));
        b_coord(J_1,:) = [x y z p_val(J_1,I(4))-x.*nodes(tetra(J_1,I(4)),1)-y.*nodes(tetra(J_1,I(4)),2)-z.*nodes(tetra(J_1,I(4)),3)];

        I = [4 1 2 3];

        if isempty(det)
            [x,y,z,det_2] = zef_3by3_solver(reshape(nodes(tetra(J_2,I(1:3)),1)-nodes(tetra(J_2,I([4 4 4])),1),length(J_2),3),...
                reshape(nodes(tetra(J_2,I(1:3)),2)-nodes(tetra(J_2,I([4 4 4])),2),length(J_2),3),...
                reshape(nodes(tetra(J_2,I(1:3)),3)-nodes(tetra(J_2,I([4 4 4])),3),length(J_2),3),...
                p_val(J_2,I(1:3)));
        else

            [x,y,z] = zef_3by3_solver(reshape(nodes(tetra(J_2,I(1:3)),1)-nodes(tetra(J_2,I([4 4 4])),1),length(J_2),3),...
                reshape(nodes(tetra(J_2,I(1:3)),2)-nodes(tetra(J_2,I([4 4 4])),2),length(J_2),3),...
                reshape(nodes(tetra(J_2,I(1:3)),3)-nodes(tetra(J_2,I([4 4 4])),3),length(J_2),3),...
                p_val(J_2,I(1:3)),det(J_2));
        end

        b_coord(J_2,:) = [x y z p_val(J_2,I(4))-x.*nodes(tetra(J_2,I(4)),1)-y.*nodes(tetra(J_2,I(4)),2)-z.*nodes(tetra(J_2,I(4)),3)];

        if and(not(isempty(det_1)),not(isempty(det_2)))
            det = zeros(size(tetra,1),1);
            det(J_1) = det_1;
            det(J_2) = det_2;
        end

    end

end
end

