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

    zef.reconstruction_information = struct;
    zef.reconstruction_information.tag = erase(class(MethodClassObj),["inverse","Inverter","."]);

    waitbar_title = "Building reconstructions with " + zef.reconstruction_information.tag + ".";

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

    [L,n_interp, procFile] = zef_processLeadfields(zef);

    if source_direction_mode == 1  || source_direction_mode == 2
        %indices to order components node-wise:
        s_reorder_ind = reshape((1:n_interp)+(0:n_interp:(2*n_interp))',[],1);
        %indices to order cartesian direction-wise:
        s_back_ind = reshape((1:3:(3*n_interp))'+(0:2),[],1);
        L = L(:,s_reorder_ind);
    end

    % Set up the source space of active brain compartments:

    source_positions = zef.source_positions(procFile.s_ind_0,:);

    if zef.use_gpu && zef.gpu_count > 0
        L = gpuArray(L);
    end

    % The inverse result, which will be post-processed.
    %
    % TODO: can we transpose this cell bc then you can transform it to matrix
    % with cell2mat without much extra effort. Many other softwares uses the
    % matrix format.

    z_inverse = cell(1,MethodClassObj.number_of_frames);
    f_data = zef_getFilteredDataClassObj(zef,MethodClassObj);
    if ismethod(MethodClassObj,'initialize')
        f_data_framed = cell2mat(arrayfun(@(x) zef_getTimeStepClassObj(f_data, x, zef, MethodClassObj), 1:MethodClassObj.number_of_frames, 'UniformOutput', false));
        MethodClassObj = MethodClassObj.initialize(L, f_data_framed);
    end

    tic;

    for f_ind = 1 : MethodClassObj.number_of_frames

        time_val = toc;

        f = zef_getTimeStepClassObj(f_data, f_ind, zef, MethodClassObj);

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
            f_ind/MethodClassObj.number_of_frames, ...
            waitbar_handle, ...
            waitbar_title ...
                + " Time step " ...
                +  int2str(f_ind) ...
                + " of " ...
                + int2str(MethodClassObj.number_of_frames) ...
                + "." ...
                + date_str ...
        );

        % Build this frame's reconstruction.

        [z_vec, MethodClassObj] = MethodClassObj.invert( ...
            f, ...
            L, ...
            procFile, ...
            source_direction_mode, ...
            source_positions, ...
            "use_gpu", zef.use_gpu, ...
            "normalize_data", zef.normalize_data ...
        );

        z_inverse{f_ind} = z_vec;%(s_back_ind);

    end % for

    if ismethod(MethodClassObj,'smoother')
        [z_inverse, MethodClassObj] = MethodClassObj.smoother(z_inverse);
    end

    if ismethod(MethodClassObj,'terminateComputation')
        MethodClassObj = MethodClassObj.terminateComputation;
    end

    if MethodClassObj.normalize_reconstruction
       z_vec = reshape(cell2mat(z_inverse).^2,3,procFile.n_interp,MethodClassObj.number_of_frames);
       z_vec = squeeze(sum(z_vec,1));
       normalization_factor = sqrt(max(z_vec,[],'all'));
       z_vec = cell2mat(z_inverse)/normalization_factor;
       z_inverse = mat2cell(z_vec,size(z_vec,1),ones(1,MethodClassObj.number_of_frames));
    end
    zef.reconstruction = zef_postProcessInverseClassObj(z_inverse, procFile);

    %method specific reconstruction information
    props = properties(MethodClassObj);

    for n = 1:length(props)
        if max(size(MethodClassObj.(props{n}))) < 2 && not(iscell(MethodClassObj.(props{n})))
            zef.reconstruction_information.(props{n}) = MethodClassObj.(props{n});
        end
    end

end % function
