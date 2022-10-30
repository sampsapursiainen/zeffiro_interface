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

    properties (Abstract, Constant)

        element_size (1,1) double { mustBeInteger, mustBePositive }

    end

    methods (Static)

        function elements_are_valid(mesh_object, elements)

            %
            % elements_are_valid(mesh_object, elements)
            %
            % Checks that the given elements are valid, as in there are no
            % extra or missing node references in the elements.
            %

            arguments

                % TODO: define validator function to make sure mesh_object is
                % a subclass instance of this class, and use it here.

                mesh_object

                elements

            end

            % Get object type in a bit of a roundabout way.

            object_type_name = class(mesh_object);

            % Make sure elements are of proper shape.

            element_size = size(elements, 2);

            object_element_size = mesh_object.element_size;

            if element_size ~= object_element_size

                error("The elements in a " + object_type_name + " have " + object_element_size + " node indices. Got " + element_size + " instead.")

            end

            % Check that there are no extra nodes referenced.

            node_range = 1 : size(mesh_object.nodes, 1);

            extra_nodes_in_elements = not(all(ismember(elements, node_range)));

            if extra_nodes_in_elements

                error("The given elements contain references to non-existent nodes in this " + object_type_name + ". Will not set the value of self.elements.")

            end

            % Check that all nodes are referenced at least once.

            all_nodes_not_referenced = any(not(ismember(node_range, elements)));

            if all_nodes_not_referenced

                error("Some nodes in this " + object_type_name + " are not referenced by the given elements. Not setting the value of self.elements.")

            end

        end % function

    end % methods

end % classdef
