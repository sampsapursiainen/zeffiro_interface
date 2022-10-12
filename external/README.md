# External libraries

This folder contains external libraries such as third party optimizers (mostly
as Git submodules), that might be called by Zeffiro Interface. These can be
installed alongside Zeffiro Interface with

	git clone --recurse-submodules https://github.com/sampsapursiainen/zeffiro_interface.git

or

	git clone --recursive https://github.com/sampsapursiainen/zeffiro_interface.git

and then running

	zeffiro_setup

in the Matlab console to run their installation scripts.

Even if Zeffiro was downloaded without recursively installing the submodules,
for example by downloading the program as an archive file or Git cloning
unrecursively,

	zeffiro_setup

should still do the downloading of the modules for you.
