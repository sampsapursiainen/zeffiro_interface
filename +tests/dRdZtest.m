col = 100 ;

dAdZ = core.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

dBdZ = core.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

dCdZ = core.dCdZ ( Z(col), col,numel(superNodes) ) ;

dCHdZ = core.dCHdZ ( Z(col), col, numel(superNodes) ) ;

dSdZ = core.dSdZ ( dCdZ, dCHdZ, Bs{col}, TM, B, A, Z(col), Ms{col}, superNodes(col).totalSurfaceArea, col ) ;

dRdZ = core.dRdZ ( A, dAdZ, R, dBdZ, invSchurC, dSdZ ) ;
