classdef UiConfirmTest < matlab.unittest.TestCase
%UICONFIRMTEST  Blocking Yes/No must return the button that was pressed.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Find currents (and every other zef_ui_confirm caller) treats any
%   answer other than 'Yes' as a cancel. The dialog used to be demoted
%   from modal to normal, closed inside the button callback, and then
%   reported 'No' after the user had pressed Yes.

    properties
        Figures = gobjects(0)
    end

    methods (TestMethodTeardown)
        function cleanupConfirm(testCase)
            local_stop_timers();
            leftover = findall(groot, 'Tag', 'zef_confirm');
            for i = 1:numel(leftover)
                if isgraphics(leftover(i)) && isvalid(leftover(i))
                    delete(leftover(i));
                end
            end
            for i = 1:numel(testCase.Figures)
                if isgraphics(testCase.Figures(i)) && isvalid(testCase.Figures(i))
                    delete(testCase.Figures(i));
                end
            end
            testCase.Figures = gobjects(0);
        end
    end

    methods (Test)

        function blockingYesReturnsYesAndStaysModal(testCase)
            local_arm('Yes');
            choice = zef_ui_confirm('Confirm calculations?', 'ZI');
            testCase.verifyEqual(choice, 'Yes');
            testCase.verifyEqual(local_seen_style(), 'modal');
            testCase.verifyEmpty(findall(groot, 'Tag', 'zef_confirm'));
        end

        function blockingNoReturnsNo(testCase)
            local_arm('No');
            choice = zef_ui_confirm('Confirm calculations?', 'ZI');
            testCase.verifyEqual(choice, 'No');
            testCase.verifyEmpty(findall(groot, 'Tag', 'zef_confirm'));
        end

        function nonblockingDialogStaysOpenUntilAnswer(testCase)
            [choice, fig] = zef_ui_confirm('Reset all?', 'Wait', false);
            testCase.Figures(end+1) = fig;
            testCase.verifyEqual(choice, 'No');
            testCase.verifyTrue(isgraphics(fig) && isvalid(fig));
            testCase.verifyEqual(char(fig.WindowStyle), 'normal');
            yes = findobj(fig, 'Tag', 'zef_confirm_yes');
            testCase.verifyNotEmpty(yes);
            cb = yes(1).ButtonPushedFcn;
            cb(yes(1), []);
            testCase.verifyFalse(isgraphics(fig) && isvalid(fig));
        end

    end

end

function local_arm(answer)

local_stop_timers();
assignin('base', 'ui_confirm_answer', char(answer));
assignin('base', 'ui_confirm_style_seen', '');
poll = timer('ExecutionMode', 'fixedRate', 'Period', 0.15, ...
    'TasksToExecute', 40, 'TimerFcn', @(~, ~) local_press(), ...
    'Tag', 'ui_confirm_poll');
watch = timer('StartDelay', 8, 'TimerFcn', @(~, ~) local_force_close(), ...
    'Tag', 'ui_confirm_watch');
start(poll);
start(watch);

end

function local_press()

answer = 'Yes';
try
    answer = evalin('base', 'ui_confirm_answer');
catch
end
fig = findall(groot, 'Tag', 'zef_confirm');
if isempty(fig) || ~isvalid(fig(1))
    return
end
waiting = false;
try
    waiting = strcmpi(char(fig(1).WaitStatus), 'waiting');
catch
end
if ~waiting
    return
end
try
    assignin('base', 'ui_confirm_style_seen', char(fig(1).WindowStyle));
catch
end
tag = 'zef_confirm_yes';
if strcmpi(answer, 'No')
    tag = 'zef_confirm_no';
end
btn = findobj(fig(1), 'Tag', tag);
if isempty(btn)
    return
end
cb = btn(1).ButtonPushedFcn;
cb(btn(1), []);
local_stop_timers();

end

function style = local_seen_style()

style = '';
try
    style = char(evalin('base', 'ui_confirm_style_seen'));
catch
end

end

function local_force_close()

fig = findall(groot, 'Tag', 'zef_confirm');
if isempty(fig)
    return
end
try
    uiresume(fig(1));
catch
end

end

function local_stop_timers()

for tag = {'ui_confirm_poll', 'ui_confirm_watch'}
    found = timerfindall('Tag', tag{1});
    for i = 1:numel(found)
        try
            stop(found(i));
        catch
        end
        try
            delete(found(i));
        catch
        end
    end
end

end
