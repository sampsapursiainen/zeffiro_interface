zef = zef_add_bounding_box(zef);
zef.exclude_box = 1;
zef.max_surface_face_count = 0.5;
zef.mesh_smoothing_on = 1;

%mesh resolution
zef.mesh_resolution = 4.5;

zef.refinement_on = 1;
zef.refinement_surface_on = 1;
import_compartment_list_aux = zef_get_active_compartments(zef);
import_compartment_list_aux = import_compartment_list_aux(end-2:end-1);
import_compartment_list_aux = import_compartment_list_aux(:)';
zef.refinement_surface_compartments = [-1 import_compartment_list_aux];
zef_mesh_tool;