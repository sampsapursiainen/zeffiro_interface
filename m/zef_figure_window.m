%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.h_zeffiro_window_2 = open('zeffiro_interface_figure_window.fig');
zef.h_zeffiro = zef.h_zeffiro_window_2;
zef.o_h = findall(zef.h_zeffiro);
zef.h_axes1 = zef.o_h(19);
zef=rmfield(zef,'o_h');
