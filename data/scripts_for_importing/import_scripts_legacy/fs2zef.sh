#Commands needed for extracting data from Freesurefer to Zeffiro.
#Atena Rezaei, 2019.
#System specific variable definitions

SUBJECT_DIR="/media/datadisk/atena/freesurfer_subjects"
SUBJECT="EskSa"
OUT_DIR="/media/datadisk/atena/freesurfer_subjects/fs2zef"

#Reconstructing the data out of T1-weighted data including subcortical
#structures.
# Command 1:
#   recon-all
#   -i <one slice in the anatomical dicom series>
#   -s  <subject id that you make up> \
#   -sd <directory to put the subject folder in> \
#   -all

#recon-all -i -s $SUBJECT -sd $SUBJECT_DIR/$SUBJECT  -all

#Convert any surface to ascii file:
#Command 2 :

mris_convert $SUBJECT_DIR/$SUBJECT/surf/lh.pial $OUT_DIR/lh.pial.asc
mris_convert $SUBJECT_DIR/$SUBJECT/surf/rh.pial $OUT_DIR/rh.pial.asc
mris_convert $SUBJECT_DIR/$SUBJECT/surf/rh.white $OUT_DIR/rh.wm.asc
mris_convert $SUBJECT_DIR/$SUBJECT/surf/lh.white $OUT_DIR/lh.wm.asc

#Extract subcortical structure
#Command 3:

mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 4 $OUT_DIR/lh_Lateral-Ventricle.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 5 $OUT_DIR/lh_Inf-Lat-Vent.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 7 $OUT_DIR/lh_CerebellumWM.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 8 $OUT_DIR/lh_CerebellumCortex.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 10 $OUT_DIR/lh.thalamus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 11 $OUT_DIR/lh.caudate.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 12 $OUT_DIR/lh.putamen.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 13 $OUT_DIR/lh.pallidum.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 14 $OUT_DIR/3rd-Ventricle.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 15 $OUT_DIR/4th-Ventricle.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 16 $OUT_DIR/Brainstem.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 17 $OUT_DIR/lh.Hippocampus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 18 $OUT_DIR/lh.Amygdala.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 26 $OUT_DIR/lh.Accumbens.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 28 $OUT_DIR/LVentral_DC.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 30 $OUT_DIR/LVessel.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 31 $OUT_DIR/LChoroid_plexus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 43 $OUT_DIR/rh_Lateral-Ventricle.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 44 $OUT_DIR/rh_Inf-Lat-Vent.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 46 $OUT_DIR/rh_CerebellumWM.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 47 $OUT_DIR/rh_CerebellumCortex.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 49 $OUT_DIR/rh.thalamus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 50 $OUT_DIR/rh.caudate.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 51 $OUT_DIR/rh.putamen.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 52 $OUT_DIR/rh.pallidum.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 53 $OUT_DIR/rh.Hippocampus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 54 $OUT_DIR/rh.Amygdala.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 58 $OUT_DIR/rh.Accumbens.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 60 $OUT_DIR/RVentral_DC.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 62 $OUT_DIR/RVessel.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 63 $OUT_DIR/RChoroid_plexus.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 251 $OUT_DIR/CC_posterior.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 252 $OUT_DIR/CC_Mid_posterior.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 253 $OUT_DIR/CC_Central.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 254 $OUT_DIR/CC_Mid_Anterior.asc
mri_mc $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz 255 $OUT_DIR/CC_Anterior.asc

#Visualizing the label numbers correspond to each structure:
#Command 4:

#freeview -v $SUBJECT_DIR/$SUBJECT/mri/orig.mgz $SUBJECT_DIR/$SUBJECT/mri/aseg.mgz:colormap=lut:opacity=0.4

#Extracting the strip skull and other outer non-brain tissue
#Comamnd 5:
mri_watershed -useSRAS -surf  $SUBJECT_DIR/$SUBJECT/surf  $SUBJECT_DIR/$SUBJECT/mri/orig_nu.mgz  $SUBJECT_DIR/$SUBJECT/trash/trash.mgz

mris_convert $SUBJECT_DIR/$SUBJECT/surf_outer_skin_surface $OUT_DIR/outer_skin.asc
mris_convert $SUBJECT_DIR/$SUBJECT/surf_outer_skull_surface $OUT_DIR/outer_skull.asc
mris_convert $SUBJECT_DIR/$SUBJECT/surf_inner_skull_surface $OUT_DIR/inner_skull.asc

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

mri_annotation2label --subject $SUBJECT  --sd $SUBJECT_DIR --annotation aparc.a2009s --hemi lh --ctab aparc.annot.a2009s --outdir $OUT_DIR/lh.aparc_76
mri_annotation2label --subject $SUBJECT  --sd $SUBJECT_DIR --annotation aparc.a2009s --hemi rh --ctab aparc.annot.a2009s --outdir $OUT_DIR/rh.aparc_76
mri_annotation2label --subject $SUBJECT  --sd $SUBJECT_DIR --annotation aparc --hemi lh --ctab aparc.annot --outdir $OUT_DIR/lh.aparc_36
mri_annotation2label --subject $SUBJECT  --sd $SUBJECT_DIR --annotation aparc --hemi rh --ctab aparc.annot --outdir $OUT_DIR/rh.aparc_36

#The data in the .annot files can be read using the matlab script
#Command 7:

matlab -nodisplay -nosplash -nodesktop -r "dir_name = '$SUBJECT_DIR/$SUBJECT/';[vertices,label,colortable]=read_annotation([dir_name '/label/lh.aparc.a2009s.annot']);save color_table_lh_76.mat colortable label vertices; [vertices,label,colortable]=read_annotation([dir_name '/label/rh.aparc.a2009s.annot']); save color_table_rh_76.mat colortable label vertices; [vertices,label,colortable]=read_annotation([dir_name '/label/lh.aparc.annot']); save color_table_lh_36.mat colortable label vertices; [vertices,label,colortable]=read_annotation([dir_name '/label/rh.aparc.annot']); save color_table_rh_36.mat colortable label vertices;exit;";
#Create matlab version colortables.

#Merging labels
#Comamnd 8:
mri_mergelabels -d $OUT_DIR/lh.aparc_76/ -o $OUT_DIR/lh_labels_76.asc
mri_mergelabels -d $OUT_DIR/rh.aparc_76/ -o $OUT_DIR/rh_labels_76.asc
mri_mergelabels -d $OUT_DIR/lh.aparc_36/ -o $OUT_DIR/lh_labels_36.asc
mri_mergelabels -d $OUT_DIR/rh.aparc_36/ -o $OUT_DIR/rh_labels_36.asc

matlab -nodisplay -nosplash -nodesktop -r "dir_name = '$SUBJECT_DIR/';a = dlmread([dir_name 'lh_labels_76.asc'],' ',2,0);a = a(:,[1,3,5,7]);save -ascii lh_points_76.dat a; a = dlmread([dir_name 'rh_labels_76.asc'],' ',2,0);a = a(:,[1,3,5,7]); save -ascii rh_points_76.dat a; a = dlmread([dir_name 'lh_labels_36.asc'],' ',2,0);a = a(:,[1,3,5,7]);  save -ascii  lh_points_36.dat a; a = dlmread([dir_name 'rh_labels_36.asc'],' ',2,0);a = a(:,[1,3,5,7]); save -ascii rh_points_36.dat a;quit";

