#!/bin/bash

### fs2zef.sh
#
# Commands needed for extracting data from FreeSurfer to Zeffiro Interface.
# Called with
#
#   fs2zef.sh <subject parent directory> <individual subject directory name> <output directory> <recon-all input file>
#
# All 4 arguments need to be given, or the script will exit early. If the
# recon-all input file is not needed, simply pass in an empty string "" in its
# place.
#
# Atena Rezaei, 2019.
# Expanded by Santtu Söderholm, 2022.
#

# Constant and variable definitions.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INPUT_PARENT_DIR=${1%/} # The directory that contains the below SUBJECT folder.

SUBJECT=${2} # The name of the specific subject directory being observed.

OUT_DIR=${3%/} # The output location of FreeSurfer.

RECON_ALL_INPUT_FILE=${4%/}     # The output location of FreeSurfer.

SUBJECT_FOLDER="${INPUT_PARENT_DIR}/${SUBJECT}" # Path to specific subject folder

# Check that all given arguments exist.

if [ "$#" -ne 4 ]; then
	echo "Error: fs2zef needs 4 arguments:"
	echo "  1: The path of the parent directory of the input folder,"
	echo "  2: The name of the input folder,"
	echo "  3: The path of the output folder and"
	echo "  4: The (possibly empty) path of the input file of recon-all."
	echo "     If this is empty, recon-all is not started."
	exit -1
fi

if [ ! -d "$INPUT_PARENT_DIR" ]; then
	echo "Error: given fs2zef subject parent directory ${INPUT_PARENT_DIR} does not exist."
	exit -2
fi

if [ ! -d "$SUBJECT_FOLDER" ]; then
	echo "Error: given fs2zef input subject folder ${SUBJECT_FOLDER} does not exist."
	exit -3
fi

if [ ! -d "$OUT_DIR" ]; then
	echo "Error: given fs2zef output directory ${OUT_DIR} does not exist."
	exit -4
fi

if [ -z "$FREESURFER_HOME" ]; then
	echo "Error: the environment variable FREESURFER_HOME is empty or not defined."
	echo "       Please point it to where you installed FreeSurfer."
	exit -5
fi

#Reconstructing the data out of T1-weighted data including subcortical
#structures.
# Command 1:
#   recon-all
#   -i <one slice in the anatomical dicom series>
#   -s  <subject id that you make up> \
#   -sd <directory to put the output folder in> \
#   -all

if [ ! -z "$RECON_ALL_INPUT_FILE" ]; then

	if [ ! -f "$RECON_ALL_INPUT_FILE" ]; then
		echo "Error: given recon-all input file ${RECON_ALL_INPUT_FILE} does not exist or is not a file."
		exit -6
	fi

	echo "Running recon-all on ${RECON_ALL_INPUT_FILE}. This might take a while..."
	recon-all -i "$RECON_ALL_INPUT_FILE" -s "$SUBJECT" -sd "$INPUT_PARENT_DIR"  -all
	echo "Done."
fi

#Convert any surface to ascii file:
#Command 2 :

mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf/lh.pial $OUT_DIR/lh.pial.asc
mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf/rh.pial $OUT_DIR/rh.pial.asc
mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf/rh.white $OUT_DIR/rh.wm.asc
mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf/lh.white $OUT_DIR/lh.wm.asc

#Extract subcortical structure
#Command 3:

mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 4 $OUT_DIR/lh_Lateral-Ventricle.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 5 $OUT_DIR/lh_Inf-Lat-Vent.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 7 $OUT_DIR/lh_CerebellumWM.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 8 $OUT_DIR/lh_CerebellumCortex.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 10 $OUT_DIR/lh.thalamus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 11 $OUT_DIR/lh.caudate.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 12 $OUT_DIR/lh.putamen.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 13 $OUT_DIR/lh.pallidum.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 14 $OUT_DIR/3rd-Ventricle.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 15 $OUT_DIR/4th-Ventricle.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 16 $OUT_DIR/Brainstem.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 17 $OUT_DIR/lh.Hippocampus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 18 $OUT_DIR/lh.Amygdala.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 26 $OUT_DIR/lh.Accumbens.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 28 $OUT_DIR/LVentral_DC.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 30 $OUT_DIR/LVessel.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 31 $OUT_DIR/LChoroid_plexus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 43 $OUT_DIR/rh_Lateral-Ventricle.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 44 $OUT_DIR/rh_Inf-Lat-Vent.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 46 $OUT_DIR/rh_CerebellumWM.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 47 $OUT_DIR/rh_CerebellumCortex.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 49 $OUT_DIR/rh.thalamus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 50 $OUT_DIR/rh.caudate.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 51 $OUT_DIR/rh.putamen.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 52 $OUT_DIR/rh.pallidum.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 53 $OUT_DIR/rh.Hippocampus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 54 $OUT_DIR/rh.Amygdala.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 58 $OUT_DIR/rh.Accumbens.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 60 $OUT_DIR/RVentral_DC.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 62 $OUT_DIR/RVessel.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 63 $OUT_DIR/RChoroid_plexus.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 251 $OUT_DIR/CC_posterior.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 252 $OUT_DIR/CC_Mid_posterior.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 253 $OUT_DIR/CC_Central.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 254 $OUT_DIR/CC_Mid_Anterior.asc
mri_mc $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz 255 $OUT_DIR/CC_Anterior.asc

#Visualizing the label numbers correspond to each structure:
#Command 4:

#freeview -v $INPUT_PARENT_DIR/$SUBJECT/mri/orig.mgz $INPUT_PARENT_DIR/$SUBJECT/mri/aseg.mgz:colormap=lut:opacity=0.4

#Extracting the strip skull and other outer non-brain tissue
#Comamnd 5:
mri_watershed -useSRAS -surf  $INPUT_PARENT_DIR/$SUBJECT/surf  $INPUT_PARENT_DIR/$SUBJECT/mri/orig_nu.mgz  $INPUT_PARENT_DIR/$SUBJECT/trash/trash.mgz

mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf_outer_skin_surface $OUT_DIR/outer_skin.asc
mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf_outer_skull_surface $OUT_DIR/outer_skull.asc
mris_convert $INPUT_PARENT_DIR/$SUBJECT/surf_inner_skull_surface $OUT_DIR/inner_skull.asc

#.annot files
# After Freesurfer processes a subject, in the subject's /label directory,
#there are .annot files containing the parcellation data for each
#hemishere.

#?h.aparc.annot files contain the desikan_killiany.gcs parcellation scheme
#(36 labels)
#?h.aparc.a2009s.annot files contain the destrieux.simple.2009-07-28.gcs
#scheme (76 labels)
#?h.aparc.DKTatlas.annot correspond to the DKTatas40.gcs scheme

#Cortical Parcellation
#Command 6:

mri_annotation2label --subject $SUBJECT  --sd $INPUT_PARENT_DIR --annotation aparc.a2009s --hemi lh --ctab aparc.annot.a2009s --outdir $OUT_DIR/lh.aparc_76
mri_annotation2label --subject $SUBJECT  --sd $INPUT_PARENT_DIR --annotation aparc.a2009s --hemi rh --ctab aparc.annot.a2009s --outdir $OUT_DIR/rh.aparc_76
mri_annotation2label --subject $SUBJECT  --sd $INPUT_PARENT_DIR --annotation aparc --hemi lh --ctab aparc.annot --outdir $OUT_DIR/lh.aparc_36
mri_annotation2label --subject $SUBJECT  --sd $INPUT_PARENT_DIR --annotation aparc --hemi rh --ctab aparc.annot --outdir $OUT_DIR/rh.aparc_36

#The data in the .annot files can be read using the matlab script
#Command 7:

matlab -nodisplay -nosplash -nodesktop -batch "cd(fullfile('${SCRIPT_DIR}')); save_color_tables('${SUBJECT_FOLDER}','${OUT_DIR}')"

#Create matlab version colortables.

#Merging labels
#Comamnd 8:
mri_mergelabels -d $OUT_DIR/lh.aparc_76/ -o $OUT_DIR/lh_labels_76.asc
mri_mergelabels -d $OUT_DIR/rh.aparc_76/ -o $OUT_DIR/rh_labels_76.asc
mri_mergelabels -d $OUT_DIR/lh.aparc_36/ -o $OUT_DIR/lh_labels_36.asc
mri_mergelabels -d $OUT_DIR/rh.aparc_36/ -o $OUT_DIR/rh_labels_36.asc

matlab -nodisplay -nosplash -nodesktop -batch "cd(fullfile('${SCRIPT_DIR}')); save_dats('${OUT_DIR}')"

# Copy example electrode file and import script to the destination.

echo "Copying electrodes and import script to ${OUT_DIR}..."

cp "${SCRIPT_DIR}/electrodes.dat" "${OUT_DIR}"

cp "${SCRIPT_DIR}/import_segmentation.zef" "${OUT_DIR}"

echo "Done."
