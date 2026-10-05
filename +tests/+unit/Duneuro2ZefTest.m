classdef Duneuro2ZefTest < matlab.unittest.TestCase
%DUNEURO2ZEFTEST  DUNEuro → Zeffiro conversion invariants (not one sample's sizes).

    methods (TestClassSetup)
        function addProjectRoot(testCase)
            here = fileparts(mfilename('fullpath'));
            root = fileparts(fileparts(here));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(root));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(root, 'src'), 'IncludingSubfolders', true));
        end
    end

    methods (Test)
        function interleavedLeadFieldFromSensorsSourcesOrientations(testCase)
            n_e = 5;
            n_s = 4;
            eegL = zeros(n_e, n_s, 3);
            for s = 1:n_s
                eegL(:, s, 1) = s;
                eegL(:, s, 2) = 100 + s;
                eegL(:, s, 3) = 200 + s;
            end
            raw = struct();
            raw.eegL = eegL;
            raw.electrodePositions = [1:n_e; zeros(1, n_e); zeros(1, n_e)];
            raw.unit = 'mm';
            [payload, report] = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(size(payload.L), [n_e, 3 * n_s]);
            testCase.verifyEqual(payload.L(:, 1), eegL(:, 1, 1));
            testCase.verifyEqual(payload.L(:, 2), eegL(:, 1, 2));
            testCase.verifyEqual(payload.L(:, 3), eegL(:, 1, 3));
            testCase.verifyEqual(payload.L(:, 4), eegL(:, 2, 1));
            testCase.verifySize(payload.sensors, [n_e, 3]);
            testCase.verifyEqual(payload.sensors(:, 1), (1:n_e)');
            testCase.verifyEqual(payload.source_interpolation_ind{1}, (1:n_s)');
            testCase.verifyEqual(payload.source_direction_mode, 1);
            testCase.verifyTrue(any(strcmp(report.imported, 'L')));
            testCase.verifyFalse(isfield(payload, 'eegL'));
            testCase.verifyFalse(isfield(payload, 'eegT'));
        end

        function threeBySourcesByElectrodesLeadField(testCase)
            n_e = 6;
            n_s = 4;
            eegL = randn(3, n_s, n_e);
            raw = struct('eegL', eegL, 'electrodePositions', randn(3, n_e), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(size(payload.L), [n_e, 3 * n_s]);
            testCase.verifyEqual(payload.L(:, 1), squeeze(eegL(1, 1, :)));
            testCase.verifyEqual(payload.L(:, 2), squeeze(eegL(2, 1, :)));
            testCase.verifyEqual(payload.L(:, 3), squeeze(eegL(3, 1, :)));
        end

        function twoDFieldTripLayoutIsUnchanged(testCase)
            n_e = 4;
            n_s = 2;
            L = randn(n_e, 3 * n_s);
            raw = struct('eegL', L, 'electrodePositions', randn(n_e, 3), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.L, L);
        end

        function twoDTransposedWhenElectrodesMatchColumns(testCase)
            n_e = 4;
            n_s = 2;
            L_native = randn(n_e, 3 * n_s);
            raw = struct('eegL', L_native.', 'electrodePositions', randn(n_e, 3), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.L, L_native);
        end

        function extraFieldsAndReorderedStructAreIgnored(testCase)
            raw = struct();
            raw.solver_scratch = magic(8);
            raw.eegL = randn(3, 2, 3);
            raw.unrelated = 'hello';
            raw.electrodePositions = eye(3);
            raw.unit = 'mm';
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(size(payload.L, 1), 3);
            testCase.verifyFalse(isfield(payload, 'solver_scratch'));
            testCase.verifyFalse(isfield(payload, 'unrelated'));
        end

        function omittedTransferIsNotCopied(testCase)
            raw = struct();
            raw.eegL = randn(4, 3, 4);
            raw.eegT = randn(100, 4);
            raw.electrodePositions = randn(4, 3);
            raw.unit = 'mm';
            [payload, report] = utilities.duneuro2zef.convert(raw);
            testCase.verifyFalse(isfield(payload, 'eegT'));
            testCase.verifyTrue(any(contains(string(report.omitted), 'eegT')));
        end

        function zeroBasedTetraBecomeOneBased(testCase)
            nodes = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
            tetra = [0 1 2 3];
            raw = struct('nodes', nodes, 'elements', tetra, ...
                'labels', 1, 'conductivity', 0.33, 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.tetra, [1 2 3 4]);
            testCase.verifyEqual(max(payload.tetra(:)), size(payload.nodes, 1));
            testCase.verifyEqual(numel(payload.domain_labels), 1);
        end

        function hexahedraAreSplitNotRejected(testCase)
            [x, y, z] = ndgrid(0:1, 0:1, 0:1);
            nodes = [x(:), y(:), z(:)];
            hexa = 1:8;
            raw = struct('nodes', nodes, 'elements', hexa, 'labels', 2, 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(size(payload.tetra, 2), 4);
            testCase.verifyEqual(size(payload.tetra, 1), 6);
            testCase.verifyEqual(payload.domain_labels, ones(6, 1));
            testCase.verifyEqual(payload.duneuro_import.original_tissue_ids, 2);
            testCase.verifyEqual(payload.c1_name, 'DUNEuro tissue 2');
            testCase.verifyTrue(max(payload.tetra(:)) <= size(payload.nodes, 1));
            vol = zef_tetra_volume(payload.nodes, payload.tetra, false);
            testCase.verifyTrue(all(abs(vol) > 0));
        end

        function metresBecomeMillimetres(testCase)
            raw = struct();
            raw.eegL = randn(3, 3);
            raw.electrodePositions = [0.01 0 0; 0 0.02 0; 0 0 0.03];
            raw.unit = 'm';
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.sensors, 1000 * [0.01 0 0; 0 0.02 0; 0 0 0.03]);
            testCase.verifyEqual(payload.location_unit, 1);
        end

        function coordinateUnitDoesNotRescaleLeadField(testCase)
            % A metre mesh is stored in millimetres. That scale belongs on
            % coordinates only; the lead field is already the DUNEuro solve.
            n_e = 4;
            n_s = 5;
            eegL = randn(n_e, n_s, 3);
            raw = struct();
            raw.eegL = eegL;
            raw.electrodePositions = randn(3, n_e) * 0.08;
            raw.unit = 'm';
            payload = utilities.duneuro2zef.convert(raw);
            expected = reshape(permute(eegL, [1 3 2]), n_e, []);
            testCase.verifyEqual(payload.L, expected);
            testCase.verifyEqual(payload.sensors, 1000 * raw.electrodePositions.');
        end

        function anisotropyPackedAsZeffiroColumns(testCase)
            nodes = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
            raw = struct();
            raw.nodes = nodes;
            raw.elements = [1 2 3 4];
            raw.labels = 1;
            raw.conductivity = 0.33;
            raw.tensors = [1 2 3 0.1 0.2 0.3];
            raw.unit = 'mm';
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(size(payload.sigma, 2), 8);
            testCase.verifyEqual(payload.sigma(1, 3:8), [1 2 3 0.1 0.2 0.3]);
        end

        function processLeadfieldsSeesInterleavedRawL(testCase)
            n_e = 8;
            n_s = 3;
            eegL = randn(n_e, n_s, 3);
            raw = struct('eegL', eegL, 'electrodePositions', randn(n_e, 3), ...
                'source_positions', randn(n_s, 3), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            zef = payload;
            zef.source_directions = [];
            [L_proc, n_interp] = zef_processLeadfields(zef);
            testCase.verifyEqual(n_interp, n_s);
            testCase.verifyEqual(size(L_proc, 2), 3 * n_s);
            s_reorder_ind = reshape((1:n_interp) + (0:n_interp:(2 * n_interp))', [], 1);
            L_trip = L_proc(:, s_reorder_ind);
            testCase.verifyEqual(L_trip(:, 1:3), [eegL(:, 1, 1), eegL(:, 1, 2), eegL(:, 1, 3)]);
        end

        function sensorLeadFieldMismatchErrors(testCase)
            raw = struct('eegL', randn(5, 9), 'electrodePositions', randn(3, 3), 'unit', 'mm');
            testCase.verifyError(@() utilities.duneuro2zef.convert(raw), ...
                'duneuro2zef:SensorLeadFieldMismatch');
        end

        function transferOnlyErrors(testCase)
            raw = struct('eegT', randn(20, 4));
            testCase.verifyError(@() utilities.duneuro2zef.convert(raw), ...
                'duneuro2zef:EmptyProject');
        end

        function nativeZeffiroNamesAreNotDuneuro(testCase)
            tf = utilities.duneuro2zef.is_duneuro_project( ...
                {'compartment_tags', 'tetra', 'nodes', 'L', 'current_version'});
            testCase.verifyFalse(tf);
            tf = utilities.duneuro2zef.is_duneuro_project( ...
                {'eegL', 'eegT', 'electrodePositions'});
            testCase.verifyTrue(tf);
        end

        function zefLoadConvertsDuneuroMatWithoutCopyingEegL(testCase)
            folder = tempname;
            mkdir(folder);
            testCase.addTeardown(@() rmdir(folder, 's'));
            eegL = randn(4, 2, 3); %#ok<NASGU>
            electrodePositions = randn(3, 4); %#ok<NASGU>
            eegT = randn(20, 4); %#ok<NASGU>
            mat_path = fullfile(folder, 'duneuro_toy.mat');
            save(mat_path, 'eegL', 'electrodePositions', 'eegT');
            testCase.verifyTrue(utilities.duneuro2zef.is_duneuro_project(mat_path));
            [payload, report] = utilities.duneuro2zef.convert(mat_path);
            testCase.verifyEqual(size(payload.L, 1), 4);
            testCase.verifyEqual(size(payload.L, 2), 6);
            testCase.verifyFalse(isfield(payload, 'eegL'));
            testCase.verifyFalse(isfield(payload, 'eegT'));
            testCase.verifyTrue(any(contains(string(report.omitted), 'eegT')));
            testCase.verifyTrue(isfield(payload, 's_points'));
            testCase.verifyEqual(size(payload.s_points, 1), 4);
            session = struct('use_display', 0, 'program_path', pwd);
            session = zef_merge_project_data(session, payload);
            testCase.verifyEqual(size(session.L, 1), 4);
            testCase.verifyFalse(isfield(session, 'eegL'));
        end

        function convertedPayloadIsNotClassifiedAsDuneuro(testCase)
            raw = struct('eegL', randn(3, 3), 'electrodePositions', eye(3), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            folder = tempname;
            mkdir(folder);
            testCase.addTeardown(@() rmdir(folder, 's'));
            save(fullfile(folder, 'out.mat'), '-struct', 'payload');
            testCase.verifyFalse(utilities.duneuro2zef.is_duneuro_project(fullfile(folder, 'out.mat')));
        end

        function extraElectrodeColumnsBecomePemXyz(testCase)
            xyz = [1 0 0; 0 2 0; 0 0 3; 4 5 6];
            raw = struct('eegL', randn(4, 3), 'electrodePositions', [xyz, rand(4, 3)], 'unit', 'mm');
            [payload, report] = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.sensors, xyz);
            testCase.verifyEqual(size(payload.duneuro_import.electrode_aux, 2), 3);
            testCase.verifyTrue(any(contains(string(report.warnings), 'extra columns')));
        end

        function zeroBasedTissueLabelsBecomeConsecutive(testCase)
            nodes = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 1 1 1];
            tetra = [1 2 3 4; 2 3 4 5];
            raw = struct('nodes', nodes, 'elements', tetra, ...
                'labels', [0; 1], 'conductivity', [0.33; 0.01], 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.domain_labels, [1; 2]);
            testCase.verifyEqual(payload.c1_name, 'DUNEuro tissue 0');
            testCase.verifyEqual(payload.c2_name, 'DUNEuro tissue 1');
            testCase.verifyEqual(payload.sigma(1, 1), 0.33);
            testCase.verifyEqual(payload.sigma(2, 1), 0.01);
        end

        function threeSourcesKeepOrientationLast(testCase)
            n_e = 5;
            n_s = 3;
            eegL = zeros(n_e, n_s, 3);
            for s = 1:n_s
                eegL(:, s, 1) = s;
                eegL(:, s, 2) = 100 + s;
                eegL(:, s, 3) = 200 + s;
            end
            raw = struct('eegL', eegL, 'electrodePositions', randn(n_e, 3), 'unit', 'mm');
            payload = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(payload.L(:, 1), eegL(:, 1, 1));
            testCase.verifyEqual(payload.L(:, 2), eegL(:, 1, 2));
            testCase.verifyEqual(payload.L(:, 3), eegL(:, 1, 3));
        end

        function unsupportedInputsErrorClearly(testCase)
            testCase.verifyError(@() utilities.duneuro2zef.convert(struct('foo', 1)), ...
                'duneuro2zef:EmptyProject');
            raw = struct('eegL', randn(4, 5, 3), 'electrodePositions', randn(6, 3), 'unit', 'mm');
            testCase.verifyError(@() utilities.duneuro2zef.convert(raw), ...
                'duneuro2zef:SensorLeadFieldMismatch');
        end

        function runMatchesConvertAndEmptyErrors(testCase)
            raw = struct('eegL', randn(3, 3), 'electrodePositions', eye(3), 'unit', 'mm');
            [from_run, run_report] = utilities.duneuro2zef.run(raw);
            from_convert = utilities.duneuro2zef.convert(raw);
            testCase.verifyEqual(from_run.L, from_convert.L);
            testCase.verifyTrue(any(strcmp(run_report.imported, 'L')));
            testCase.verifyError(@() utilities.duneuro2zef.run([]), ...
                'duneuro2zef:EmptyProject');
        end

        function findFilesHonoursSizePriority(testCase)
            folder = tempname;
            mkdir(folder);
            testCase.addTeardown(@() rmdir(folder, 's'));
            fid = fopen(fullfile(folder, 'a.dat'), 'w'); fwrite(fid, 'aa'); fclose(fid);
            fid = fopen(fullfile(folder, 'b.dat'), 'w'); fwrite(fid, 'bbbb'); fclose(fid);
            [~, small_name] = utilities.duneuro2zef.find_files('*.dat', folder, 'smallest');
            [~, large_name] = utilities.duneuro2zef.find_files('*.dat', folder, 'largest');
            [missing_path, missing_name] = utilities.duneuro2zef.find_files('*.dat', tempname);
            testCase.verifyEqual(small_name, 'a.dat');
            testCase.verifyEqual(large_name, 'b.dat');
            testCase.verifyEqual(missing_path, '');
            testCase.verifyEqual(missing_name, '');
        end

        function exportFolderWithLeadFieldIsDuneuro(testCase)
            folder = tempname;
            mkdir(folder);
            testCase.addTeardown(@() rmdir(folder, 's'));
            LF_EEG = randn(3, 6); %#ok<NASGU>
            save(fullfile(folder, 'LF_EEG.mat'), 'LF_EEG');
            testCase.verifyTrue(utilities.duneuro2zef.is_duneuro_project(folder));
            testCase.verifyFalse(utilities.duneuro2zef.is_duneuro_project(tempname));
        end
    end
end
