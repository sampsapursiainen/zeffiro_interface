classdef Zef < handle

    % Zef
    %
    % A handle class that functions as the back-end of the Zeffiro Interface
    % application. The GUI callback functions simply call the methods defined
    % in this class, when a user presses a button to initiate an action.
    %
    % Zef Properties:
    %
    % - nodes
    %
    %   The nodes that make up a finite element mesh.
    %
    % - tetra
    %
    %   The finite elements formed from nodes.
    %
    % - L
    %
    %   A lead field matrix computed by solving Maxwell's equations in the
    %   domain defined by the finite element mesh.
    %
    % - data
    %
    %   Other auxiliary data.


    properties

        nodes (:,3) double = [];

        tetra (:,4) double { mustBePositive, mustBeInteger } = [];

        L double

        data struct

    end % properties

    events

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
            %   NOTE: Zef explicitly ignores graphics objects, because it
            %   represents the back-end of Zeffiro Interface. Back-ends do not
            %   handle graphics.
            %
            % Output:
            %
            % - self
            %
            %   An instance of Zef.

            arguments
                data struct
            end

            fieldkeys = fieldnames(data);

            for fi = 1 : length(fieldkeys)

                finame = fieldkeys{fi};

                fival = data.(finame);

                is_graphics_obj = isa(fival, 'matlab.graphics.Graphics');

                if is_graphics_obj || strcmp(finame, "fieldnames")

                    % Ignore graphical handles

                elseif strcmp(finame, 'nodes')

                    self.nodes = data.(finame)

                elseif strcmp(finame, 'tetra')

                    self.tetra = data.(finame)

                elseif strcmp(finame, 'L')

                    self.L = data.(finame)

                else

                    self.data(1).(finame) = data.(finame);

                end

            end

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
