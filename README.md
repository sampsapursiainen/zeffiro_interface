Zeffiro Interface is a simple tool for finite element based EEG and MEG
forward and inverse simulations. With Zeffiro, one can segment  a
realistic multilayer geometry and generate a finite element mesh, if
triangular surface grids (in ASCII DAT file format) are available. As a
special feature one can generate a time-lapse of inverse estimates for a
given data sequence. An example can be found in ./data/media folder. The
current version also allows using a graphics card to speed up the mesh
segmentation as well as forward (lead field) and inversion computations. A
spherical model has been included as an example
(./data/spherical_example.mat). The name Zeffiro is Italian for 'a gentle
breeze'. A more detailed introduction to the functions and scientific
background of the interface can be found at:

https://github.com/sampsapursiainen/zeffiro_interface/wiki

If you want to learn more about the interface, apply it for research or
education, or are interested to develop it further please contact
sampsa.pursiainen@tut.fi. Please refer to the studies below, if you use
the interface for academic research.

The essential mathematical techniques used in the interface have been
reviewed and validated in:

Pursiainen, S. (2012). Raviart–Thomas-type sources adapted to applied EEG
and MEG: implementation and results. Inverse Problems, 28(6), 065013.

The IAS MAP (iterative alternating sequential maximum a posteriori)
inversion method is based on:

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

Pursiainen, S., Sorrentino, A., Campi, C., & Piana, M. (2011). Forward
simulation and inverse dipole localization with the lowest order
Raviart—Thomas elements for electroencephalography. Inverse Problems,
27(4), 045003.

