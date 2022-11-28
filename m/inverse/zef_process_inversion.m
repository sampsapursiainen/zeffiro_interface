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

    % Initialize the waiting bar

    if isprop(MethodClassObj,'tag')

        if ischar(MethodClassObj.tag)

            waitbar_handle = zef_waitbar(0,[MethodClassObj.tag,' Reconstruction.']);

        else

            waitbar_handle = zef_waitbar(0,MethodClassObj.tag + " Reconstruction.");

        end

    else

        waitbar_handle = zef_waitbar(0,'Reconstruction.');

    end

    % A cleanup object that automatically closes the waitbar, if there is an
    % interruption with Ctrl + C or when this function exits.

    cleanup_fn = @(h) close(h);

    cleanup_obj = onCleanup(@() cleanup_fn(waitbar_handle));

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

    %set up the source space of selected brain compartments:

    source_positions = zef.source_positions(procFile.s_ind_0,:);

    if zef.use_gpu && zef.gpu_count > 0
        L = gpuArray(L);
    end

    if zef.number_of_frames > 1
        z_inverse = cell(zef.number_of_frames,1);   %can we transpose this cell bc then you can transform it to matrix with cell2mat without much extra effort. Many other softwares uses the matrix format.
    else
        zef.number_of_frames = 1;
    end

    f_data = zef_getFilteredData(zef);

    tic;

    for f_ind = 1 : zef.number_of_frames

        time_val = toc;

        if f_ind > 1;
            date_str = datestr(datevec(now+(zef.number_of_frames/(f_ind-1) - 1)*time_val/86400));
        end

        f = zef_getTimeStep(f_data, f_ind, zef);

        if f_ind == 1
            zef_waitbar(0,waitbar_handle,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '.']);
        end

        if zef.use_gpu && zef.gpu_count > 0
            f = gpuArray(f);
        end

        % BE MORE INTELLIGENT WITH THIS:

        if f_ind > 1;
            zef_waitbar(f_ind/zef.number_of_frames,waitbar_handle,['Step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '. Ready: ' date_str '.' ]);
        else
            zef_waitbar(f_ind/zef.number_of_frames,waitbar_handle,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '.' ]);
        end

        %SETVI TÄMÄN MUOTOILU:
        %nargin(inverse)
        %nargout(inverse)

        metaInformation = eval(['?',class(MethodClassObj)]);   %If someone figure out a better way to have "?inverse.ParticularMethod" be my guest

        N = length(metaInformation.MethodList);

        for n = 1:(N+1)

            if strcmp(metaInformation.MethodList(n).Name,'invert')

                num_inputs = length(metaInformation.MethodList(n).InputNames);      %can/could we use the actual names of inputs to declare correct variables in correct order?
                output_names = metaInformation.MethodList(n).OutputNames;
                num_outputs = length(output_names);
                break;

            elseif n > N

                error('Class object does not have a method named ''invert''.')

            end

        end % for

        if num_outputs == 1

            switch num_inputs

                case 4
                    z_vec = MethodClassObj.invert(f,L);
                case 5
                    z_vec = MethodClassObj.invert(f,L,procFile);
                case 6
                    z_vec = MethodClassObj.invert(f,L,procFile,source_direction_mode);
                case 7
                    z_vec = MethodClassObj.invert(f,L,procFile,source_direction_mode,source_positions);
            end

        else % multiple outputs

            outputs = cell(1,num_outputs);

            switch num_inputs
                case 3
                    [outputs{:}] = MethodClassObj.invert(f,L);
                case 4
                    [outputs{:}] = MethodClassObj.invert(f,L,procFile);
                case 5
                    [outputs{:}] = MethodClassObj.invert(f,L,procFile,source_direction_mode);
                case 6
                    [outputs{:}] = MethodClassObj.invert(f,L,procFile,source_direction_mode,source_positions);
            end

            z_vec = outputs{1};     %first one must be the reconstruction itself

            for n = 2:num_outputs

                if strcmp(output_names{n},'self')
                    MethodClassObj = outputs{n};
                else
                    %save on the ZI bc I don't know how else to deal with them
                    zef.(output_names{n}) = outputs{n};
                end

            end

        end % if

        z_inverse{f_ind} = z_vec(s_back_ind);

    end % for

    zef.reconstruction = zef_postProcessInverse(z_inverse, procFile);

end % function
