function [zef,MethodClassObj] = zef_process_inversion(zef,MethodClassObj)

    %
    % zef_process_inversion
    %
    % A function that processes a given inverter, calling its inverse method
    % for a number of frames and producing a set of reconstructions. The
    % inverse methods require the following inputs:
    %
    % - self
    % - waitbar_handle
    % - frame
    % - L
    % - procFile
    % - source_direction_mode
    % - source_positions
    %

    arguments

        zef (1,1) struct

        MethodClassObj (1,1) { inverse.CommonInverseParameters.isAnInverter }

    end

    % Initialize the waitbar with a cleanup object that automatically closes
    % the waitbar, if there is an interruption with Ctrl + C or when this
    % function exits.

    waitbar_title = "Building reconstructions with " + class(MethodClassObj) + ".";

    waitbar_handle = zef_waitbar(0, waitbar_title);

    cleanup_fn = @(h) close(h);

    cleanup_obj = onCleanup(@() cleanup_fn(waitbar_handle));

    % Get needed parameters from zef.

    source_direction_mode = zef.source_direction_mode;

    %no method use this?:
    %source_directions = eval('zef.source_directions');

    %these ok for now
    zef.reconstruction_information.source_direction_mode = zef.source_direction_mode;
    zef.reconstruction_information.source_directions = zef.source_directions;

    %method specific information
    props = properties(MethodClassObj);

    for n = 1:length(props)
        zef.reconstruction_information.(props{n}) = MethodClassObj.(props{n});
    end

    [L,n_interp, procFile] = zef_processLeadfields(zef);

    if source_direction_mode == 1  || source_direction_mode == 2
        %indices to order components node-wise:
        s_reorder_ind = reshape((1:n_interp)+(0:n_interp:(2*n_interp))',[],1);
        %indices to order cartesian direction-wise:
        s_back_ind = reshape((1:3:(3*n_interp))'+(0:2),[],1);
        L = L(:,s_reorder_ind);
    end

    % Set up the source space of selected brain compartments:

    source_positions = zef.source_positions(procFile.s_ind_0,:);

    if zef.use_gpu && zef.gpu_count > 0
        L = gpuArray(L);
    end

    % The inverse result, which will be post-processed.
    %
    % TODO: can we transpose this cell bc then you can transform it to matrix
    % with cell2mat without much extra effort. Many other softwares uses the
    % matrix format.

    z_inverse = cell(zef.number_of_frames,1);

    f_data = zef_getFilteredData(zef);

    tic;

    for f_ind = 1 : MethodClassObj.number_of_frames

        time_val = toc;

        f = zef_getTimeStep(f_data, f_ind, zef);

        if zef.use_gpu && zef.gpu_count > 0
            f = gpuArray(f);
        end

        % Update waitbar.

        if f_ind > 1
            date_str = " Ready: " + datestr(datevec(now+(MethodClassObj.number_of_frames/(f_ind-1) - 1)*time_val/86400));
        else
            date_str = "";
        end

        zef_waitbar( ...
            f_ind/zef.number_of_frames, ...
            waitbar_handle, ...
            waitbar_title ...
                + " Time step " ...
                +  int2str(f_ind) ...
                + " of " ...
                + int2str(zef.number_of_frames) ...
                + "." ...
                + date_str ...
        );

        % Build this frame's reconstruction.

        z_vec = MethodClassObj.invert( ...
            f, ...
            L, ...
            procFile, ...
            source_direction_mode, ...
            source_positions, ...
            "use_gpu", zef.use_gpu ...
        );

        z_inverse{f_ind} = z_vec(s_back_ind);

    end % for

    zef.reconstruction = zef_postProcessInverse(z_inverse, procFile);

end % function
