classdef RgbRowTest < matlab.unittest.TestCase
%RGBROWTEST  Figure-tool update accepts segmentation text colors.

    methods (Test)
        function textColorBecomesTriplet(testCase)
            zef = struct();
            zef.compartment_tags = {'w', 'g'};
            zef.w_name = 'White';
            zef.w_color = '0.5000 0 1.0000';
            zef.g_name = 'Gray';
            zef.g_color = [0.2 0.4 0.6];
            zef.sensor_tags = {'s'};
            zef.current_sensors = 's';
            zef.s_points = [0 0 0; 1 0 0];
            zef.s_name = 'EEG';
            zef.s_color = '0.25 0.50 0.75';
            zef = zef_update_fig_details(zef);
            testCase.verifyEqual(zef.w_color, [0.5 0 1]);
            testCase.verifyEqual(size(zef.w_color), [1 3]);
            testCase.verifyEqual(zef.g_color, [0.2 0.4 0.6]);
            testCase.verifyEqual(zef.s_color, [0.25 0.5 0.75]);
        end

        function longNumericRowKeepsFirstThree(testCase)
            zef = struct();
            zef.compartment_tags = {'w'};
            zef.w_color = [0.1 0.2 0.3 0.4 0.5];
            zef = zef_update_fig_details(zef);
            testCase.verifyEqual(zef.w_color, [0.1 0.2 0.3]);
        end

        function unusableTextBecomesGray(testCase)
            zef = struct();
            zef.compartment_tags = {'w'};
            zef.w_color = 'not-a-color';
            zef = zef_update_fig_details(zef);
            testCase.verifyEqual(zef.w_color, [0.7 0.7 0.7]);
        end
    end
end
