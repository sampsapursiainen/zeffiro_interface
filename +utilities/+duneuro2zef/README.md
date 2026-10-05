# `utilities.duneuro2zef` — DUNEuro project → native Zeffiro session

## Folder purpose

Convert a **DUNEuro MATLAB project** (or a FieldTrip-style DUNEuro export folder) into native Zeffiro fields: tetrahedral mesh and compartments when present, sensors, source space when present, and lead field `zef.L`. The result is meant to be used like a Zeffiro project, not as a dump of DUNEuro internals.

## What a user does

**GUI:** **Project → Open project** on a DUNEuro `.mat` file, or **Import → Import DUNEuro project**. Open project is the same path a native Zeffiro MAT uses; DUNEuro files are detected and converted before merge.

**Script** (verified):

```matlab
zef = zeffiro_interface('start_mode', 'nodisplay', ...
    'open_project', 'path/to/duneuro_project.mat');
% or, with a live session:
zef = utilities.duneuro2zef.import_duneuro_project(zef, 'path/to/duneuro_project.mat');
```

`utilities.duneuro2zef.run(path)` / `convert(path)` return the field payload without a session.

## What is imported (when present)

| DUNEuro | Zeffiro |
|---------|---------|
| `eegL` / `megL` / FieldTrip `lf` | `zef.L`, sensors × interleaved xyz columns |
| `electrodePositions` / `elec.chanpos` (3×N or N×3) | `zef.sensors`, `s_points` (N×3 mm, PEM) |
| Extra electrode columns (CEM radii / impedance) | Not used as PEM; kept on `duneuro_import.electrode_aux` |
| Tetrahedral `nodes` + `elements` | `zef.nodes`, `zef.tetra` (1-based) |
| Hexahedral elements | Split with `zef_hexa_to_tetra` (Zeffiro has no hex runtime mesh) |
| Tissue labels / names / isotropic σ | Compartments `c1`…`cn` + `zef.sigma(:,1)` |
| Anisotropic tensors (6- or 9-column) | `zef.sigma(:,3:8)` = `[σ11 σ22 σ33 σ12 σ13 σ23]` |
| Dipoles / source grid | `source_positions` / `source_directions` |
| Documented source-model names (`whitney`, `venant`, …) **inside the file** | `core.types.ZefSourceModel` |
| Measurements matching the sensor count | `zef.measurements` (sensors × time) |

Filenames are not parsed. A name that contains `anisotropic` or `whitney` does not create tensors or a source model if those arrays are absent from the MAT.

## Conventions (verified, not assumed from one file)

- **Lead field.** DUNEuro MATLAB / FieldTrip `leadfield_duneuro` stores EEG L as **n_sensors × 3·n_sources** with columns `[x1 y1 z1 x2 y2 z2 …]`. MATLAB v7.3 dumps of the Python/C++ 3-D array often appear as `(n_sensors, n_sources, 3)`. `(3, n_sources, n_sensors)` is also accepted. Both are permuted onto the interleaved layout using the electrode count as the sensor axis. When `n_sources` is also 3, `(n_sensors, 3, 3)` is taken as orientation-last. This is the raw `zef.L` layout: `zef_processLeadfields` then `zef_inverse_extract_bundle` feed class inverses that `reshape(L, n_sensors, 3, n_sources)`. Values are copied unchanged. Coordinate conversion to millimetres does **not** multiply `L`.
- **Electrodes.** `set_electrodes` in duneuro-matlab / FieldTrip takes **3 × n** (columns are sensors). Zeffiro stores **N × 3** millimetres, point electrodes (PEM). CEM radii are not invented as Zeffiro CEM columns.
- **Indexing.** DUNE/DUNEuro elements may be 0-based; they are shifted to MATLAB 1-based when `min(elements)==0`. Tissue IDs are remapped onto consecutive Zeffiro compartment indices `1:n`. Original IDs stay in `duneuro_import.original_tissue_ids` and default names (`DUNEuro tissue 0`, …).
- **Hexahedra.** Split with the DUNE / ndgrid corner order expected by `zef_hexa_to_tetra`. If that split is degenerate, VTK order (bottom `1 2 4 3`) is retried. Other non-degenerate orderings are not guessed.
- **Units.** DUNEuro does not convert mesh units. A `unit` field is honoured (`m` → ×1000, `cm` → ×10, `mm` → 1). Otherwise a head-sized bounding box is classified as mm (diagonal in `[50, 500]`) vs m (`[0.05, 0.5]`). Coordinates that fall in neither band are stored as given with `location_unit` still millimetres. The same scale is not applied to `L`. Zeffiro builds its own EEG lead field after converting millimetre nodes to metres, so that matrix is volts per ampere-metre for a dipole moment of 1 A·m. A DUNEuro lead field whose mesh and moment of 1 are in millimetres is smaller by about 10^6 (potential of a current dipole scales as 1/length^2). A further mismatch remains unless the mesh, conductivity (including anisotropy), electrode model, source positions, and source model are the same. Do not rescale an imported `L` so that its norm matches another project.
- **Transfer matrix `eegT` / `megT`.** Paper definition `T = R A^{-1}`. Dumps may store it as sensors × DOFs or DOFs × sensors. It is a DUNEuro FEM internal used to *build* L. Zeffiro inverse and visualization read `zef.L`, not T. T is **not** copied onto the session and is **not** loaded from disk.

## What this importer does not do

- Recompute a lead field that is already in the file.
- Remesh a valid tetrahedral volume conductor.
- Guess source coordinates that are not in the file. Without `source_positions`, `zef.L` is still imported and an identity `source_interpolation_ind` lets `zef_processLeadfields` run; spatial plotting and `zef_inverse_extract_bundle` need positions.
- Treat a transfer matrix as a substitute for L, mesh, or electrodes.
- Invert tissue labels or subset EEG channels with dataset-specific index lists.
- Read solver configuration from the file name.

## Supported inputs

1. **DUNEuro MATLAB MAT** with any combination of `eegL`/`megL`, `electrodePositions`, volume-conductor mesh, tensors, dipoles. Optional extra fields are ignored. A file that only contains `eegL`, electrodes, and `eegT` is valid: L and sensors are imported; T is skipped.
2. **Export folder** containing `mesh.mat` and/or `LF_EEG.mat` / `LF_MEG.mat` and `sensors.mat` (FieldTrip-style dump). Measurements are optional.

Native Zeffiro projects (`compartment_tags` plus mesh or `L`) are **not** classified as DUNEuro; `zef_load` loads them unchanged. Saving a converted payload and opening it again uses the native path.

Unsupported / malformed inputs fail with `duneuro2zef:*` identifiers (`EmptyProject`, `SensorLeadFieldMismatch`, `InvalidLeadField`, `InvalidMesh`, …). A transfer matrix alone is `EmptyProject`.

## Main contents

| Entry | Role |
|-------|------|
| `is_duneuro_project` | Detect MAT / folder / struct without loading T |
| `load_raw` | Load useful variables; skip transfer matrices |
| `convert` / `run` | Semantic conversion → Zeffiro field payload |
| `import_duneuro_project` | Merge payload into a live `zef` session |
| `find_files` | Folder glob helper |
| `private/` | Stage helpers used only by `convert` (field lookup, mesh, L, conductivity, units). Not a public API. |

## Limitations that have been verified

- A project that only stores `eegL` + electrodes (no mesh, no source grid) opens with sensors and `zef.L`. Volume/compartment visualization is empty because there is no mesh to show. Inverse methods that index `zef.source_positions` cannot localize in space until source coordinates are supplied.
- MEG and EEG lead fields in the same file: `zef.L` receives EEG; MEG is not stacked (different sensors).
- MEG columns that are not a multiple of 3 are treated as one column per source (`source_direction_mode = 3`). Cartesian MEG that happens to have `n_sources` divisible by 3 is indistinguishable from xyz triplets.
- DUNEuro source models without a Zeffiro equivalent (subtraction, partial integration) are omitted; the imported L is still used.
- Hex meshes whose vertex order is neither DUNE nor VTK, but still non-degenerate, are not auto-detected.

## Developer guidance

Keep `convert.m` as an explicit pipeline: identify → validate → coordinates/indexing/units → mesh/compartments → sensors → sources → lead field → metadata → checks. Stage implementations live in `private/` and must stay behavior-identical to that pipeline. Do not add filename parsing, channel-index tables, or sample-specific mesh sizes. Tests: `tests.unit.Duneuro2ZefTest` (layout, indexing, units, tensors, detection, extra fields, unsupported inputs).
