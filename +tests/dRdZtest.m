col = 100 ;

dAdZ = zefCore.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

invAdAdZ = zefCore.invAY (A,dAdZ) ;

dBdZ = zefCore.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

invAdBdZ = zefCore.invAY (A,dBdZ) ;

dCdZ = zefCore.dCdZ ( Z(col), col, numel(superNodes) ) ;

dCHdZ = zefCore.dCHdZ ( Z(col), col, numel(superNodes) ) ;

dSdZ = zefCore.dSdZ ( dCdZ, dCHdZ, Bs{col}, TM, B, invAdAdZ, invAdBdZ ) ;

dRdZ = zefCore.dRdZ ( invAdAdZ, R, invAdBdZ, invSchurC, dSdZ ) ;
