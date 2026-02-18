
# DUNEuro Examples

The examples in [this folder](.) should work if you have successfully compiled [DUNEuro](https://gitlab.dune-project.org/duneuro) and [`duneuro-matlab`](https://gitlab.dune-project.org/duneuro/duneuro-matlab), and installed the MATLAB files created by the compilation sequence into the folder `$HOME/Documents/MATLAB/+duneuro`. The files include at least the C++ bindings in `duneuro_matlab.mexa64`, the driver class file `duneuro_meeg.m` and the function class file `duneuro_function.m`. There are also the files `duneuro_point_vtk_writer.m` and `duneuro_volume_vtk_writer.m`.

Note that if the above `.m` files are placed into a `+duneuro` folder prefixed with a `+` symbol, then the MATLAB code in the files needs to be modified such, that every call to one of the functions within the folder are prefixed with `duneuro.`, if they are not already. This is because prefixing a folder with a `+` turns the folder into a [MATLAB namespace](https://se.mathworks.com/help/matlab/matlab_oop/namespaces.html).
