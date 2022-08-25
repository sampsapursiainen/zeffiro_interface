classdef Zef < handle

    % Zef
    %
    % A handle class that functions as the back-end of the Zeffiro Interface
    % application. The GUI callback functions simply call the methods defined
    % in this class, when a user presses a button to initiate an action.

    properties

        nodes (:,3) double = [];
        tetra (:,4) double { mustBePositive, mustBeInteger } = [];
        L double
        data struct

    end % properties

    events

        DataChanged

    end % events

    methods

        function self = Zef(data)

            % Zef.Zef
            %
            % A constructor for Zef.
            %
            % Input:
            %
            % - data
            %
            %   A struct with the fields a Zef might have. These should
            %   ideally be statically defined, but for interoperability with
            %   an older implementation
            %
            % Output:
            %
            % - self
            %
            %   An instance of Zef.

            try
                self.L = data.L;
            catch
                warning('Could not read lead field from give data. Setting L = [];')
                self.L = [];
            end

            try
                self.nodes = data.nodes;
            catch
                warning('Could not read nodes from give data. Setting L = [];')
                self.nodes = [];
            end

            try
                self.tetra = data.tetra;
            catch
                warning('Could not read tetrahedra from give data. Setting L = [];')
                self.tetra = [];
            end

            self.data = data;

        end % function

    end % methods

    methods (Static)

        function self = load_from_file(filepath)

            try
                data = load(filepath).zef_data;
            catch
                warning('Could not find zef_data within the given pickle file. Setting Zef.data field as an empty struct.')
                data = struct;
            end

            self = app.Zef(data);

        end % function

    end % methods (Static)

end % classdef
