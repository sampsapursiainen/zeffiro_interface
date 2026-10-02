function out = zef_skf_prasikala_benchmark(opts)
%ZEF_SKF_PRASIKALA_BENCHMARK  Three SKF variants from Prasikala et al. (2026).
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Benchmark for
%   Dilshanie Prasikala, Joonas Lahtinen, Alexandra Koulouri, Sampsa
%   Pursiainen, "The effect of prior parameters on standardized Kalman
%   filter-based EEG source localization", Biomedical Signal Processing
%   and Control 121 (2026) 110233.
%   DOI 10.1016/j.bspc.2026.110233
%   Preprint: arXiv:2507.23450 (July 2025).
%
%   The published PDF (final version deposited by the authors, CC BY) is
%   the authority. The July 2025 preprint has no runtime table, no
%   diagonalized surrogate, a 3000-source lead field without the 72-by-8877
%   count, and a shorter prior derivation. Where they disagree, this script
%   follows the published paper and records the difference here.
%
%   PAPER-TO-CODE MAP
%   Random walk, A = I. evolution model "User supplied Q", A = speye.
%   Measurement noise R = sigma^2 I. Peak SNR is 20*log10(A/sigma) with A
%   the maximum absolute clean measurement. Clean sensor data are scaled
%   so A = 1, sigma^2 = 10^(-SNR/10), and signal_to_noise_ratio is that
%   SNR so KalmanInverter.initialize's empty-noise_cov branch stores
%   R = sigma^2 I. inv_data_mode is "raw" so the 20-250 Hz fields in the
%   project file do not filter the synthetic series.
%   PM-SNR and EP-SNR follow published equations (18)-(21) and (25)-(26).
%   dB(u) = 20*log10(|u|), so dB(1) = 0. Then
%     theta_tot = 10^(PM-SNR/10)
%     theta0    = theta_tot * sigma^2 * A^2 / N
%     kappa     = 10^(EP-SNR/20)
%     Q         = (kappa^2 * theta0 / K) * I
%   K is the number of time steps in that run. N is the state dimension
%   (columns of L). Equation (18) with P0 = theta0*I_n has trace N*theta0,
%   so N is n, not the number of source positions. If the authors counted
%   positions, theta0 here is smaller by about 3.
%   The prose "at 0 dB, sqrt(theta_tot) approximates max|J|" does not have
%   the dimensions of equation (19), where theta_tot is E[||x0||^2]/(sigma^2 A^2).
%   This script follows (19) and (21).
%   initialize.m overwrites an empty theta0 with sensitivity scaling. A
%   non-empty theta0 is kept. That is the only class change. kf_sL_update,
%   the RTS math, and kf_sL_update_approx are unchanged.
%
%   TIMING CONFIGURATION (published Appendix B, Fig. B.7, not only Section 4)
%   Fig. B.7(a) is the 30 dB comparison. The text says the SKF there used
%   the tuned prior with RTS smoothing: EP-SNR 20, PM-SNR 0, alpha = 1.25.
%   Fig. B.7(b) is the runtime table on that same dataset and preprocessing.
%   All four numbers are stated in that appendix for the SKF in the figure.
%   They are also the Section 4 smoothed operating point. The no-smoothing
%   row is not given its own EP/PM/alpha sentence; it shares this setting
%   because the caption says the same dataset and preprocessing.
%   Section 4 without smoothing, at 30 dB, also calls EP 20 and PM 0 (or
%   the swap) a best point. This script does not use the file's inv_snr,
%   inv_prior_over_measurement_db, or inv_amplitude_db.
%
%   THREE METHODS (one shared prior; only smoothing and the sqrt differ)
%   1. SKF (no smoothing)
%      zef_inverse_run(..., "kalman", "execution","local", MethodParams)
%      method_type "Standardized Kalman filter", smoother_type "None"
%      kernel inverse.kf.kf_sL_update (sqrtm).
%   2. SKF (with smoothing)
%      same MethodParams, smoother_type "RTS"
%      RTS reapplies the stored standardization, including alpha.
%      Published equations (13)-(15) instead smooth in the standardized
%      domain with a transformed transition and process noise. This script
%      uses smoother.m, as requested, and does not change that math.
%   3. SKF (diagonalized)
%      Published Section 5.2: a diagonalized standardization step. The full
%      matrix square root of the covariance, O(n^3), is replaced by a
%      diagonal approximation, O(n). The Kalman predict/update stays dense
%      ("dominant complexity is O(n^3) irrespective of whether the diagonal
%      approximation is used"). This is not "Approximated Standardized
%      Kalman filter" (that path is a symmetric eigendecomposition in
%      spd_invsqrt_denman_beavers, still O(n^3), and the paper does not
%      call that diagonalized). It is also not a diagonal-covariance
%      filter: P is predicted and updated as a full matrix.
%      The approximation used here is
%        P^{1/2} ≈ diag(sqrt(diag(P)))
%      inside the same weight construction as kf_sL_update, then
%      inverse.kf.kf_update for the dense measurement update.
%      RTS is off. Section 5.2 does not define diagonalized as a smoother.
%      Fig. B.7(b) peak RAM for this row is 153.3 GB, next to 153.4 GB for
%      SKF with smoothing and 48.3 GB without. That pattern is consistent
%      with the Puhti diagonalized job also storing per-frame covariances.
%      The script does not turn RTS on for this row, so a later full run
%      is not a memory twin of that Puhti row.
%
%   PUHTI TABLE (Fig. B.7(b), transcribed from the published PDF)
%   Caption: CSC Puhti, same dataset and preprocessing, 20 repeats.
%   Core-hours = cores x wall-clock hours. Allocated GB-hours are defined
%   as requested GB x wall-clock hours. Baselines requested 60 GB; SKF runs
%   requested 240 GB.
%   SKF (no smoothing)   10  13:09:14  131.54  48.3 GB  3156.93 GB-h
%   SKF (with smoothing) 10  16:33:29  165.58  153.4 GB 3973.93 GB-h
%   SKF (diagonalized)   10  03:41:20   36.89  153.3 GB  565.2 GB-h
%   240 GB x 3 h 41 min 20 s is about 885 GB-hours. 153.3 GB x that
%   duration is about 565 GB-hours. The PDF cell is 565.2 and is stored
%   as printed. MNE, wMNE, and sLORETA are not run.
%   These columns are Puhti reference values, not measurements from this
%   machine. There is no local 240 GB reservation. alloc_gb_hours_if_request
%   is filled only when the caller passes request_gb.
%
%   HEAD MODEL
%   Not the paper's Brainstorm ICBM152 2023b mesh (published: 2959
%   positions, 72 x 8877, free orientations). This script's full mode uses
%     /Users/hsc476/Documents/ICBM152_Models/FS_WS_SIMPLE_ICBM152_mesh_lead_field_3000.mat
%   72 x 9000, 3000 sources, lead_field_type 1. L is not rebuilt or
%   re-interpolated. The file's source_direction_mode is 2. In the current
%   tree, zef_processLeadfields treats mode 2 as a normal constraint and
%   would overwrite Cartesian columns. Full and smoke runs force mode 1
%   (free orientation, three Cartesian components) so those columns stay.
%   zef_inverse_extract_bundle still reorders blocked [X|Y|Z] columns into
%   interleaved triplets. That is the class path's index map, not a new
%   lead field. Measurements in the file are empty; the series is synthetic.
%   The file's inv_* time, SNR, and band fields are stale. Inspect prints
%   them and the run overrides them.
%   Sampling rate is not stated in the PDF. Full mode uses 20000 Hz and
%   80 frames so that 4 ms is covered and 2*80 copies of a 9000^2 double
%   matrix are about 104 GB, which lines up with the published jump from
%   48.3 GB to about 153 GB if both P and a full D_t are stored per frame
%   (Section 3.3: the RTS smoother stores roughly 2T such matrices). The
%   file's inv_sampling_frequency happens to be 20000 and is not the source
%   of this choice. Smoke mode uses 6 frames and does not load the file.
%   Dipole sites are not given as coordinates. Full mode picks the nearest
%   source to an approximate MNI millimetre guess for the left ventral
%   posterolateral thalamus and the posterior wall of the left central
%   sulcus, after reading the numeric range of source_positions. The
%   superficial orientation is tangential to the vector from the source
%   centroid. The deep orientation is that radial vector; the paper only
%   says the superficial source was kept tangential. Absolute nAm scale is
%   only an axis label; both dipoles use equal unit amplitude before the
%   sensor peak is scaled to 1.
%   Time course: Hann pulses centered at 1.5 ms (deep) and 2.5 ms
%   (superficial), each 2 ms wide, on a 4 ms window (Fig. 6 latencies).
%   The methods prose also says a 2 ms overlap and a 2 ms peak separation
%   inside 4 ms, which cannot all hold for 2 ms-wide pulses. The figure
%   latencies are the ones encoded.
%
%   MODES
%   "smoke" (default) — do not load the project. 8 sensors, 12 states,
%     6 frames, all three variants, write a CSV and small reconstructions.
%   "inspect" — whos/matfile on the project. No inversion, no n-by-n matrix.
%   "full" — load L and run the three variants. The first action, before L
%     is touched, is to error unless AllowFullRun is true. The error
%     reports bytes for one P, for stored RTS histories, and for full D_t.
%   "test" — formula check, smoke, guard, then inspect. Not the 9000-state run.
%
%   out = zef_skf_prasikala_benchmark()
%   out = zef_skf_prasikala_benchmark("mode","smoke")
%   out = zef_skf_prasikala_benchmark("mode","inspect")
%   out = zef_skf_prasikala_benchmark("mode","full","AllowFullRun",true)
%
%   See also zef_inverse_run, inverse.KalmanInverter, inverse.kf.kf_sL_update.

arguments
    opts.mode (1,1) string {mustBeMember(opts.mode, ["inspect","smoke","full","test"])} = "smoke"
    opts.AllowFullRun (1,1) logical = false
    opts.model_file (1,1) string = "/Users/hsc476/Documents/ICBM152_Models/FS_WS_SIMPLE_ICBM152_mesh_lead_field_3000.mat"
    opts.n_repeats (1,1) double {mustBeInteger, mustBePositive} = 1
    opts.request_gb (1,1) double = NaN
    opts.output_dir (1,1) string = ""
    opts.seed (1,1) double {mustBeInteger, mustBeNonnegative} = 110233
    opts.measurement_snr_db (1,1) double = 30
    opts.ep_snr_db (1,1) double = 20
    opts.pm_snr_db (1,1) double = 0
    opts.standardization_exponent (1,1) double {mustBePositive} = 1.25
end

if opts.mode == "full"
    out = i_run_full(opts);
    return
end
if opts.mode == "inspect"
    out = i_run_inspect(opts);
    return
end
if opts.mode == "test"
    out = i_run_tests(opts);
    return
end
out = i_run_smoke(opts);
end

function out = i_run_full(opts)
%i_RUN_FULL  Guard first. L is not opened unless AllowFullRun is true.
est = i_byte_estimate(9000, i_full_frame_count());
if ~isequal(opts.AllowFullRun, true)
    error("skfBenchmark:FullRunNotConfirmed", ...
        ['Full SKF was not started. Pass AllowFullRun=true to run the ' ...
        '72-by-9000 inversion. This error is raised before the lead field ' ...
        'is opened. Estimated bytes at n=9000 and %d frames (4 ms at %g Hz): ' ...
        'P=%d, RTS history (one covariance per frame)=%d, full D_t per frame=%d. ' ...
        'sqrtm temporaries are extra and are not included.'], ...
        est.n_frames, i_full_sampling_hz(), ...
        est.bytes_P, est.bytes_rts_history, est.bytes_D_full);
end

out_dir = i_output_dir(opts, "full");
fprintf("Full-run byte estimate before loading L: P=%d, RTS history=%d, D_t=%d.\n", ...
    est.bytes_P, est.bytes_rts_history, est.bytes_D_full);

project = i_load_project_for_inversion(opts.model_file);
cfg = i_timing_config(opts);
[zef, dipole_log, fs, n_frames] = i_project_to_zef(project, cfg);
out = i_run_variants(zef, cfg, fs, n_frames, opts, out_dir, "full", dipole_log);
out.byte_estimate = est;
end

function out = i_run_inspect(opts)
%i_RUN_INSPECT  Sizes and emptiness only. Does not call the inverter.
info = whos("-file", char(opts.model_file));
names = {info.name};
i_require_var(names, "L");
i_require_var(names, "measurements");
i_require_var(names, "n_sources");
L_size = i_whos_size(info, "L");
mf = matfile(char(opts.model_file));
measurements = mf.measurements;
n_sources = mf.n_sources;
source_positions = i_sources_as_nx3(mf.source_positions);

out = struct();
out.mode = "inspect";
out.model_file = opts.model_file;
out.size_L = L_size;
out.n_sensors = L_size(1);
out.n_state = L_size(2);
out.n_sources = n_sources;
out.measurements_empty = isempty(measurements);
out.source_positions_size = size(mf.source_positions);
out.source_positions_as_nx3 = size(source_positions);
out.position_min = min(source_positions, [], 1);
out.position_max = max(source_positions, [], 1);
out.stale = i_read_stale_fields(mf);
out.inversion_called = false;

fprintf("Inspect %s\n", opts.model_file);
fprintf("size(L) = [%d %d], n_sources = %g, measurements empty = %d\n", ...
    out.n_sensors, out.n_state, out.n_sources, out.measurements_empty);
fprintf("source_positions MATLAB size [%s], range min [%s], max [%s]\n", ...
    sprintf("%g ", size(mf.source_positions)), ...
    sprintf("%g ", out.position_min), sprintf("%g ", out.position_max));
fprintf("Stale project fields (not used as the experiment): inv_snr=%g, inv_sampling_frequency=%g, number_of_frames=%g, source_direction_mode=%g, lead_field_type=%g\n", ...
    out.stale.inv_snr, out.stale.inv_sampling_frequency, out.stale.number_of_frames, ...
    out.stale.source_direction_mode, out.stale.lead_field_type);
fprintf("No reconstruction written. Inverter was not called.\n");

out_dir = i_output_dir(opts, "inspect");
out.output_dir = out_dir;
i_write_text(fullfile(out_dir, "inspect_log.txt"), evalc("disp(out)"));
end

function out = i_run_smoke(opts)
cfg = i_timing_config(opts);
n_sensors = 8;
n_sources = 4;
n_frames = 6;
fs = n_frames / 0.004;
rng(opts.seed, "twister");
positions = [
    0, 0, 0
    40, -20, 50
    -20, 10, 20
    10, 30, -10
    ];
L_blocked = randn(n_sensors, 3 * n_sources);
zef = i_make_zef(L_blocked, zeros(n_sensors, n_frames), positions, fs, n_frames, cfg.measurement_snr_db);
dipole_log = struct( ...
    "deep_index", 1, ...
    "cortical_index", 2, ...
    "deep_orientation", [0; 0; 1], ...
    "cortical_orientation", [0; 1; 0], ...
    "amplitude", [1; 1], ...
    "placement", "smoke indices 1 and 2; not anatomical");
out_dir = i_output_dir(opts, "smoke");
out = i_run_variants(zef, cfg, fs, n_frames, opts, out_dir, "smoke", dipole_log);
end

function out = i_run_variants(zef, cfg, fs, n_frames, opts, out_dir, mode_name, dipole_log)
n_state = size(zef.L, 2);
priors = i_paper_priors(cfg.measurement_snr_db, cfg.pm_snr_db, cfg.ep_snr_db, ...
    n_state, n_frames, 1);
base_params = i_shared_params(priors, n_state, n_frames, fs, cfg);
specs = i_method_specs(base_params);
n_rep = opts.n_repeats;
rows = cell(n_rep * numel(specs), 1);
recon = struct();
row_i = 0;
probe_printed = false;

for repeat_idx = 1:n_rep
    rng(opts.seed, "twister");
    [Y, synth_log] = i_synthesize_measurements(zef, dipole_log, fs, n_frames, ...
        cfg.measurement_snr_db, opts.seed);
    zef.measurements = Y;
    if ~probe_printed
        probe = i_probe_priors(zef, base_params);
        fprintf("theta0 actually kept by initialize: %.16g\n", probe.theta0);
        fprintf("diag(Q) actually kept by initialize: all entries %.16g (min %.16g, max %.16g)\n", ...
            probe.q_var, probe.q_min, probe.q_max);
        probe_printed = true;
        out_probe = probe;
    end
    for spec_idx = 1:numel(specs)
        spec = specs(spec_idx);
        params = spec.params;
        sampler = i_start_rss_sampler();
        cpu0 = cputime;
        wall0 = tic;
        if spec.kernel == "sqrtm"
            [~, run_result] = zef_inverse_run(zef, "kalman", ...
                "execution", "local", "MethodParams", params);
            run_result.kernel = "sqrtm";
        else
            run_result = i_run_diagonalized(zef, params);
        end
        wall_s = toc(wall0);
        cpu_s = cputime - cpu0;
        peak_rss = i_stop_rss_sampler(sampler);
        Z = i_cell_to_matrix(run_result.reconstruction);
        recon.(spec.field) = Z;
        if isfield(run_result, "offdiag_max")
            recon.diagonalized_offdiag_max = run_result.offdiag_max;
        end
        row_i = row_i + 1;
        rows{row_i} = i_result_row(spec, repeat_idx, zef, n_state, n_frames, fs, ...
            cfg, wall_s, cpu_s, peak_rss, opts, mode_name);
    end
    recon.synthetic = synth_log;
end

data_table = struct2table(vertcat(rows{:}));
summary = i_summary_rows(data_table);
full_table = [data_table; summary];
csv_path = fullfile(out_dir, "skf_benchmark.csv");
writetable(full_table, csv_path);
recon_path = fullfile(out_dir, "reconstructions.mat");
save(recon_path, "recon", "-v7");

out = struct();
out.mode = mode_name;
out.output_dir = out_dir;
out.csv_path = csv_path;
out.reconstruction_path = recon_path;
out.table = full_table;
out.theta0 = out_probe.theta0;
out.q_var = out_probe.q_var;
out.q_min = out_probe.q_min;
out.q_max = out_probe.q_max;
out.priors = priors;
out.dipole_log = dipole_log;
out.recon = recon;
if mode_name == "full"
    log_path = fullfile(out_dir, "parameter_log.txt");
    i_write_text(log_path, i_parameter_log_text(out, base_params, cfg));
    out.parameter_log = log_path;
end
fprintf("Wrote %s\n", csv_path);
end

function out = i_run_tests(opts)
% Formula, smoke, guard, then inspect. Never mode "full" with AllowFullRun.
i_test_formula(opts);
smoke_opts = opts;
smoke_opts.mode = "smoke";
smoke_opts.n_repeats = 1;
smoke_opts.output_dir = fullfile(i_project_root(), "profile_results", ...
    "skf_prasikala_benchmark", "test_smoke");
smoke_out = i_run_smoke(smoke_opts);
i_test_smoke(smoke_out);
i_test_guard(opts);
inspect_opts = opts;
inspect_opts.mode = "inspect";
inspect_opts.output_dir = fullfile(i_project_root(), "profile_results", ...
    "skf_prasikala_benchmark", "test_inspect");
inspect_out = i_run_inspect(inspect_opts);
i_test_inspect(inspect_out);
out = struct("formula", "passed", "smoke", smoke_out, "guard", "passed", ...
    "inspect", inspect_out);
fprintf("skf benchmark tests passed.\n");
end

function i_test_formula(opts)
% Hand values: SNR 30, PM 0, EP 20, A 1, N 1, K 4.
% theta_tot = 10^(0/10) = 1
% sigma = 10^(-30/20), sigma^2 = 1e-3
% theta0 = 1 * 1e-3 * 1 / 1 = 1e-3
% kappa^2 = 10^(20/10) = 100
% q = 100 * 1e-3 / 4 = 0.025
priors = i_paper_priors(30, 0, 20, 1, 4, 1);
assert(abs(priors.theta0 - 1e-3) < 1e-15, "theta0 hand check");
assert(abs(priors.q_var - 0.025) < 1e-15, "evolution variance hand check");
assert(abs(priors.sigma2 - 1e-3) < 1e-15, "sigma^2 hand check");

cfg = i_timing_config(opts);
n_state = 6;
n_frames = 4;
priors = i_paper_priors(cfg.measurement_snr_db, cfg.pm_snr_db, cfg.ep_snr_db, ...
    n_state, n_frames, 1);
params = i_shared_params(priors, n_state, n_frames, 1000, cfg);
L = randn(3, n_state);
F = randn(3, n_frames);
inv = i_inverter_from_params(params, n_frames);
inv = inv.initialize(L, F, 3);
assert(isscalar(inv.theta0), "supplied theta0 must stay scalar");
assert(abs(inv.theta0 - priors.theta0) < 1e-12 * max(1, abs(priors.theta0)), ...
    "initialize changed the paper theta0");
q_diag = full(diag(inv.evolution_cov));
assert(max(abs(q_diag - priors.q_var)) < 1e-12 * max(1, abs(priors.q_var)), ...
    "initialize changed diag(Q)");
assert(max(abs(inv.noise_cov - priors.sigma2 * eye(3)), [], "all") < 1e-12, ...
    "R is not sigma^2 I from the peak-SNR");

sens = inverse.KalmanInverter( ...
    "method_type", "Standardized Kalman filter", ...
    "evolution_prior_model", "Sensitivity scaling", ...
    "signal_to_noise_ratio", cfg.measurement_snr_db, ...
    "number_of_frames", n_frames, ...
    "number_of_noise_steps", 1);
sens = sens.initialize(L, F, 3);
assert(numel(sens.theta0) == n_state, "sensitivity theta0 length");
assert(max(abs(sens.theta0(:) - priors.theta0)) > 1e-8, ...
    "sensitivity scaling unexpectedly matched the paper theta0");

P = diag(2 + (1:n_state)');
[m0, y, H, R] = i_small_measurement(n_state);
[m_s, P_s, ~, D_s] = inverse.kf.kf_sL_update(m0, P, y, H, R, cfg.standardization_exponent);
[m_d, P_d, dvec] = i_diag_sqrt_update(m0, P, y, H, R, cfg.standardization_exponent);
assert(norm(m_d - m_s) < 1e-10, "diagonalized step must keep the dense kf update mean");
assert(norm(P_d - P_s, "fro") < 1e-8, "diagonalized step must keep the dense covariance update");
assert(norm((dvec .* m_d) - (D_s * m_s)) < 1e-8, ...
    "on a diagonal P the diagonal square root must match sqrtm");
P_full = randn(n_state);
P_full = P_full * P_full' + eye(n_state);
[m_s2, ~, ~, D_s2] = inverse.kf.kf_sL_update(m0, P_full, y, H, R, cfg.standardization_exponent);
[m_d2, P_d2, dvec2] = i_diag_sqrt_update(m0, P_full, y, H, R, cfg.standardization_exponent);
assert(norm((dvec2 .* m_d2) - (D_s2 * m_s2)) > 1e-6, ...
    "on a full P the diagonal square root must leave sqrtm");
assert(max(abs(P_d2 - diag(diag(P_d2))), [], "all") > 1e-8, ...
    "the diagonalized step must not collapse P to its diagonal");
[~, ~, ~, D_approx] = inverse.kf.kf_sL_update_approx(m0, P_full, y, H, R, cfg.standardization_exponent);
assert(norm((dvec2 .* m_d2) - (D_approx * m_d2)) > 1e-6, ...
    "diagonalized standardization is not the eigendecomposition kernel");
fprintf("Formula check passed. theta0=%.16g, q_var=%.16g\n", priors.theta0, priors.q_var);
end

function i_test_smoke(smoke_out)
on_disk = readtable(smoke_out.csv_path, "TextType", "string");
T = smoke_out.table;
data_rows = T(T.repeat >= 1, :);
assert(height(data_rows) == 3, "smoke CSV must have three data rows");
assert(height(on_disk(on_disk.repeat >= 1, :)) == 3, "CSV file data rows");
assert(exist(smoke_out.csv_path, "file") == 2, "CSV missing");
assert(exist(smoke_out.reconstruction_path, "file") == 2, "reconstructions missing");
names = ["SKF (no smoothing)", "SKF (with smoothing)", "SKF (diagonalized)"];
kernels = ["sqrtm", "sqrtm", "diag_sqrt_standardization"];
smoothers = ["None", "RTS", "None"];
S = load(smoke_out.reconstruction_path, "recon");
fields = ["no_smoothing", "with_smoothing", "diagonalized"];
for k = 1:3
    row = data_rows(data_rows.method == names(k), :);
    assert(height(row) == 1, "missing method row");
    assert(row.kernel == kernels(k), "kernel name");
    assert(row.smoother == smoothers(k), "smoother flag");
    assert(row.peak_rss_bytes > 0 && isfinite(row.peak_rss_bytes), "peak RSS");
    assert(row.wall_clock_s > 0 && isfinite(row.wall_clock_s), "wall clock");
    expected_core = row.n_threads * row.wall_clock_s / 3600;
    assert(abs(row.core_hours - expected_core) <= 1e-9 * max(1, abs(expected_core)), ...
        "core_hours");
    Z = S.recon.(fields(k));
    assert(isequal(size(Z), [12, 6]), "reconstruction size");
    assert(all(isfinite(Z), "all"), "reconstruction finite");
end
Z0 = S.recon.no_smoothing;
Z1 = S.recon.with_smoothing;
Z2 = S.recon.diagonalized;
assert(norm(Z0 - Z1, "fro") > 1e-8, "smoothing changed nothing");
assert(norm(Z0 - Z2, "fro") > 1e-8, "diagonalized matched full sqrtm");
assert(smoke_out.recon.diagonalized_offdiag_max > 1e-8, ...
    "diagonalized run stored a diagonal covariance");
fprintf("Smoke assertions passed. CSV %s\n", smoke_out.csv_path);
end

function i_test_guard(opts)
rss0 = i_process_rss_bytes();
threw = false;
try
    bad = opts;
    bad.mode = "full";
    bad.AllowFullRun = false;
    examples.inverse.zef_skf_prasikala_benchmark( ...
        "mode", "full", ...
        "AllowFullRun", false, ...
        "model_file", opts.model_file, ...
        "n_repeats", 1);
catch ME
    threw = true;
    assert(strcmp(ME.identifier, "skfBenchmark:FullRunNotConfirmed"), ...
        "unexpected guard error: %s", ME.identifier);
    assert(contains(ME.message, "648000000"), "guard omitted the P byte count");
    assert(contains(ME.message, "before the lead field"), "guard message");
end
assert(threw, "full mode without AllowFullRun returned");
rss1 = i_process_rss_bytes();
assert(rss1 - rss0 < 100 * 1024 * 1024, ...
    "guard increased RSS by more than 100 MB (lead field or covariance was opened)");
fprintf("Guard assertions passed.\n");
end

function i_test_inspect(inspect_out)
assert(isequal(inspect_out.size_L, [72, 9000]), "size(L)");
assert(inspect_out.n_sources == 3000, "n_sources");
assert(inspect_out.measurements_empty, "measurements not empty");
assert(~inspect_out.inversion_called, "inspect called the inverter");
fprintf("Inspect assertions passed.\n");
end

function cfg = i_timing_config(opts)
cfg = struct();
cfg.measurement_snr_db = opts.measurement_snr_db;
cfg.ep_snr_db = opts.ep_snr_db;
cfg.pm_snr_db = opts.pm_snr_db;
cfg.standardization_exponent = opts.standardization_exponent;
end

function priors = i_paper_priors(measurement_snr_db, pm_snr_db, ep_snr_db, n_state, n_frames, A)
% Published (20), (21), (25), (26) with dB(u) = 20*log10(|u|).
sigma = A * 10^(-measurement_snr_db / 20);
sigma2 = sigma ^ 2;
theta_tot = 10^(pm_snr_db / 10);
theta0 = theta_tot * sigma2 * (A ^ 2) / n_state;
kappa = 10^(ep_snr_db / 20);
q_var = (kappa ^ 2) * theta0 / n_frames;
priors = struct("sigma", sigma, "sigma2", sigma2, "theta_tot", theta_tot, ...
    "theta0", theta0, "kappa", kappa, "q_var", q_var, "A", A, ...
    "n_state", n_state, "n_frames", n_frames);
end

function params = i_shared_params(priors, n_state, n_frames, fs, cfg)
params = struct();
params.method_type = "Standardized Kalman filter";
params.evolution_prior_model = "User supplied Q";
params.evolution_cov = priors.q_var * speye(n_state);
params.theta0 = priors.theta0;
params.standardization_exponent = cfg.standardization_exponent;
params.signal_to_noise_ratio = cfg.measurement_snr_db;
params.number_of_frames = n_frames;
params.sampling_frequency = fs;
params.number_of_noise_steps = 1;
params.state_transition_model_A = speye(n_state);
params.use_smoothing = false;
params.smoother_type = "None";
end

function specs = i_method_specs(base_params)
none_params = base_params;
none_params.smoother_type = "None";
none_params.use_smoothing = false;
rts_params = base_params;
rts_params.smoother_type = "RTS";
diag_params = base_params;
diag_params.smoother_type = "None";
diag_params.use_smoothing = false;
specs = struct( ...
    "name", {"SKF (no smoothing)", "SKF (with smoothing)", "SKF (diagonalized)"}, ...
    "field", {"no_smoothing", "with_smoothing", "diagonalized"}, ...
    "kernel", {"sqrtm", "sqrtm", "diag_sqrt_standardization"}, ...
    "paper_key", {"no_smoothing", "with_smoothing", "diagonalized"});
specs(1).params = none_params;
specs(2).params = rts_params;
specs(3).params = diag_params;
end

function ref = i_paper_table()
% Printed Fig. B.7(b) cells. Wall-clock seconds are the printed h:m:s.
keys = ["no_smoothing", "with_smoothing", "diagonalized"];
wall = [13 * 3600 + 9 * 60 + 14, 16 * 3600 + 33 * 60 + 29, 3 * 3600 + 41 * 60 + 20];
peak = [48.3, 153.4, 153.3];
cores = [10, 10, 10];
core_h = [131.54, 165.58, 36.89];
alloc = [3156.93, 3973.93, 565.2];
ref = struct("key", {}, "paper_wall_clock_s", {}, "paper_peak_ram_gb", {}, ...
    "paper_cores", {}, "paper_core_hours", {}, "paper_alloc_gb_hours", {});
for k = 1:numel(keys)
    ref(k).key = keys(k); %#ok<AGROW>
    ref(k).paper_wall_clock_s = wall(k);
    ref(k).paper_peak_ram_gb = peak(k);
    ref(k).paper_cores = cores(k);
    ref(k).paper_core_hours = core_h(k);
    ref(k).paper_alloc_gb_hours = alloc(k);
end
end

function pref = i_paper_row(paper_key)
ref = i_paper_table();
match = string({ref.key}) == string(paper_key);
if nnz(match) ~= 1
    error("skfBenchmark:PaperRow", "No unique Puhti row for %s.", string(paper_key));
end
pref = ref(match);
end

function row = i_result_row(spec, repeat_idx, zef, n_state, n_frames, fs, cfg, wall_s, cpu_s, peak_rss, opts, mode_name)
threads = maxNumCompThreads;
wall_h = wall_s / 3600;
if isfinite(opts.request_gb)
    alloc_req = opts.request_gb * wall_h;
else
    alloc_req = NaN;
end
pref = i_paper_row(spec.paper_key);
if mode_name == "smoke"
    model_file = "smoke-synthetic";
else
    model_file = opts.model_file;
end
row = struct();
row.method = string(spec.name);
row.repeat = repeat_idx;
row.n_sensors = size(zef.measurements, 1);
row.n_sources = size(zef.source_positions, 1);
row.n_state = n_state;
row.n_frames = n_frames;
row.sampling_hz = fs;
row.measurement_snr_db = cfg.measurement_snr_db;
row.ep_snr_db = cfg.ep_snr_db;
row.pm_snr_db = cfg.pm_snr_db;
row.standardization_exponent = cfg.standardization_exponent;
row.smoother = string(spec.params.smoother_type);
row.kernel = string(spec.kernel);
row.wall_clock_s = wall_s;
row.cpu_time_s = cpu_s;
row.peak_rss_bytes = peak_rss;
row.n_threads = threads;
row.core_hours = threads * wall_h;
row.alloc_gb_hours_from_peak = (peak_rss / 1e9) * wall_h;
row.alloc_gb_hours_if_request = alloc_req;
row.paper_wall_clock_s = pref.paper_wall_clock_s;
row.paper_peak_ram_gb = pref.paper_peak_ram_gb;
row.paper_cores = pref.paper_cores;
row.paper_core_hours = pref.paper_core_hours;
row.paper_alloc_gb_hours = pref.paper_alloc_gb_hours;
row.seed = opts.seed;
row.model_file = string(model_file);
row.row_kind = "data";
end

function summary = i_summary_rows(data_table)
methods = unique(data_table.method, "stable");
summary = data_table([], :);
for k = 1:numel(methods)
    block = data_table(data_table.method == methods(k), :);
    row = block(1, :);
    row.repeat = NaN;
    row.row_kind = "mean";
    numeric_names = ["wall_clock_s", "cpu_time_s", "peak_rss_bytes", "core_hours", ...
        "alloc_gb_hours_from_peak", "alloc_gb_hours_if_request"];
    for name = numeric_names
        row.(name) = mean(block.(name), "omitnan");
    end
    summary = [summary; row]; %#ok<AGROW>
end
end

function probe = i_probe_priors(zef, params)
bundle = zef_inverse_extract_bundle(zef, "kalman", "MethodParams", params);
inv = i_inverter_from_params(params, bundle.number_of_frames);
inv = inv.initialize(bundle.L, bundle.F, bundle.source_direction_mode);
q_diag = full(diag(inv.evolution_cov));
probe = struct("theta0", inv.theta0, "q_var", q_diag(1), ...
    "q_min", min(q_diag), "q_max", max(q_diag));
end

function run_result = i_run_diagonalized(zef, params)
% Dense predict/update, diagonal square-root standardization, no RTS.
params.smoother_type = "None";
params.use_smoothing = false;
bundle = zef_inverse_extract_bundle(zef, "kalman", "MethodParams", params);
inv = i_inverter_from_params(params, bundle.number_of_frames);
inv = inv.initialize(bundle.L, bundle.F, bundle.source_direction_mode);
L = bundle.L;
n_state = size(L, 2);
if isscalar(inv.theta0)
    inv.prev_step_posterior_cov = eye(n_state) * inv.theta0;
else
    inv.prev_step_posterior_cov = diag(inv.theta0(:));
end
inv.prev_step_reconstruction = zeros(n_state, 1);
n_frames = inv.number_of_frames;
z_inverse = cell(1, n_frames);
offdiag_max = 0;
for f_ind = 1:n_frames
    [m, P] = inverse.kf.class_kf_predict(inv);
    [m, P, dvec] = i_diag_sqrt_update(m, P, bundle.F(:, f_ind), L, ...
        inv.noise_cov, inv.standardization_exponent);
    inv.prev_step_reconstruction = m;
    inv.prev_step_posterior_cov = P;
    z_inverse{f_ind} = dvec .* m;
    offdiag_max = max(offdiag_max, max(abs(P - diag(diag(P))), [], "all"));
end
run_result = struct();
run_result.reconstruction = zef_postProcessInverseClassObj(z_inverse, bundle.procFile);
run_result.kernel = "diag_sqrt_standardization";
run_result.offdiag_max = offdiag_max;
end

function [m, P, dvec] = i_diag_sqrt_update(m, P, y, H, R, standardization_exponent)
% Section 5.2 diagonal approximation of the standardization square root.
% Weights match kf_sL_update with P^{1/2} replaced by diag(sqrt(diag(P))).
% The covariance update is inverse.kf.kf_update (dense P).
pdiag = max(real(diag(P)), realmin);
s = sqrt(pdiag);
B = H .* s.';
G = B' / (B * B' + R);
w_t = 1 ./ (sum(G.' .* B, 1)').^standardization_exponent;
dvec = w_t ./ s;
[m, P] = inverse.kf.kf_update(m, P, y, H, R);
end

function inv = i_inverter_from_params(params, n_frames)
inv = inverse.KalmanInverter( ...
    "method_type", params.method_type, ...
    "evolution_prior_model", params.evolution_prior_model, ...
    "evolution_cov", params.evolution_cov, ...
    "theta0", params.theta0, ...
    "standardization_exponent", params.standardization_exponent, ...
    "signal_to_noise_ratio", params.signal_to_noise_ratio, ...
    "number_of_frames", n_frames, ...
    "sampling_frequency", params.sampling_frequency, ...
    "number_of_noise_steps", params.number_of_noise_steps, ...
    "state_transition_model_A", params.state_transition_model_A, ...
    "smoother_type", params.smoother_type);
end

function [m0, y, H, R] = i_small_measurement(n_state)
m0 = zeros(n_state, 1);
H = randn(3, n_state);
y = randn(3, 1);
R = 0.05 * eye(3);
end

function [Y, log_s] = i_synthesize_measurements(zef, dipole_log, fs, n_frames, measurement_snr_db, seed)
bundle = zef_inverse_extract_bundle(zef, "kalman", "MethodParams", struct());
L = bundle.L;
t = (0:n_frames - 1).' / fs;
deep = i_hann_pulse(t, 0.0015, 0.002);
cortical = i_hann_pulse(t, 0.0025, 0.002);
n_state = size(L, 2);
X = zeros(n_state, n_frames);
deep_cols = (3 * dipole_log.deep_index - 2):(3 * dipole_log.deep_index);
cort_cols = (3 * dipole_log.cortical_index - 2):(3 * dipole_log.cortical_index);
X(deep_cols, :) = dipole_log.deep_orientation * (dipole_log.amplitude(1) * deep.');
X(cort_cols, :) = dipole_log.cortical_orientation * (dipole_log.amplitude(2) * cortical.');
Y_clean = L * X;
peak = max(abs(Y_clean), [], "all");
if peak == 0
    error("skfBenchmark:SilentLeadField", "Clean measurements are identically zero.");
end
Y_clean = Y_clean / peak;
sigma = 10^(-measurement_snr_db / 20);
rng(seed, "twister");
Y = Y_clean + sigma * randn(size(Y_clean));
log_s = struct("deep_index", dipole_log.deep_index, ...
    "cortical_index", dipole_log.cortical_index, ...
    "deep_orientation", dipole_log.deep_orientation, ...
    "cortical_orientation", dipole_log.cortical_orientation, ...
    "amplitude_before_sensor_scaling", dipole_log.amplitude, ...
    "clean_peak_before_scaling", peak, ...
    "A", 1, "sigma", sigma, "sampling_hz", fs, "n_frames", n_frames, ...
    "seed", seed, "placement", dipole_log.placement);
end

function a = i_hann_pulse(t, center, width)
u = (t - (center - width / 2)) / width;
a = zeros(size(t));
on = u >= 0 & u <= 1;
a(on) = 0.5 * (1 - cos(2 * pi * u(on)));
end

function zef = i_make_zef(L_blocked, measurements, positions, fs, n_frames, measurement_snr_db)
n_sources = size(positions, 1);
zef = struct();
zef.L = L_blocked;
zef.measurements = measurements;
zef.source_positions = positions;
zef.source_directions = zeros(n_sources, 3);
zef.source_direction_mode = 1;
zef.source_interpolation_ind = {(1:n_sources)', [], []};
zef.inv_data_mode = "raw";
zef.inv_low_cut_frequency = 0;
zef.inv_high_cut_frequency = 0;
zef.normalize_data = 1;
zef.number_of_frames = n_frames;
zef.inv_sampling_frequency = fs;
zef.inv_time_1 = 0;
zef.inv_time_2 = 0.004;
zef.inv_time_3 = 1 / fs;
zef.inv_snr = measurement_snr_db;
zef.use_gpu = false;
zef.gpu_count = 0;
zef.inv_time_interval_averaging = false;
end

function [zef, dipole_log, fs, n_frames] = i_project_to_zef(project, cfg)
fs = i_full_sampling_hz();
n_frames = i_full_frame_count();
positions = i_sources_as_nx3(project.source_positions);
L = project.L;
if size(L, 1) ~= 72 || size(L, 2) ~= 3 * size(positions, 1)
    error("skfBenchmark:UnexpectedLeadField", ...
        "Expected 72-by-(3*n_sources) L; got %s with %d positions.", ...
        mat2str(size(L)), size(positions, 1));
end
zef = i_make_zef(L, zeros(size(L, 1), n_frames), positions, fs, n_frames, ...
    cfg.measurement_snr_db);
if isfield(project, "source_interpolation_ind") && ~isempty(project.source_interpolation_ind)
    zef.source_interpolation_ind = project.source_interpolation_ind;
end
dipole_log = i_place_dipoles(positions);
fprintf("File source_direction_mode=%g forced to 1 so Cartesian columns are kept.\n", ...
    project.source_direction_mode);
fprintf("Stale fields overridden: inv_snr=%g, inv_sampling_frequency=%g, number_of_frames=%g, inv_time_2=%g\n", ...
    project.inv_snr, project.inv_sampling_frequency, project.number_of_frames, project.inv_time_2);
end

function dipole_log = i_place_dipoles(positions_nx3)
% Approximate MNI millimetres. Not printed as coordinates in the PDF.
span = max(abs(positions_nx3), [], "all");
if span < 5
    pos_mm = positions_nx3 * 1000;
    unit_note = "coordinates looked like metres and were scaled by 1000 for the search";
else
    pos_mm = positions_nx3;
    unit_note = "coordinates treated as millimetres";
end
targets_mm = [
    -16, -20, 6
    -40, -22, 52
    ];
target_names = ["left VPL thalamus (approximate MNI)", ...
    "posterior wall of the left central sulcus (approximate MNI)"];
idx = zeros(2, 1);
dist_mm = zeros(2, 1);
for k = 1:2
    delta = pos_mm - targets_mm(k, :);
    [dist_mm(k), idx(k)] = min(sum(delta.^2, 2));
    dist_mm(k) = sqrt(dist_mm(k));
end
centroid = mean(pos_mm, 1);
radial = zeros(2, 3);
tangential = zeros(2, 3);
for k = 1:2
    v = pos_mm(idx(k), :) - centroid;
    if norm(v) == 0
        v = [0, 0, 1];
    end
    radial(k, :) = v / norm(v);
    tvec = cross(radial(k, :), [0, 0, 1]);
    if norm(tvec) < 1e-8
        tvec = cross(radial(k, :), [0, 1, 0]);
    end
    tangential(k, :) = tvec / norm(tvec);
end
dipole_log = struct();
dipole_log.deep_index = idx(1);
dipole_log.cortical_index = idx(2);
dipole_log.deep_orientation = radial(1, :).';
dipole_log.cortical_orientation = tangential(2, :).';
dipole_log.amplitude = [1; 1];
dipole_log.placement = struct( ...
    "unit_note", unit_note, ...
    "target_names", target_names, ...
    "target_mm", targets_mm, ...
    "chosen_mm", pos_mm(idx, :), ...
    "distance_mm", dist_mm, ...
    "deep_orientation_note", "radial from the source centroid; deep orientation is not stated in the PDF", ...
    "cortical_orientation_note", "tangential, cross(radial, z-hat)");
end

function project = i_load_project_for_inversion(model_file)
% Lead field and source geometry only. Compartment meshes are not required
% once source_direction_mode is forced to 1.
wanted = {"L", "source_positions", "source_interpolation_ind", ...
    "source_direction_mode", "n_sources", "lead_field_type", ...
    "measurements", "inv_snr", "inv_sampling_frequency", "number_of_frames", ...
    "inv_time_1", "inv_time_2", "inv_time_3", "inv_prior_over_measurement_db", ...
    "inv_amplitude_db"};
present = {whos("-file", char(model_file)).name};
use = wanted(ismember(wanted, present));
project = load(char(model_file), use{:});
end

function stale = i_read_stale_fields(mf)
stale = struct();
stale.inv_snr = i_scalar_or_nan(mf, "inv_snr");
stale.inv_sampling_frequency = i_scalar_or_nan(mf, "inv_sampling_frequency");
stale.number_of_frames = i_scalar_or_nan(mf, "number_of_frames");
stale.inv_time_1 = i_scalar_or_nan(mf, "inv_time_1");
stale.inv_time_2 = i_scalar_or_nan(mf, "inv_time_2");
stale.inv_time_3 = i_scalar_or_nan(mf, "inv_time_3");
stale.inv_prior_over_measurement_db = i_scalar_or_nan(mf, "inv_prior_over_measurement_db");
stale.inv_amplitude_db = i_scalar_or_nan(mf, "inv_amplitude_db");
stale.source_direction_mode = i_scalar_or_nan(mf, "source_direction_mode");
stale.lead_field_type = i_scalar_or_nan(mf, "lead_field_type");
end

function value = i_scalar_or_nan(mf, name)
try
    value = mf.(name);
    value = value(1);
catch
    value = NaN;
end
end

function est = i_byte_estimate(n_state, n_frames)
est = struct();
est.n_state = n_state;
est.n_frames = n_frames;
est.bytes_P = n_state * n_state * 8;
est.bytes_rts_history = n_frames * est.bytes_P;
est.bytes_D_full = n_frames * est.bytes_P;
est.bytes_D_diag = n_frames * n_state * 8;
end

function n_frames = i_full_frame_count()
n_frames = round(0.004 * i_full_sampling_hz());
end

function fs = i_full_sampling_hz()
fs = 20000;
end

function Z = i_cell_to_matrix(z)
if iscell(z)
    Z = zeros(numel(z{1}), numel(z));
    for k = 1:numel(z)
        Z(:, k) = z{k}(:);
    end
else
    Z = z;
end
end

function sp = i_sources_as_nx3(sp)
if size(sp, 2) == 3
    return
end
if size(sp, 1) == 3
    sp = sp.';
    return
end
error("skfBenchmark:BadSourcePositions", ...
    "source_positions must be n-by-3 or 3-by-n; got %s.", mat2str(size(sp)));
end

function sampler = i_start_rss_sampler()
pid = feature("getpid");
tag = tempname;
sampler.outfile = tag + "_rss.txt";
sampler.stopfile = tag + "_rss.stop";
sampler.pidfile = tag + "_rss.pid";
fmt = ['bash -c ''while [ ! -f "%s" ]; do ps -o rss= -p %d; sleep 0.02; done > "%s" & echo $! > "%s"'''];
cmd = sprintf(fmt, sampler.stopfile, pid, sampler.outfile, sampler.pidfile);
[status, message] = system(cmd);
sampler.ok = status == 0;
if ~sampler.ok
    warning("skfBenchmark:RssSampler", "RSS sampler did not start: %s", message);
end
end

function peak_bytes = i_stop_rss_sampler(sampler)
fclose(fopen(sampler.stopfile, "w"));
pause(0.05);
if isfile(sampler.pidfile)
    poller = str2double(strtrim(fileread(sampler.pidfile)));
    if isfinite(poller)
        system(sprintf("kill %d >/dev/null 2>&1", poller));
    end
end
peak_kb = 0;
if isfile(sampler.outfile)
    values = sscanf(fileread(sampler.outfile), "%f");
    if ~isempty(values)
        peak_kb = max(values);
    end
end
fallback = i_process_rss_bytes() / 1024;
peak_kb = max(peak_kb, fallback);
peak_bytes = peak_kb * 1024;
end

function bytes = i_process_rss_bytes()
pid = feature("getpid");
[status, message] = system(sprintf("ps -o rss= -p %d", pid));
if status ~= 0
    bytes = NaN;
    return
end
kb = sscanf(message, "%f");
if isempty(kb)
    bytes = NaN;
else
    bytes = kb(1) * 1024;
end
end

function out_dir = i_output_dir(opts, mode_name)
if strlength(opts.output_dir) > 0
    out_dir = opts.output_dir;
else
    out_dir = fullfile(i_project_root(), "profile_results", ...
        "skf_prasikala_benchmark", char(mode_name));
end
if ~isfolder(out_dir)
    mkdir(out_dir);
end
end

function root = i_project_root()
here = fileparts(mfilename("fullpath"));
root = fileparts(fileparts(here));
end

function i_require_var(names, name)
if ~any(strcmp(names, name))
    error("skfBenchmark:MissingVariable", "Project file has no variable %s.", name);
end
end

function sz = i_whos_size(info, name)
idx = find(strcmp({info.name}, name), 1);
sz = info(idx).size;
end

function i_write_text(path, text)
fid = fopen(path, "w");
if fid < 0
    error("skfBenchmark:LogWrite", "Could not write %s.", path);
end
cleaner = onCleanup(@() fclose(fid));
fwrite(fid, text);
end

function text = i_parameter_log_text(out, params, cfg)
text = sprintf([ ...
    'theta0=%.16g\nQdiag=%.16g (min %.16g max %.16g)\n' ...
    'measurement_snr_db=%.16g ep_snr_db=%.16g pm_snr_db=%.16g alpha=%.16g\n' ...
    'method_type=%s evolution_prior_model=%s smoother_base=%s\n' ...
    'These four numbers are stated in published Appendix B for the SKF in Fig. B.7.\n' ...
    'Sampling frequency 20000 Hz is inferred, not printed in the PDF.\n' ...
    'N in theta0 is the state dimension.\n' ...
    'dB is 20*log10. Deep orientation is an assumption.\n'], ...
    out.theta0, out.q_var, out.q_min, out.q_max, ...
    cfg.measurement_snr_db, cfg.ep_snr_db, cfg.pm_snr_db, cfg.standardization_exponent, ...
    params.method_type, params.evolution_prior_model, params.smoother_type);
end
