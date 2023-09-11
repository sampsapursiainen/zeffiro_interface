[vertices,label,colortable]=read_annotation([dir_name '/label/lh.aparc.a2009s.annot']);
save color_table_lh_76.mat colortable label vertices;
[vertices,label,colortable]=read_annotation([dir_name '/label/rh.aparc.a2009s.annot']);
save color_table_rh_76.mat colortable label vertices;
[vertices,label,colortable]=read_annotation([dir_name '/label/lh.aparc.annot']);
save color_table_lh_36.mat colortable label vertices;
[vertices,label,colortable]=read_annotation([dir_name '/label/rh.aparc.annot']);
save color_table_rh_36.mat colortable label vertices;


