
Mesh.CharacteristicLengthExtendFromBoundary = 1;
Mesh.CharacteristicLengthFactor = 1;
Mesh.CharacteristicLengthMin = 0.01;
Mesh.CharacteristicLengthMax = 0.06;


Merge "itokawa_layer_intermediate.stl";
asteroid_surface_loop_scaled = newreg;
asteroid_volume_scaled = newreg;

Merge "itokawa_v5763_scaled05_neworigin001.stl";
asteroid_surface_loop = newreg;
asteroid_volume = newreg;

Merge "interior_1_dense.stl";
interior_1_loop = newreg;
asteroid_volume = newreg;

Surface Loop(interior_1_loop) = {3};
Surface Loop(asteroid_surface_loop) = {2};
Surface Loop(asteroid_surface_loop_scaled) = {1};

Volume(asteroid_volume_scaled) = {asteroid_surface_loop_scaled, interior_1_loop};
Physical Volume(4) = asteroid_volume_scaled;

// Outer surface and volume
Volume(asteroid_volume) = {asteroid_surface_loop, asteroid_surface_loop_scaled};
Physical Volume(1) = asteroid_volume;





Coherence;
