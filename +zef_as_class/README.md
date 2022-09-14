# Zeffiro application

An example of how Zeffiro Interface could be constructed, if the different
components were broken down into separate classes. The classes are as follows:

## [Zef](./@Zef/)

The core back-end of the application, that holds the data and methods
necessary to actually perform computations. Can be used by itself in the
terminal, or via `ZeffiroInterface`.

## [ZeffiroInterface](./@ZeffiroInterface/)

A main GUI component that holds onto an instance of `Zef` and other GUI
subcomponents listed below. If this is activated, that is. Zef can be used
without a gui as well.

## [SegmentationTool](./@SegmentationTool/)

A tool that determines which volume compartments are active and other menu
items.

## [MeshTool](./@MeshTool/)

This is where you activate mesh generation and lead field computation via the
GUI.

## [MeshVisualizationTool](./@MeshVisualizationTool/)

This is where one sets visualization related settings and activates
visualizations.

## [FigureTool](./@FigureTool/)

This tool displays the visualizations, whose settings were set in
`MeshVisualizationTool`.

## [TerminalWaitbar](./@TerminalWaitbar/)

A progress display that can be shown in a terminal.
