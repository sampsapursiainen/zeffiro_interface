# Getting started

This walk-through assumes you can start MATLAB and that this repository is on disk. You do not need to know EEG or finite elements yet. The goal is one successful session: import anatomy, build a mesh, optionally assemble a lead field.

If something fails, see [troubleshooting.md](troubleshooting.md). Words such as lead field and compartment are defined in [glossary.md](glossary.md).

## What you are about to compute

The brain generates tiny electrical currents. EEG electrodes on the scalp (or MEG coils outside the head) record the fields those currents produce. Reconstructing *where* the currents were is an **inverse problem**: many source patterns can explain the same sensor traces.

Zeffiro approaches that in two stages.

1. **Forward.** Fill a segmented head with tetrahedra, assign each tissue a conductivity, and compute a **lead field** `zef.L`: a matrix that says “if a unit source sat here, what would the sensors see?” That step is a finite-element solve. It is the expensive one.
2. **Inverse.** Given measurements `y` and `L`, pick one source vector `x` such that `y ≈ L x`. Extra rules (regularization, Bayesian priors, Kalman process noise) choose among the many `x` that fit.

This page stops after a mesh, and optionally after `L`. Inverse methods are introduced in [methods.md](methods.md).

## 1. Prerequisites

- MATLAB **R2023a** or newer. `arguments` blocks, App Designer `uifigure` and `string` only need R2021a, but the batched linear algebra in the inverse precompute paths raises the real floor: `pagesvd` needs R2021b and `pageeig` (Beamformer, eLORETA, and sLORETA 3D precompute) needs R2023a.
- Optional GPU: Parallel Computing Toolbox plus a CUDA device. Without those, pass `'use_gpu', false` everywhere below. The same toolbox is optional for CPU `parfor` (meshing, MEG/EIT transfer). Without it those loops still run, sequentially.
- Optional Statistics Toolbox: GMM clustering and the UKFNMM class (`kmeans`).
- Git, only if you want CVX / FieldTrip / other trees under `external/`.

You do **not** need to populate `external/` for meshing, EEG lead fields, or the class inverse solvers in `+inverse`.

## 2. Clone and open MATLAB in the project root

```bash
git clone https://github.com/sampsapursiainen/zeffiro_interface.git
cd zeffiro_interface
```

The folder name on disk can differ from the GitHub repository name. What matters is that MATLAB’s current directory is the folder that contains `zeffiro_interface.m`.

If you prefer to clone from inside MATLAB into an empty parent folder:

```matlab
zeffiro_downloader('install_directory', pwd, 'run_setup', true)
cd('zeffiro_interface')   % default folder_name
```

`zeffiro_downloader` is a shallow clone for a **new** install. It is not a git-pull updater.

Optional submodules (CVX, FieldTrip, …):

```matlab
zeffiro_setup('submodules', "all")   % or a single name from .gitmodules
```

`zeffiro_interface` calls `zeffiro_setup` itself. If you have no git submodules to clone, that still writes `src/app/zef_start_config.m`. If the tree is read-only, setup cannot write that file and start will error.

## 3. First launch (GUI)

In MATLAB:

```matlab
cd('/path/to/zeffiro_interface')   % folder that contains zeffiro_interface.m
zef = zeffiro_interface;
```

You should see the unified Figure-tool window (3-D axes), plus Mesh tool and Mesh visualization. The Menu tool figure stays hidden; its menus are reached from the left navigation.

If MATLAB says `zef` already exists, either:

```matlab
zef_close_all
clear zef
zef = zeffiro_interface;
```

or force a restart:

```matlab
zef = zeffiro_interface('zeffiro_restart', true);
```

Fresh clones often **do not** contain `data/default_project.mat`. Startup then opens empty tools. That is normal.

## 4. Load the bundled head segmentation

The demo anatomy is a set of FreeSurfer-style `.asc` surfaces plus a manifest:

`data/segmentations/multicompartment_head_project/import_segmentation.zef`

**GUI:** **Import → Import data to a new project** and pick that `.zef` file.

**Script** (clears compartments first):

```matlab
zef = zeffiro_interface('start_mode', 'nodisplay', ...
    'import_to_new_project', fullfile(pwd, 'data', 'segmentations', ...
    'multicompartment_head_project', 'import_segmentation.zef'), ...
    'use_gpu', false);
```

There is also `examples.importing.zef_import_example`, which uses `import_to_existing_project` and a **cwd-relative** path. Run it from the repository root. If `default_project.mat` was loaded at start, that import lands on top of the existing project rather than replacing it.

After a successful import, the Segmentation tool lists compartments (scalp, skull, CSF, …) with surface-node counts. `zef.nodes` / `zef.tetra` are still empty: you have surfaces, not a volume mesh.

## 5. Create a tetrahedral mesh

**GUI:** Mesh tool → **Create FEM mesh**.

**Script** (same wrapper the button calls):

```matlab
zef.use_gpu = false;
zef.mesh_resolution = 6;          % coarser than the example default 4.5; faster
zef = zef_create_finite_element_mesh(zef);
```

`mesh_resolution` uses the **same length unit as the surfaces**, typically millimetres. Smaller numbers mean a finer lattice and more memory. The session default in `zef_init` is `3`; the packaged meshing example uses `4.5`.

When this returns, `zef.nodes` is an `N×3` vertex array, `zef.tetra` is `M×4` (1-based vertex indices), and `zef.domain_labels` / `zef.sigma` label tissue and conductivity.

A ready-made script:

```matlab
zef = examples.meshing.zef_meshing_example('use_gpu', false, 'mesh_resolution', 6);
```

That writes `data/meshing_example.mat` by default.

## 6. Sensors and a lead field

The bundled project includes electrode coordinates. If you started from a blank session, **Import → Import electrodes** and pick a file under `data/electrodes/` (see [`+core/+io/+electrodes/README.md`](../+core/+io/+electrodes/README.md)).

Then attach contacts to the volume and assemble `zef.L`:

**GUI:** Mesh tool forward-simulation table → select an EEG isotropic row → **Run script**.

**Script:**

```matlab
zef = examples.forward.lead_field_example('use_gpu', false, 'mesh_resolution', 6);
% zef.L is sensors × source columns
```

or, if the mesh already exists:

```matlab
zef.lead_field_type = 1;   % EEG, isotropic conductivity
zef.sensors_attached_volume = zef_attach_sensors_volume(zef, zef.sensors);
zef = zef_lead_field_matrix(zef);
```

Keep **LF source interp.** on (or call `zef_source_interpolation`). Inverse plugins error if `zef.source_interpolation_ind` is missing.

Session electrodes are `N×3` (point) or `N×6` (complete electrode model). The FEM does not take that 6-column array as-is; attachment builds a 4-column index table first. Column order and units: [conventions.md](conventions.md).

A lead-field solve can take minutes to hours depending on mesh size, source count (`n_sources`, default 10000), and GPU. Unknown `lead_field_type` values warn (`zef_lead_field_matrix:UnknownType`) and leave `zef.L` unchanged.

Ready `.mat` demos (mesh and often `L` already present) live under [`data/example_projects/`](../data/example_projects/README.md):

```matlab
zef = zeffiro_interface('open_project', fullfile(pwd, 'data', 'example_projects', ...
    'multicompartment_head_project.mat'), 'use_gpu', false);
```

## 7. A first inverse (programmatic)

You need `zef.L` and `zef.measurements`. For a smoke test, synthesize data:

```matlab
% toy: one time sample, random sources (not physiologically meaningful)
n_col = size(zef.L, 2);
zef.measurements = zef.L * randn(n_col, 1);
[zef, run_result] = zef_inverse_run(zef, 'mne', 'execution', 'local');
```

`zef.reconstruction` is then a cell, one vector per time frame.

Most GUI **Inverse tools** buttons call legacy plugin iterations. Every shipped profile also lists **(class solver)** entries (eLORETA, UKF-NMM, HALpR, Group Lasso, MNE, IAS, RAMUS, CSM, Kalman, Beamformer, Dipole Scan). Those open `zef_open_class_inverse` and run `zef_inverse_run`. Both tracks write `zef.reconstruction`. Details: [methods.md](methods.md), [`+inverse/README.md`](../+inverse/README.md).

## 8. What you should see

| After… | Expect |
|--------|--------|
| Import `.zef` | Compartment table filled; `zef.d1_points` (or similar tags) nonempty |
| Create FEM mesh | `zef.nodes`, `zef.tetra`, `zef.sigma` nonempty |
| Lead field | `zef.L` nonempty; `size(zef.L,1)` = number of sensors |
| Inverse | `zef.reconstruction` nonempty; Figure tool can colour the volume |

The 3-D view updates from the Mesh visualization / Figure tools, not automatically from `zef_inverse_run`.

## Importing a DUNEuro project

A DUNEuro MATLAB `.mat` file is not a native Zeffiro project. **Project → Open project** still works: `zef_load` detects DUNEuro markers (`eegL`, `electrodePositions`, …) and converts them with `utilities.duneuro2zef`. **Import → Import DUNEuro project** is the same converter with a file picker.

```matlab
zef = zeffiro_interface('start_mode', 'nodisplay', ...
    'open_project', 'path/to/duneuro_project.mat');
```

What is carried over **when the file actually contains it**: tetrahedral (or hexahedral-split) mesh and tissue labels, isotropic/anisotropic conductivity, electrode positions as PEM `N×3` millimetres, source positions, and the EEG/MEG lead field as `zef.L` (sensors × interleaved xyz columns). Lead-field numbers are copied unchanged; converting coordinates to millimetres does not rescale `L`. Zeffiro's own EEG lead field is assembled in metres, so its norm will not match a DUNEuro lead field computed in millimetres, or one from a different mesh, conductivity, electrode model, or source grid. A dump that only has `eegL`, electrodes, and a transfer matrix still opens: L and sensors are imported; the transfer matrix is skipped. Solver words in the file name (`whitney`, `anisotropic`, …) are not data. Without source coordinates, `zef_processLeadfields` can run but spatial inverse plotting cannot. Details and verified limitations: [`+utilities/+duneuro2zef/README.md`](../+utilities/+duneuro2zef/README.md).

## Where to go next

- [conventions.md](conventions.md) — millimetres vs metres, matrix orientation, CEM columns
- [zef-state.md](zef-state.md) — important fields of `zef`
- [architecture.md](architecture.md) — where code lives
- [methods.md](methods.md) — why inverse methods exist and how they differ
- [`+examples/README.md`](../+examples/README.md) — meshing, Kalman demo, published study scripts
- [`docs/developer-guide.md`](developer-guide.md) — where to add a solver or plugin

```matlab
help zeffiro_interface
help zef_inverse_run
help zef_lead_field_matrix
```
