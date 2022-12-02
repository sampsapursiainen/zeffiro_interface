# Mesh Construction

This file covers the necessary details on how one constructs a finite element
mesh in Zeffiro Interface.

## Fields related to meshing

The core struct of Zeffiro Interface contains fields related to the different
areas it operates in. This section covers the settings related to finite
element mesh generation.

### zef.mesh\_resolution (1,1) double { mustBePositive }

This setting defines the starting resolution of the mesh, before any
additional processing like refinement or smoothing have been applied.

### TODO
