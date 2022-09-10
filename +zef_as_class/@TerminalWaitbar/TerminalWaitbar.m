classdef TerminalWaitbar

    % TerminalWaitbar
    %
    % A waitbar that can be displayed when Zeffiro is used in a terminal. This
    % is activated by Zef's methods, when it is no using a GUI.
    %
    % NOTE: this class is not a handle class for now, and therefore it should
    % be advanced with
    %
    %   wb = wb.progress();
    %
    % and not just with
    %
    %   wb.progress(); .
    %
    % This might seem silly, but it relieves us of the need to always declare
    % a cleanup object when a terminal waitbar is to be used.
    %
    % Properties:
    %
    % - title_string
    %
    %   The title of this waitbar, diplayed before the progress bar itself.
    %
    % - message
    %
    %   The message that was last displayed.
    %
    % - current_val
    %
    %   The current state of the waitbar, on its way towards completion.
    %
    % - max_val
    %
    %   The maximum value that the waitbar is progressing towards.
    %
    % - print_interval
    %
    %   The interval between state displays.
    %

    properties

        title_string (1,1) string = "";

        message (1,1) string = "";

        current_val (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        max_val (1,1) double { mustBeReal, mustBePositive } = 1;

        print_interval (1,1) double { mustBeInteger, mustBePositive } = 1;

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

            self.message = self.title_string + " starting...";

            self.max_val = max_val;

            if max_val < 1000

                self.print_interval = ceil(self.max_val / 20);

            else

                self.print_interval = ceil(self.max_val / 100);

            end

            fprintf(1, '%s', self.message);

        end % function

        function self = show_progress(self)

            % show_progress
            %
            % Displays the state of this waitbar.
            %

            previous_message = self.message;

            percent = 100 * self.current_val / self.max_val;

            self.message = sprintf("%s: %3.0f %%", self.title_string, percent);

            prev_len = strlength(previous_message);

            curr_len = strlength(self.message);

            len_diff = curr_len - prev_len;

            new_shorter_than_old = len_diff < 0;

            chars_to_delete = max(curr_len, prev_len);

            % Move cursor to start of line.

            for ii = 1 : chars_to_delete

                fprintf(1, '\b');

            end

            % Backspace does not actually delete characters, so we need to
            % fill the remaining existing space with spaces to make it seem
            % empty and then move the cursor back again. If the previous
            % string was longer than the current one, that is.

            if new_shorter_than_old

                needed_spaces = repmat(' ', 1, chars_to_delete);

                needed_backspaces = repmat(sprintf('\b'), 1, chars_to_delete);

                fprintf(1, '%s%s%s', needed_spaces, needed_backspaces, self.message);

            else

                fprintf(1, '%s', self.message);

            end

            % Print a new line upon completion.

            if self.current_val == self.max_val

                fprintf(1, '\n');

            end

        end % function

        function self = progress(self)

            % progress
            %
            % Advances the waitbar by one, and displays the progress when at
            % most a whole 1 % of the self.max_value has been advanced.
            %

            self.current_val = self.current_val + 1;

            has_advanced_enough = mod(self.current_val, self.print_interval) == 0;

            if has_advanced_enough || self.current_val == self.max_val

                self = self.show_progress();

            end

        end % function

    end % methods

end % classdef
