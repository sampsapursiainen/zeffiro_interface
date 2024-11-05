%
% A script for generating the impedance plot of this study. Requires that one
% of the data files has been loaded into the main workspace, aminly so that the
% electrode contact surfaces are present.
%

lineStyles = [ "-" , "--", ":", "-."  ] ;

fs = 0 : 5 : 1e5 ;

fN = numel (fs) ;

Rds = [1e3 ; 1e4 ] ;

Cd = 1e-7 ;

Rcs = [1e2 ; 1e3 ; 5e3]' ;

CS = repmat (contactSurfaces(1),1,fN) ;

fig = figure (1) ;

fig.WindowState = "maximized" ;

ax = axes(fig) ;

ii = 0 ;

for rcI = 1 : numel (Rcs)

    Rc = Rcs (rcI) ;

    for rdI = 1 : numel (Rds)

        lineStyle = lineStyles ( mod ( ii, numel (lineStyles) ) + 1 ) ;

        ii = ii + 1 ;

        Rd = Rds (rdI) ;

        electrodes = zefCore.ElectrodeSet(frequencies=fs, capacitances=Cd, contactResistances=Rc, doubleLayerResistances=Rd, contactSurfaces=CS) ;

        plot ( fs, abs(electrodes.impedances), lineStyle, LineWidth=4) ;

        hold on ;

    end % for rdI

end % for rcI

legendsStrs = "" ;

legendStrs = "$R_\mathrm{c} = " + Rcs + "\,\Omega$" ;

legendStrs = legendStrs + ", $R_\mathrm{d} = " + Rds + "\,\Omega$" ;

% legendStrs = legendStrs + ", $C_\mathrm{d} = \mathrm{" + Cd + "}\,\mathrm{F}$" ;

plotLegend = legend (legendStrs, Interpreter="latex") ;

fontSize = 25 ;

fontsize (plotLegend, fontSize, "points")

fontsize (ax, fontSize, "points")

ax.XScale = "log" ;

ax.XLim = [min(fs), max(fs)] ;

xlabel("$f (\mathrm{Hz})$", Interpreter="latex") ;

ylabel("$|Z_\ell| (\Omega)$", Interpreter="latex") ;

grid on ;

grid minor ;

hold off ;

exportgraphics(fig,"impedances.pdf",ContentType="vector") ;

close(fig)
