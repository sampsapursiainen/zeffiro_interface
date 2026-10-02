# `tests.unit` — kernel and chrome unit tests

## Folder purpose

MATLAB class-based unit tests for **isolated** inverse kernels, source-model types, and a few GUI chrome primitives. These tests do not start a full Zeffiro session, do not require a real head mesh, and do not go through HPC `parcluster`. They construct small synthetic `L` / measurements (or real `uifigure` widgets) and assert numerical or API contracts.

Fully qualified names are `tests.unit.<ClassName>`. Parent map: [`../README.md`](../README.md).

## Main contents

### Inverse kernels (`+inverse`)

| Class | What it actually checks |
|-------|-------------------------|
| `ELORETAInverterTest` | `inverse.ELORETAInverter` on `zef_processLeadfields` output: `numel(z)==size(L,2)`, finite fixed-point `T`, recovering a column of `L`, explicit `alpha` kept, scale stability |
| `ELORETAInverterOptTest` | Block-page `precompute` vs the dense `W^{-1}` loop (average-reference on/off, mixed/all fixed orientation) |
| `CSMInverterSLoretaTest` | `method_type` `"sLORETA"` vs `d .* (P*f)/sqrt(theta0)`; `"sLORETA 3D"` vs per-source `sqrtm` loop; local `zef_inverse_run` smoke |
| `DipoleScanMNEOptTest` | Dipole Scan `pagesvd` vs SVD loop; mixed/fixed orientation; MNE `W*f` vs plugin-style kernel; dispatch smoke |
| `BeamformerInverterOptTest` | Cached `B*f` vs per-source loop across LCMV / UNG / unit-gain × regularization × column-norm settings; LCMV recovers an exact noiseless source when \(C=I\); missing `error_cov` errors |
| `InverseScientificIdentityTest` | Dipole-scan GoF \(=1\) at a known source; eLORETA \(W_i^{-1}=(L_i^\top M^{-1}L_i)^{-1/2}\); Kalman identity-\(A\) test, mixed-diagonal predict, constant-state tracking, class RTS |
| `DownloaderSafetyTest` | Structural: source still quotes git args and uses `onCleanup`. Behavioral: non-URL remotes error `InvalidGitAddress` |
| `StiffnessMatrixIdentityTest` | P1 stiffness on the unit tet matches \(\nabla\lambda_i\cdot(\sigma\nabla\lambda_j)V\); anisotropic \(\sigma_{xy}/\sigma_{xz}/\sigma_{yz}\) and a random SPD tensor; two-tet assembly |
| `ProjectLoadLegacyTest` | Single-struct MAT files are not overwritten; non-struct singles error; `zef_remove_system_fields` drops `gpu_count` / `path_cell` and keeps `save_file` |
| `ProjectSaveExportTest` | Headless lead-field export, handle stripping, save/load round-trip of `L` |
| `Duneuro2ZefTest` | DUNEuro `eegL` layouts → interleaved `zef.L`; 0-based tets; hex split; mm/m; tensors; extra fields; unsupported inputs; converted MAT is not re-detected as DUNEuro; `run` matches `convert`; `find_files` size priority; export-folder detection |
| `BuildElectrodesCEMTest` | P1 CEM `A,B,C` vs analytic triangle mass; two-triangle \(C_{ee}=1/Z\); infinite-\(Z\) early return; point fallback |
| `DTIActiveCompartmentMapTest` | Active-compartment map skips off tags; iso fallback uses that map, not tag position |
| `FAToConductivityOrientationTest` | Model-3 FA→σ principal axis follows `v1`; missing `v1` defaults to \(+\hat x\) |
| `Pem2cemParityTest` | Triangle CEM rows copied; point rows expand; buried 4-row barycentric errors |
| `EITPEMNotSupportedTest` | 3-column EIT electrodes error `PEMNotSupported` |
| `ElectrodeImportColumnOrderTest` | CSV/DAT CEM output is `[outer inner Z]`; attach annulus is non-empty |
| `RapMusicScanTest` | RAP-MUSIC recovers two known dipoles with distinct orientations; mode-3 scalar columns; `zef_blocked_source_index` is `n_interp` rows, not `n_interp/3` |
| `LeadfieldColumnEnergyTest` | Mode 1/2 triplet energy; mode 3 is not `reshape(...,3,[])`; Kalman `T=1` and `number_of_noise_steps` cap |
| `DropNanSourceColumnsTest` | Interleaved NaN y-column drops the whole xyz triplet |
| `IASInverterOptTest` | IAS `invert` vs legacy `W = d.*(W'*inv(A))`; `d_sqrt = sqrt(θ)` (prior std, not variance) |
| `RAMUSInverterOptTest` | Same kernel comparison on `inverse.RAMUSInverter` with synthetic multires `dec` / `ind` / `cnt` lattices |
| `KalmanApproxRtsStandardizationTest` | Scaled Denman–Beavers `P^{-1/2}`; approx RTS multiplies `Z*m` |
| `MegCartesianInterpolationGuardTest` | `zef_require_meg_cartesian_interpolation` allows Whitney/H(div) and errors on St. Venant; structural check that MEG FEM files call the guard |
| `EegFaceBasedDirectionModeTest` | EEG `face_based` / default `mesh based` throw `UnsupportedDirectionMode` before assembling `L` |
| `SessionWantsGpuTest` | `zef_session_wants_gpu` on the session argument; structural check that MEG/EIT FEM do not `evalin('base','zef.gpu_count')` |
| `LeadFieldSensorsAuxTest` | Types 1–10 PEM `/1000`, MEG xyz `/1000`, CEM unscaled; anisotropic MEG refuses EEG table |
| `PemReferenceLoadTest` | Infinite-Z PEM zeros electrode 1 only inside a PCG block |
| `EITGradientProductTest` | `D_A` matches `∫∇ψ_i·∇ψ_j`; inherited off-diagonal junk is not present |
| `DTITensorRotationTest` | Row-vector affine conversion; `RσR'`; interpolator 90° axis; blocked `kron(I,Q)` |
| `GravityNewtonKernelTest` | Newtonian \(1/r\), \(r/r^3\), \(n\cdot g\), \(\partial_n g\); inherited component-power kernels disagree |
| `DTIResolveMesh2VoxelTest` | `register.dat` without orig.mgz errors; NIfTI-only returns empty |
| `MCMCPosteriorMeanDivisorTest` | Post-burn-in mean is \((n_{\mathrm{iter}}-n_{\mathrm{burn}})n_{\mathrm{chains}}\) |
| `KalmanRtsStoredDTest` | RTS applies stored filter \(D_t\); exponent 1 vs 1/2 differs |
| `ImportConfinedScriptTest` | `.zef` script rows `run` only under the import folder |
| `HALpRInverterTest` | `L1_optimization` vs sparse-D reference (IAS and Standardized); q=1/q=2 invert; q=2 zero-frame and polarity; `halpr` local dispatch |
| `GroupLassoInverterTest` | `LG_optimization` vs sparse-D reference (IAS / EM / Standardized); invert vs frozen MAP loop; non-triplet `L` errors; `grouplasso` local dispatch |
| `UKFNMMInverterTest` | Construct, U-space→dipole map, van der Merwe defaults, `initialize` sizes, per-frame `invert`, smoother NMM **once**, RTS |
| `SesameInversionSetupTest` | Headless `SESAME_inversion` with a stub sampler: unique interpolation indices subset sources; writes `zef.SESAME` |
| `ClassGMMOptTest` | Mahalanobis / E-step / weighted EM of `inverse.gmm` vs original formulas; package isolation from retired `plugins.ClassGMM` |
| `KalmanStandardizationExponentTest` | Class Kalman sLORETA exponent default 1/2 vs legacy `zef.standardization_exponent` (default 1); bitwise match when the exponent is aligned |
| `MNEDepthWeightingTest` | Class MNE `theta` stays a per-source Dale/Lin vector, not `mean(theta)` |
| `RAMUSAggregationTest` | Empty-dec error id; RAMUS-only `method_type` `"sLORETA each step"` |
| `PrecomputeCacheKeyTest` | CSM / MNE / eLORETA / Beamformer / DipoleScan cached operators invalidate when `L` or settings change |

### Mesh, FEM interpolation, lead-field kernels

| Class | What it actually checks |
|-------|-------------------------|
| `CreateFemMeshStencilTest` | `zef_lattice_cubes_to_tetra` vs the upstream i_x/i_y/i_z loop (5-tet and 6-tet stencils, parity diagonals) |
| `FiDipolesFacePairingTest` | `zef_fi_shared_faces` vs upstream `sortrows`; `zef_fi_dipoles` pair count |
| `MeshRefinementEdgeIndexTest` | `zef_mid_edge_node_index` vs the upstream sequential loop |
| `NearestNeighbourGroupTest` | `zef_nearest_neighbour_groups` vs `find(p_nn==i)` in H(div)/Whitney interpolation |
| `MEGGradiometerDistanceLawTest` | Gradiometer load uses \(\|r_{\mathrm{sensor}}-r_{\mathrm{centroid}}\|^{-3}\), not the overwritten directional vector |
| `MEGLoadVectorVectorizationTest` | Magnetometer/gradiometer `accumarray` nodal load vs the upstream tetra loop |
| `TesDofAveragingTest` | `zef_average_tes_dof_current` vs the scatter loops |
| `VolumeScalarMatrixUFGTest` | NSE `uFG` convection kernel vs a dense triple-loop oracle (`zef_barycentric_weighting` `'uFG'`) |
| `AnisotropicConductivityGuardTest` | Lead-field types 6–10 error unless `sigma(:,3:8)` is present |
| `ProcessMeshesPipelineTest` | Cube surface translation via `zef_process_meshes`; `zef_create_fem_mesh` fills labeled tets (modes 1 and 2) |
| `EegLeadFieldAssemblyTest` | PEM Whitney EEG FEM on a cube lattice: finite `L`, 2×6, mean-zero columns |
| `MegLeadFieldAssemblyTest` | Magnetometer Whitney MEG FEM on a cube lattice: finite `L`; cartesian occupancy may drop sources (`size(L,2)` is a multiple of 3, not necessarily `3*n_source`) |
| `EitLeadFieldAssemblyTest` | CEM EIT FEM on a cube lattice: finite Jacobian from a bipolar `current_pattern`; uint32 CEM face ids; type-1 DOF decomposition |
| `EnsureParpoolTest` | Structural: CPU meshing / MEG / EIT / transfer / wave Born source contains `zef_ensure_parpool` and those FEM files do not call `gcp`/`parpool` directly. Behavioral: helper returns logical and is a no-op without PCT; existing matching pool is reused |

### Types and chrome

| Class | What it actually checks |
|-------|-------------------------|
| `ZefSourceModelLoadTest` | `core.types.ZefSourceModel.from` on names, integers, `core.ZefSourceModel`, structs; saved legacy enum `.mat` loads without warning |
| `ParcellationColormapTest` | `zef_parcellation_colormap` returns `[]` when base `zef.parcellation_colormap` is missing, else the stored matrix |
| `WaitbarTest` | `zef_waitbar` lifecycle on R2025a+: `0` is progress not `groot`; nested `(i,N,h,msg)` keeps one handle; nested initialize+close (including stiffness/adjacency/source_tetra and double-close) does not invalidate the parent; `zef_close_waitbar` ignores stale handles; teardown restores `WindowStyle` |
| `ColoredListTest` | `zef_colored_list` HTML / `uihtml` (and table) backends: names, colors, selection |
| `UiIconsTest` | `zef_ui_icons` rasterizes every `assets/fig/ui/*.svg`; folder has no PNGs; gizmo keeps RGB axes; missing names return empty |
| `UiThemeTest` | Canonical light `zef_ui_theme` tokens (font ≥ 11 px, teal accent, shell geometry), no Theme control, rounded-card chrome without pushbutton bezels, Figure workspace rounded via `zef_ui_card` (no corner overlays), window-label stripping, layout resize on real figures, nav hover fills the entire row with one rounded `zef_ui_roundrect` chip (icon and label share the row's top/bottom; no hit-target `CData`) |
| `ClassInverseDialogTest` | Class-solver dialogs expose method tags (`zef_inv_*`); `noise_cov` absent on eLORETA; class-solver `zef_*_start` names resolve |
| `FigureViewContainmentTest` | Figure-tool axes stay inside the visualization slot after layout |
| `FigureToolControllersTest` | Live camera / measure / annotate controllers; mutually exclusive modes; toolbar callbacks |
| `ProfileCellTest` | `zef_read_profile_cell` matches `readcell` on shipped INIs; quoted fields; cache invalidation |
| `GuiResponsivenessTest` | Resize must not install listener storms or recenter the window |
| `WindowPlacementTest` | Clamp / centre helpers keep windows on the work area |
| `SensorListSyncTest` | Figure-tool sensor count matches listed rows |
| `RgbRowTest` | Figure-tool update evals text compartment colors such as `0.5000 0 1.0000` into a 1-by-3 row |
| `SensorTableSyncTest` | Sensors table edits zef only after it was built from zef. Open/remesh does not rename a set or drop a real visibility choice. Mesh widgets display zef and do not replace it. The shipped head project is canonicalized once (electrodes shown, list `Electrode N`, figure text `N`). A later hide of the set or of every contact is kept. |
| `PluginIniResolutionTest` | Every Start function named in `profile/*/zeffiro_plugins.ini` exists on the path |

## Code functionality

Typical inverse test:

1. Seed RNG in `TestMethodSetup`.
2. Build `L`, `F`, `procFile`, source positions either via `tests.support.createSyntheticInverseZef` + `zef_processLeadfields`, or a local `i_synth` helper (mode-1 Cartesian, 3 columns per source).
3. Construct `inverse.*Inverter`, call `initialize` → optional `precompute` → `invert`.
4. Compare against an in-file reference loop, or against a second inverter configured to the old algorithm.
5. Close waitbars in `TestMethodTeardown` where the kernel opens one.

HALpR / GroupLasso call `L1_optimization` / `LG_optimization` from `src/inverse` (on `genpath(src)` after `zeffiro_interface`).

Chrome tests create **real** `figure` / `uifigure` windows (`Visible` often `'off'`), track them in a `Figures` property, and delete them in teardown. `WaitbarTest` and `UiThemeTest` also snapshot `groot` `defaultFigureWindowStyle` because `zef_window_manager('init')` sets it to `'normal'`.

## Workflow context

```
tests.support.createSyntheticInverseZef
        ↓
  inverse.*Inverter / inverse.gmm / core.types / src/gui/chrome
        ↓
  assertions (shape, finite, 1e-12 vs reference, error id)
```

Dispatch smoke inside a unit class (`zef_inverse_run(..., 'execution', 'local')`) still uses the class track (`src/inverse` → `utilities.cluster.dispatch_inverse`). Full registry / cluster / class-vs-legacy coverage lives in [`../+integration/README.md`](../+integration/README.md). End-to-end and layout guards: [`../+smoke/README.md`](../+smoke/README.md).

## Usage instructions

Project root must be on the path. Do **not** `addpath('+tests')`.

```matlab
cd /path/to/zeffiro_interface
zef = zeffiro_interface('start_mode','nodisplay');  % path + plugins (EXP)
runtests('tests.unit.ELORETAInverterTest')
runtests('+tests/+unit')
```

## Important notes

- Synthetic `L` is random (seeded). These tests protect **implementation opts and API contracts**, not localization accuracy on a real head.
- `ClassVsLegacyTest` is **not** here — it is an integration test and does not assert numerical equality.
- `ParcellationColormapTest` mutates base-workspace `zef` and restores it; do not run it in parallel with a live GUI session that owns that variable.
- GPU branches in `UKFNMMInverterTest` fall back or skip when no GPU is present; they are not a CUDA validation suite.
- `ClassInverseDialogTest` and `PluginIniResolutionTest` need `zeffiro_interface` path setup so `plugins/ELORETA` (and siblings) are on the path. The dialog test mutates base-workspace `zef` and restores it.

## Developer guidance

- New `@*Inverter` kernel change: add or extend a class here that compares against a frozen reference loop (see `IASInverterOptTest` / `ELORETAInverterOptTest`).
- New registry id: also add an integration dispatch test; a unit invert smoke is not enough.
- Prefer `tests.support.createSyntheticInverseZef` when the test needs a full `zef` struct. Use a local `i_synth` when you only need `L`/`F`/`procFile`.
- Pitfall: `addpath('+tests/+unit')` breaks `tests.unit.*` resolution. Add the repository root only.
- Keep teardown deleting figures and waitbars; leftover `uifigure`s poison later chrome tests.
