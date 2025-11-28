function T = eeg_transfer_matrix(config, driver)
%
%   T = eeg_transfer_matrix(config,driver)
%
% A function that computes an EEG transfer matrix from nodes to electrodes using the DUNEuro software suite.
% Assumes that the duneuro-matlab interface has been installed into $HOME/Documents/MATLAB/+duneuro.
%
% Arguments:
%
%   config
%
% A DUNEuro configuration object with the mesh, sensor and source model settings.
%
%   driver
%
% A DUNEuro MATLAB driver that passes information to the DUNEuro C++ code.
%

    arguments
        config (1,1) struct
        driver (1,1) duneuro.duneuro_meeg
    end % arguments

    % Compute transfer matrix.

    disp('Computing transfer matrix')
    T = driver.compute_eeg_transfer_matrix(config);
    disp('Transfer matrix computed')

end % function
