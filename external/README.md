# External libraries

This folder contains external libraries such as third party optimizers (mostly
as Git submodules), that might be called by Zeffiro Interface. These can be
installed alongside Zeffiro Interface with (Git version ≥ 2.13)

	git clone --recurse-submodules https://github.com/sampsapursiainen/zeffiro_interface.git

or with (Git version ∈ [1.6.5, 2.12] )

	git clone --recursive https://github.com/sampsapursiainen/zeffiro_interface.git

and then running

	zeffiro_setup

in the Matlab console to run their installation scripts.

Even if Zeffiro was downloaded without recursively installing the submodules,
for example by downloading the program as an archive file or Git cloning
unrecursively,

	zeffiro_setup

should still do the downloading of the modules for you.

**Note:** If you wish to include a new external submodule for use with your
plugins, you need to allow its addition into the project tree in the
[`.gitignore`](../.gitignore) file in the project root.
