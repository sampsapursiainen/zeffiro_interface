classdef StripToolDiscTest < matlab.unittest.TestCase
%STRIPTOOLDISCTEST  DiSC 64 and 128 lattices; legacy strip models unchanged.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Models 1–3 stay at radius 0.635 mm. Models 4 and 5 are the DiSC
%   depth array: radius 0.400 mm, 8 columns, 0.200 mm pitch, 0.120 mm
%   contacts. No figure and no embed on the geometry tests.

    methods (TestClassSetup)
        function addStripToolPath(~)
            root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
            addpath(fullfile(root, 'plugins', 'StripTool'));
            addpath(fullfile(root, 'src', 'gui', 'chrome'));
        end
    end

    methods (Test)
        function legacyModelsKeepRadiusAndContactCount(testCase)
            expected_n = [4 8 40];
            for model = 1:3
                s = tests.unit.StripToolDiscTest.parameters(model);
                testCase.verifyEqual(s.strip_radius, 0.635);
                testCase.verifyEqual(s.strip_n_contacts, expected_n(model));
            end
        end

        function discModelsUseNarrowShaft(testCase)
            for model = 4:5
                s = tests.unit.StripToolDiscTest.parameters(model);
                testCase.verifyEqual(s.strip_radius, 0.400);
            end
            testCase.verifyEqual(tests.unit.StripToolDiscTest.parameters(4).strip_n_contacts, 64);
            testCase.verifyEqual(tests.unit.StripToolDiscTest.parameters(5).strip_n_contacts, 128);
        end

        function disc64LatticeAndShaft(testCase)
            s = tests.unit.StripToolDiscTest.built(4);
            pts = tests.unit.StripToolDiscTest.pointsOf(s);
            [x1, y1] = pol2cart(0, 0.400);
            testCase.verifyEqual(pts(1, :), [x1 y1 0.200], 'AbsTol', 1e-10);
            [x8, y8] = pol2cart(7 * 2 * pi / 8, 0.400);
            testCase.verifyEqual(pts(8, :), [x8 y8 0.200], 'AbsTol', 1e-10);
            testCase.verifyEqual(pts(9, :), [x1 y1 0.400], 'AbsTol', 1e-10);
            tests.unit.StripToolDiscTest.verifyLattice(testCase, pts);
            testCase.verifyGreaterThan(size(s.triangles{1}, 1), 0);
            z = s.points{1}(:, 3);
            testCase.verifyEqual(max(z) - min(z), s.strip_length, 'AbsTol', 1e-8);
            [patch, ~, ~] = zef_get_strip_contacts(1, s, struct(), 'model_geometry');
            testCase.verifyTrue(isnumeric(patch));
        end

        function disc128Lattice(testCase)
            s = tests.unit.StripToolDiscTest.built(5);
            pts = tests.unit.StripToolDiscTest.pointsOf(s);
            testCase.verifyEqual(size(pts, 1), 128);
            [x128, y128] = pol2cart(7 * 2 * pi / 8, 0.400);
            testCase.verifyEqual(pts(128, :), [x128 y128 3.200], 'AbsTol', 1e-10);
            testCase.verifyEqual(hypot(pts(128, 1), pts(128, 2)), 0.400, 'AbsTol', 1e-10);
            tests.unit.StripToolDiscTest.verifyLattice(testCase, pts);
        end

        function popupListsDiscModels(testCase)
            old_vis = get(0, 'DefaultFigureVisible');
            cleaner = onCleanup(@() set(0, 'DefaultFigureVisible', old_vis)); %#ok<NASGU>
            try
                set(0, 'DefaultFigureVisible', 'off');
                zef = struct('strip_tool', struct());
                zef = zef_strip_tool_window(zef);
            catch ME
                if tests.unit.StripToolDiscTest.displayMissing(ME)
                    testCase.assumeFail(['No display available for the Strip tool figure; popup String assertion skipped. ' ME.message]);
                end
                rethrow(ME);
            end
            fig = zef.strip_tool.h_window;
            testCase.addTeardown(@() local_close(fig));
            labels = zef.strip_tool.h_strip_model.String;
            testCase.verifyEqual(labels(:)', {'Omnidirectional 4','Directional 8','Directional 40','DiSC 64','DiSC 128'});

            zef.current_sensors = 's';
            zef.strip_tool.current_strip = 1;
            zef.strip_tool.strip_current_id = 1;
            zef.s_strip_cell = { ...
                struct('strip_id', 1, 'strip_tag', 'a', 'strip_model', 4, ...
                    'strip_status', 'Tentative', 'encapsulation_on', 0), ...
                struct('strip_id', 2, 'strip_tag', 'b', 'strip_model', 5, ...
                    'strip_status', 'Tentative', 'encapsulation_on', 0)};
            zef.strip_tool.h_strip_model.Value = 1;
            zef = zef_strip_tool_init(zef);
            testCase.verifyEqual(zef.strip_tool.h_strip_model.Value, 4);
            zef = zef_strip_tool_update(zef);
            names = zef.strip_tool.h_strip_list.UserData.Names;
            testCase.verifyTrue(contains(names{1}, 'DiSC 64'));
            testCase.verifyTrue(contains(names{2}, 'DiSC 128'));
            testCase.verifyEqual(zef.s_strip_cell{1}.strip_model, 4);
            testCase.verifyEqual(zef.s_strip_cell{2}.strip_model, 5);

            zef.strip_tool.current_strip = 2;
            zef.strip_tool.h_strip_model.Value = 1;
            zef = zef_strip_tool_init(zef);
            testCase.verifyEqual(zef.strip_tool.h_strip_model.Value, 5);

            zef.strip_tool.current_strip = 1;
            zef.s_strip_cell{1} = struct('strip_id', 1);
            zef.strip_tool.h_strip_model.Value = 3;
            zef = zef_strip_tool_init(zef);
            testCase.verifyEqual(zef.strip_tool.h_strip_model.Value, 1);

            zef.s_strip_cell{1}.strip_model = 99;
            zef = zef_strip_tool_init(zef);
            testCase.verifyEqual(zef.strip_tool.h_strip_model.Value, numel(labels));
        end
    end

    methods (Static, Access = private)
        function s = baseStrip(model)
            s = struct();
            s.strip_model = model;
            s.orientation_axis = {[0; 0; 1], [0; 0; 1]};
            s.tip_point = [0; 0; 0];
            s.strip_angle = 0;
            s.strip_length = 10;
            s.encapsulation_length = 10;
            s.encapsulation_thickness = 0.5;
            s.encapsulation_on = 0;
            s.strip_n_sectors = 20;
            s.strip_id = 1;
        end

        function s = parameters(model)
            s = zef_get_strip_parameters(tests.unit.StripToolDiscTest.baseStrip(model));
        end

        function s = built(model)
            s = zef_create_strip(tests.unit.StripToolDiscTest.baseStrip(model));
        end

        function pts = pointsOf(s)
            n = s.strip_n_contacts;
            pts = zeros(n, 3);
            for i = 1:n
                pts(i, :) = zef_get_strip_contacts(i, s, struct(), 'points');
            end
        end

        function verifyLattice(testCase, pts)
            n = size(pts, 1);
            for i = 1:n
                row = ceil(i / 8);
                column = mod(i - 1, 8);
                [x, y] = pol2cart(column * (2 * pi / 8), 0.400);
                z = 0.200 + 0.200 * (row - 1);
                testCase.verifyEqual(pts(i, :), [x y z], 'AbsTol', 1e-10);
                testCase.verifyEqual(hypot(pts(i, 1), pts(i, 2)), 0.400, 'AbsTol', 1e-10);
            end
            dmin = inf;
            for i = 1:n - 1
                delta = pts(i + 1:end, :) - pts(i, :);
                dmin = min(dmin, min(sqrt(sum(delta .^ 2, 2))));
            end
            testCase.verifyGreaterThan(dmin, 0.120);
        end

        function tf = displayMissing(ME)
            id = lower(char(string(ME.identifier)));
            msg = lower(char(string(ME.message)));
            tf = contains(id, 'display') || contains(msg, 'display') || contains(msg, 'no java');
        end
    end
end

function local_close(fig)
if ~isempty(fig) && isgraphics(fig) && isvalid(fig)
    delete(fig);
end
end
