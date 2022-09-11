%Create points after merging all l/RH labels load ('lh.all_aparc.2009s.dat');
a = load ('lh.all_aparc.2009s');
c = a([3:end],[1:4]);
save lh_point.dat c