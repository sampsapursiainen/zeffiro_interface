classdef RgbRowTest < matlab.unittest.TestCase
%RGBROWTEST  Text and oversized compartment colors become 1-by-3 RGB.

    methods (Test)
        function legacySegmentationTextIsTriplet(testCase)
            rgb = zef_rgb_row('0.5000 0 1.0000');
            testCase.verifyEqual(rgb, [0.5 0 1]);
            testCase.verifyEqual(size(rgb), [1 3]);
        end

        function bracketedTextAndNamedColor(testCase)
            testCase.verifyEqual(zef_rgb_row('[0.7, 0.7, 0.7]'), [0.7 0.7 0.7]);
            testCase.verifyEqual(zef_rgb_row('blue'), [0 0 1]);
        end

        function numericRowColumnAndByteScale(testCase)
            testCase.verifyEqual(zef_rgb_row([0.2 0.3 0.4]), [0.2 0.3 0.4]);
            testCase.verifyEqual(zef_rgb_row([0.2; 0.3; 0.4]), [0.2 0.3 0.4]);
            testCase.verifyEqual(zef_rgb_row([128 0 255]), [128 0 255] ./ 255, 'AbsTol', 1e-12);
            testCase.verifyEqual(zef_rgb_row([0.1 0.2 0.3 0.4 0.5]), [0.1 0.2 0.3]);
        end

        function unusableValueUsesFallback(testCase)
            testCase.verifyEqual(zef_rgb_row('not-a-color', [1 0 0]), [1 0 0]);
            testCase.verifyEqual(zef_rgb_row([]), [0.7 0.7 0.7]);
        end

        function normalizeRewritesTextAndKeepsTriplet(testCase)
            zef = struct();
            zef.compartment_tags = {'w', 'g'};
            zef.w_color = '0.5000 0 1.0000';
            zef.g_color = [0.2 0.4 0.6];
            zef.sensor_tags = {'s'};
            zef.s_color = '0.25 0.50 0.75';
            row1 = '0.5000 0 1.0000';
            row2 = '0.1 0.2 0.3';
            zef.s_color_table = [row1; row2, repmat(' ', 1, numel(row1) - numel(row2))];
            zef = zef_normalize_colors(zef);
            testCase.verifyEqual(zef.w_color, [0.5 0 1]);
            testCase.verifyEqual(zef.g_color, [0.2 0.4 0.6]);
            testCase.verifyEqual(zef.s_color, [0.25 0.5 0.75]);
            testCase.verifyEqual(zef.s_color_table, [0.5 0 1; 0.1 0.2 0.3], 'AbsTol', 1e-12);
        end

        function figureDetailsAcceptsTextColor(testCase)
            zef = struct();
            zef.compartment_tags = {'w', 'sc'};
            zef.w_name = 'White';
            zef.w_color = '0.5000 0 1.0000';
            zef.sc_name = 'Scalp';
            zef.sc_color = [0.8 0.7 0.6];
            zef = zef_update_fig_details(zef);
            testCase.verifyEqual(zef.w_color, [0.5 0 1]);
            testCase.verifyEqual(zef.sc_color, [0.8 0.7 0.6]);
        end

        function sensorListAcceptsTextSetColor(testCase)
            zef = struct();
            zef.current_sensors = 's';
            zef.s_points = [0 0 0; 1 0 0];
            zef.s_name = 'EEG';
            zef.s_color = '0.5000 0 1.0000';
            [~, colors, n] = zef_sensor_list_items(zef);
            testCase.verifyEqual(n, 2);
            testCase.verifyEqual(colors, [0.5 0 1; 0.5 0 1]);
        end
    end
end
