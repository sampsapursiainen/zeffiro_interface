This folder contains an example on importing an externally (Duneuro) generated FEM mesh into Zeffiro Interface. The data files are referenced but not included for their size. The file (.ZEF) can be imported in ZI. Each line describes a single import item. The parameter name and value occur as comma-separated pairs described below.

parameter: type
value: script - the line runs a script
value: struct - the line describes a data structure to be imported as a part of the zef data strucutre
value: segmentation - the line describes a segmentation compartment
value: sensors - the line describes a sensor set

parameter: name
value: the name of the field to appear in ZI.

parameter: filename
value: the name of the file to be imported

parameter: filetype
value: if the filetype is mat, the information is imported from a Matlab-structure.

parameter: database
value: bst - the item will be imported from currently open Brainstorm protocol

parameter: atlas
value: the name of the atlas to be used

parameter: atlas_tag
value: the tag of the parameter

parameter: tag
value: the tag of the compartment in the database. If not given, tag is equal to name

parameter: subject
value: the identifier (number) of a subject in a database

parameter: on
value: logical true or false (or 1 or 0) - defines whether sensors or segmentation compartment are included actively in the system.

parameter: merge
value: logical true or false (or 1 or 0) - determines whether an imported surface mesh will be merged into an existing mesh

parameter: invert
value: logical true or false (or 1 or 0) - determines whether the surface normal of an imported mesh is inverted

parameter: activity
value: -1 (bounding box), 0 (inactive), 1 (constrained activity), 2 (unconstrained activity), 3 (activity projected on a surface) - the activity of a compartement

parameter: visible
value: logical true or false (or 1 or 0) - controls the visibility of the compartment in the segmentation

parameter: affine transform
value: 4x4 matrix defining an affine transformation
