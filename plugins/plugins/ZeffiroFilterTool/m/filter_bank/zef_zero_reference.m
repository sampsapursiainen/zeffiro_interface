function [processed_data] = zef_zero_reference(f)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Set the reference (average) level to zero
%Input:
%Output: Data with zero reference (average) level

mean_f = mean(f);
processed_data = f - mean_f(ones(size(f,1),1),:);
