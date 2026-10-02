# plugins/StripTool

## Folder purpose

Generic **implanted strip / cylinder** geometry as FEM compartments (optional encapsulation) plus contact points. Default head-profile menu: **Forward tools → Strip tool** (`zef_strip_tool_start`).

## Main contents

| File | Role |
|------|------|
| `zef_strip_tool_start` / `_open` / `_window` / `_update` / `_delete` | GUIDE UI lifecycle (`_window` builds the figure; `_open` shows it; `_update` / `_delete` refresh or drop the selected strip) |
| `zef_strip_tool_init` / `_update` / `_add` / `_delete` | `*_strip_cell` lifecycle |
| `zef_create_strip` | Strip geometry |
| `zef_simple_cylinder_generator` | Cylinder mesh helper |
| `zef_get_strip_parameters` | Parameter pack |
| `zef_strip_coordinate_transform` | Local ↔ world |
| `zef_strip_tool_embed` | `zef_add_compartment` for strip (+ encapsulation) |
| `zef_strip_tool_add_contacts` / `zef_get_strip_contacts` | Sensor contacts |
| `zef_strip_tool_plot` | Preview |

## Code functionality

1. Add strip entry → tip, orientation, model (Omnidirectional 4, Directional 8, Directional 40, DiSC 64, DiSC 128), length, impedance, encapsulation options.
2. **Plot** preview in local/world coordinates.
3. **Embed** creates compartment(s) via `zef_add_compartment`.
4. **Add contacts** writes sensor points for stimulation/recording setups.
5. Geometry edits lock when status is Embedded.

## Workflow context

```
StripTool → compartments + contacts on zef
  → remesh / attach electrodes / forward (EIT/tES/EEG as applicable)
```

## Usage instructions

```matlab
zef_strip_tool_start;
% Add strip → set tip/orientation/length → Plot → Embed → Add contacts
```

## Important notes

- Delete clears strip_cell / helper state; it does **not** remove already-embedded compartments automatically.
- Embedded strips should be remeshed before trusting FEM results.
- Registered on `profile/multicompartment_head/zeffiro_plugins.ini` as **Strip tool**. Other profiles still start it with `zef_strip_tool_start`.

## Developer guidance

- Keep coordinate transforms centralized in `zef_strip_coordinate_transform`.
- Pitfall: editing geometry after Embed without clearing status locks.
