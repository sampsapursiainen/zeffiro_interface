Zeffiro Interface (ZI), © 2018- Sampsa Pursiainen & ZI Development Team,
is an open source code package constituting an accessible tool for
multidisciplinary finite element (FE) based forward and inverse
simulations in complex geometries. Install ZI using zeffiro_downloader.m
to allow automatic updates between the local and remote repositories. The
downloader and then ZI can be obtained on matlab's command line as follows:

urlwrite('https://tinyurl.com/zeffiro','zeffiro_downloader.m');
zeffiro_downloader;

where the URL is a shortcut to the page:

https://raw.githubusercontent.com/sampsapursiainen/zeffiro_interface/master/zeffiro_downloader.m

With ZI, one can segment a realistic multilayer geometry and generate a
multi-compartment FE mesh, if triangular ASCII surface grids (in DAT or
ASC file format) are available. A suitable surface segmentation can be
produced, for example, with the FreeSurfer software suite (Copyright ©
FreeSurfer, 2013). Such a segmentation can be imported at once from a
folder containing a set of ASCII files. An example folder can be found in
the repository.  ZI allows also importing a parcellation created with
FreeSurfer to enable distinguishing different brain regions and, thereby,
analysing the connectivity of the brain function over a time series.
Different compartments can be defined as active, allowing the analysis of
the sub-cortical strucures. In each compartment, the orientation of the
activity can be either normally constrained or unconstrained. The main
routines of ZI can be accelerated significantly in a computer equipped
with a graphics computing unit (GPU). It is especially recommendable to
perform the forward simulation process, i.e., to generate the finite
element mesh, the lead field matrix and to interpolate between different
point sets, utilizing a GPU. After the forward simulation phase, the
model can be processed also without GPU acceleration.

A brief introduction to the essential features of the interface can be
found at:

https://github.com/sampsapursiainen/zeffiro_interface/wiki

The interface itself has been introduced in:

He, Q., Rezaei, A. & Pursiainen, S. (2019). Zeffiro User Interface for
Electromagnetic Brain Imaging: a GPU Accelerated FEM Tool for Forward and
Inverse Computations in Matlab. Neuroinformatics,
doi:10.1007/s12021-019-09436-9

The essential mathematical techniques used in the interface have been
reviewed and validated in:

Miinalainen, T., Rezaei, A., Us, D., Nüßing, A., Engwer, C., Wolters, C.
H., & Pursiainen, S. (2019). A realistic, accurate and fast source
modeling approach for the EEG forward problem. NeuroImage, 184, 56-67.

Pursiainen, S. (2012). Raviart–Thomas-type sources adapted to applied EEG
and MEG: implementation and results. Inverse Problems, 28(6), 065013.

The IAS MAP (iterative alternating sequential maximum a posteriori)
inversion method and the hierarchical Bayesian sampler are based on:

Calvetti, D., Hakula, H., Pursiainen, S., & Somersalo, E. (2009).
Conditionally Gaussian hypermodels for cerebral source localization. SIAM
Journal on Imaging Sciences, 2(3), 879-909.

It has been applied for a realistic brain geometry, e.g., in:

Lucka, F., Pursiainen, S., Burger, M., & Wolters, C. H. (2012).
Hierarchical Bayesian inference for the EEG inverse problem using
realistic FE head models: depth localization and source separation for
focal primary currents. Neuroimage, 61(4), 1364-1382.

The current preserving source model combines linear (face-intersecting)
and quadratic (edgewise) elements via the Position Based Optimization
(PBO) method and the 10-source stencil in which 4 face sources and 6 edge
sources are applied for each tetrahedral element containing a source:

Bauer, M., Pursiainen, S., Vorwerk, J., Köstler, H., & Wolters, C. H.
(2015). Comparison study for Whitney (Raviart–Thomas)-type source models
in finite-element-method-based EEG forward modeling. IEEE Transactions on
Biomedical Engineering, 62(11), 2648-2656.

Pursiainen, S., Vorwerk, J., & Wolters, C. H. (2016).
Electroencephalography (EEG) forward modeling via H (div) finite element
sources with focal interpolation. Physics in Medicine & Biology, 61(24),
8502.

ZI is not designed to be used in clinical applications. The authors do not
take the responsibility of the results obtained with ZI using clinical
data.

