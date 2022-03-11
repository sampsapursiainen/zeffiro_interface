function [processed_data] = zef_electrode_reference(f,electrode_index)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Set a given electrode as a reference
%Input: 1 Electrode index [Default: 1],
%Output: Data with zero reference level set by the electrode with the given index.

ref_f = f(electrode_index,:);
processed_data = f - ref_f(ones(size(f,1),1),:);
