col = 100 ;

dAdZ = core.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

invAdAdZ = core.invAY (A,dAdZ) ;

dBdZ = core.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

invAdBdZ = core.invAY (A,dBdZ) ;

dCdZ = core.dCdZ ( Z(col), col, numel(superNodes) ) ;

dCHdZ = core.dCHdZ ( Z(col), col, numel(superNodes) ) ;

dSdZ = core.dSdZ ( dCdZ, dCHdZ, Bs{col}, TM, B, invAdAdZ, invAdBdZ ) ;

dRdZ = core.dRdZ ( invAdAdZ, R, invAdBdZ, invSchurC, dSdZ ) ;
