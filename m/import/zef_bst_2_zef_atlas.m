function [p_c_table, p_points] = zef_bst_2_zef_atlas(subject,surface_ind_aux,surface_struct,atlas_compartment,atlas_type,varargin)

atlas_tag = '';
unit_scale = 1;

unit_scale = 1; 
atlas_tag = atlas_type;
if not(isempty(varargin))
atlas_tag = varargin{1};
if length(varargin) > 1
unit_scale = varargin{2};
end
end

surface_file = [ bst_get('ProtocolInfo').SUBJECTS filesep bst_get('ProtocolSubjects').Subject(subject).Surface(surface_ind_aux).FileName];
load_fields = {'Atlas','Vertices'};
surface_struct = load(surface_file,load_fields{:});

p_c_table = cell(0);
p_points = cell(0);

if atlas_compartment > 0

for i = 1 : length(surface_struct.Atlas)

    if isequal(lower(atlas_type),lower(surface_struct.Atlas(i).Name))
     
        p_c_table{1} = atlas_tag;
        p_c_table{2} = cell(0);
        p_c_table{3} = zeros(length(surface_struct.Atlas(i).Scouts),5);
        
        
        node_counter = 0; 
        for j = 1 : length(surface_struct.Atlas(i).Scouts)
        
        p_c_table{2}{j,1} = surface_struct.Atlas(i).Scouts(j).Label;
        p_c_table{3}(j,1:3) = round(255*surface_struct.Atlas(i).Scouts(j).Color);
        p_c_table{3}(j,5) = j;
        node_counter = node_counter + size(surface_struct.Atlas(i).Scouts(j).Vertices,1);
        
        end      
        
        n_nodes = node_counter;
        p_points = zeros(n_nodes,4);
        p_points(:,1) = [0 : n_nodes-1]';
        p_c_table{4} = zeros(n_nodes,1);
        
        node_counter = 0; 
        for j = 1 : length(surface_struct.Atlas(i).Scouts)
        
            n_nodes_aux = size(surface_struct.Atlas(i).Scouts(j).Vertices,1);
            try
            p_points(node_counter + 1:node_counter + n_nodes_aux,2:4) = unit_scale*surface_struct.Vertices(surface_struct.Atlas(i).Scouts(j).Vertices,:);
            catch
                keyboard
            end
            p_c_table{4}(node_counter + 1:node_counter + n_nodes_aux) = j;
            node_counter = node_counter + n_nodes_aux;
            
        end
        
        p_c_table{5} = cell(0);
        for p_ind = 1 : size(p_c_table{3},1)
        p_c_table{5}{p_ind,1} = zef_find_compartment('name',atlas_compartment);    
        p_c_table{5}{p_ind,2} = 1;
        end
        p_c_table{6} = ones(size(p_c_table{3},1),1);
            
    end
    
end
end
        
end