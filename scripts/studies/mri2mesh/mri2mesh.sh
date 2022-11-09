#!/bin/bash

# This script runs the Zeffiro Interface mesh generation routine for all
# subjects in a given folder, for which the FreeSurfer mesh generation routine
# has generated a surface segmentation. Usage:
#
#     nohup mri2mesh.sh \
#     <folder with subjects> \
#     <freesurfer output folder> \
#     <ZI output folder> &
#
# where <folder with subjects> contains subject-specific folder with mri data,
# <freesurfer_output folder> is the folder where the script fs2zef.sh will save
# its output and <ZI output folder> is where Zeffiro interface will save the
# generated meshes, if successful.

# Folders required to exist inside a specific subject folder.

REQUIRED_SUBFOLDERS=( 'label' 'mri' 'scripts' 'stats' 'surf' 'tmp' 'touch')

# Folder this script is located in

MRI2ZEF_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -d ${MRI2ZEF_DIR} ]; then
	echo "The supposed directory mri2zef is located in (${MRI2ZEF_DIR}) does not seem to exist. Aborting..."
	exit -1
fi

# Zeffiro Interface folder is the parent folder of this script.

ZI_DIR="${MRI2ZEF_DIR}/.."
ZI_DIR="${ZI_DIR%/}"

if [ ! -d ${ZI_DIR} ]; then
	echo "The supposed directory Zeffiro Interface is located in (${ZI_DIR}) does not seem to exist. Aborting..."
	exit -1
fi

# Check that Zeffiro interface exists in the supposed ZI directory.

ZI_STARTUP_FILE="${ZI_DIR}/zeffiro_interface.m"

if [ ! -f "${ZI_STARTUP_FILE}" ]; then
	echo "The Zeffiro Interface startup file ${ZI_STARTUP_FILE} does not seem to exist. Aborting..."
	exit -1
fi

# Script needs to be run from Zeffiro Interface installation folder, because of
# the way Zeffiro Interface configures its paths.

START_DIR="${PWD}"
cd "${ZI_DIR}"

# Path to fs2zef.sh. Expected to be found in the same folder with this script.

FS2ZEF="${MRI2ZEF_DIR}/fs2zef.sh"

if [ ! -f ${FS2ZEF} ]; then
	echo "Could not find fs2zef.sh in the same folder with mri2zef.sh. Aborting..."
	exit -1
fi

# Import script name and path

ZEF_IMPORT_SCRIPT_NAME="import_segmentation.zef"
ZEF_IMPORT_SCRIPT_PATH="${MRI2ZEF_DIR}/${ZEF_IMPORT_SCRIPT_NAME}"

if [ ! -f ${ZEF_IMPORT_SCRIPT_PATH} ]; then
	echo "Zeffiro segmentation import script does not exist in ${ZEF_IMPORT_SCRIPT_PATH}". Aborting...
	exit -2
fi

# Helper functions

function titleline () {
	local title="$1"
	echo
	echo '-------------------------------------------------------------------------------'
	echo $title
	echo
}

# Read and check input

FREESURFER_INFOLDER="${1%/}"
FREESURFER_OUTFOLDER="${2%/}"
ZEF_INFOLDER="${FREESURFER_OUTFOLDER}"
ZEF_OUTFOLDER="${3%/}"
ZEF_INPUT_SCRIPT="multicompartment_head_settings; zef_create_finite_element_mesh;"

titleline 'Checking that given directories and scripts exist...'

if [ ! -d "$FREESURFER_INFOLDER" ]; then
	echo "Error: folder $FREESURFER_INFOLDER does not exist!"
	exit -1
else
	echo "Subject folder ${FREESURFER_INFOLDER} OK."
fi

if [ ! -d "$ZEF_INFOLDER" ]; then
	echo "Error: FreeSurfer output folder $ZEF_INFOLDER does not exist!"
	exit -1
else
	echo "FreeSurfer output folder ${ZEF_INFOLDER} OK."
fi

if [ ! -d "$ZEF_OUTFOLDER" ]; then
	echo "Error: ZI output folder $ZEF_OUTFOLDER does not exist!"
	exit -2
else
	echo "ZI output folder ${ZEF_OUTFOLDER} OK."
fi

# Command to add mri2mesh/ to Matlab path temporarily.

ADD2PATH="addpath('${ZI_DIR}'); addpath('${MRI2ZEF_DIR}');"

# Loop over subject directories and make sure they have a sane structure,
# before running fs2zef and mesh generation.

titleline 'Starting segmentation and mesh generation'

for d in ${FREESURFER_INFOLDER}/[^.]*/; do

	# Subject folder sanity check

	for dd in ${REQUIRED_SUBFOLDERS[@]}; do

		subfolder="${d%/}/${dd%/}"

		if [ ! -d "${subfolder}" ]; then
			echo
			echo "Warning: expected folder ${subfolder} does not exist inside the subject folder ${d}."
			continue
		fi
	done

	# Check that FreeSurfer input exists and define required variables.

	if [ -d "$d" ] ; then

		# Extract subject name from source directory path

		subname="${d%/}"
		subname="${subname##*/}"

		# Create path for FreeSurfer output

		FS_OUTDIR="$FREESURFER_OUTFOLDER/${subname}"

		# Create target subdirectory

		if [ ! -d ${FS_OUTDIR} ]; then
			mkdir "${FS_OUTDIR}"
		fi

		# Copy import script to target location

		cp "${ZEF_IMPORT_SCRIPT_PATH}" "${FS_OUTDIR}"

		# Log file definition

		FS_LOG="${FS_OUTDIR%/}/fs2zef.log"

	else # Do nothing in this iteration

		continue

	fi

	titleline "Run FreeSurfer on ${d} via fs2zef.sh"

	echo
	echo "Attempting segmentation into ${FS_OUTDIR}."
	echo "FreeSurfer output will be in ${FS_LOG}."

	nohup "$FS2ZEF" "$FREESURFER_INFOLDER" "$subname" "$FS_OUTDIR" &> "${FS_LOG}"

	titleline "Run mesh generation on ${FS_OUTDIR}."

	# Import script path and check

	ZEF_OUTDIR="${ZEF_OUTFOLDER}/${subname}"

	if [ ! -d "${ZEF_OUTDIR}" ]; then
		mkdir ${ZEF_OUTDIR}
	fi

	ZEF_IMPORT_SCRIPT="${FS_OUTDIR}/${ZEF_IMPORT_SCRIPT_NAME}"

	if [ ! -f ${ZEF_IMPORT_SCRIPT} ]; then
		echo "Import script ${ZEF_IMPORT_SCRIPT} does not exist. Skipping mesh generation for ${subname}..."
		continue
	fi

	OUTFILE="${ZEF_OUTFOLDER}/${subname}.mat"
	ZEF_STDOUT="${ZEF_OUTFOLDER}/${subname}/meshgen.out"
	ZEF_STDERR="${ZEF_OUTFOLDER}/${subname}/meshgen.err"

	echo
	echo "Attempting mesh generation into ${OUTFILE}."
	echo "Zeffiro output will be in ${ZEF_STDOUT} and ${ZEF_STDERR}"

	# Generate finite element mesh with Zeffiro Interface. Note the </dev/null.
	# It prevents Matlab from infinitely waiting for input and complaining
	# about invalid file descriptors.

	nohup matlab -nodisplay -nosplash -r "${ADD2PATH}; zeffiro_interface('start_mode', 'nodisplay', 'import_segmentation_legacy', '${ZEF_IMPORT_SCRIPT}', 'run_script', '${ZEF_INPUT_SCRIPT}', 'save_project', '${OUTFILE}')" 1>"${ZEF_STDOUT}" 2>"${ZEF_STDERR}" </dev/null

done

# Change back to the folder where this script was run from.

cd "${START_DIR}"
