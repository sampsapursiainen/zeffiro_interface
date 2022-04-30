# mri2mesh

This folder contains a shell script `mri2mesh.sh` that runs the MRI data under
a given folder `FREESURFER_INFOLDER` first through FreeSurfer via `fs2zef.sh`,
and the generated output files placed in a given folder `FREESURFER_OUTPUT`
through the Zeffiro Interface finite element mesh generation routine, which
places the resulting `.mat` files into a given folder `ZEFFIRO_OUTPUT`. In
other words, `mri2mesh.sh` is invoked with

	nohup ./mri2mesh.sh \
		FREESURFER_INFOLDER \
		FREESURFER_OUTFOLDER \
		ZEFFIRO_OUTFOLDER \
		&

Here `nohup` prevents the process from terminating if the shell which started
the process is closed and the final `&` runs the routine as a background
process. Doing it this way is rather important, as with many MRI subjects the
routine could take days to complete.
