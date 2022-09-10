classdef TerminalWaitbar

    % TerminalWaitbar
    %
    % A waitbar that can be displayed when Zeffiro is used in a terminal. This
    % is activated by Zef's methods, when it is no using a GUI.
    %
    % Properties:
    %
    % - title_string
    %
    %   The title of this waitbar, diplayed before the progress bar itself.
    %
    % - current_val
    %
    %   The current state of the waitbar, on its way towards completion.
    %
    % - max_val
    %
    %   The maximum value that the waitbar is progressing towards.
    %

    properties

        title_string (1,1) string

        message (1,1) string = "";

        current_val (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        max_val (1,1) double { mustBeReal, mustBePositive }

    end % properties

    methods

        function self = TerminalWaitbar(title_string, max_val)

            % TerminalWaitbar
            %
            % A constructor for a waitbar.
            %
            % Input:
            %
            % - title_string
            %
            %   The title of the waitbar.
            %
            % - max_val
            %
            %   The maximum value that the waitbar progresses towards.
            %

            self.title_string = title_string;

            self.current_val = 0;

            self.message = "";

            self.max_val = max_val;

        end % function

        function self = show_progress()

            % show_progress
            %
            % Displays the state of this waitbar.
            %

            previous_message = self.message;

            message_drainer = repmat(sprintf('\b'), 1, length(previous_message));

            percent = 100 * self.current_val / self.max_val;

            self.message = sprintf(self.title + ": %3.0f", percent);

            fprintf(message_drainer + self.message);

        end % function

        function self = progress(self)

            % progress
            %
            % Advances the waitbar by one, and displays the progress when at
            % most a whole 1 % of the self.max_value has been advanced.
            %

            self.current_val += 1;

            percent = floor(100 * self.current_val / self.max_val);

            has_advanced_a_percent = mod(percent, 100) == 0;

            if has_advanced_a_percent

                self.show_progress();

            end

        end % function

    end % methods

end % classdef
