%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_update(zef)
%ZEF_UPDATE  Copy GUI table/control values into zef and refresh dependent widgets.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Central GUI sync. The compartment table is the editor for compartment
%   rows. The sensors table is the editor only after zef_build_sensors_table
%   has filled it from zef (sensors_table_synced). Loading a project clears
%   that flag so a startup row cannot rename or hide the loaded set.
%   Mesh and mesh-visualization values live on zef; this function copies
%   them onto widgets. Those widgets write zef only from their own
%   ValueChangedFcn, when the user edits that control.
%
%   zef = zef_update(zef)
%   zef_update          % reads and writes zef in the base workspace
%
%   Input
%     zef  - session struct. If omitted, evalin('base','zef').
%
%   Output
%     zef  - updated session. If nargout is 0, assigned into the base workspace.
%
%   Notes
%     Compartment table column 1 is priority; NaN with column 2 true assigns
%     priority from the row index. Inactive rows have all <tag>_* fields
%     removed. Table rows are then sorted by priority.
%
%   See also zef_start, zef_update_compartment_table_data, zef_get_data_compartment_table.


if nargin == 0
    zef = evalin('base','zef');
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)

        % Project load can call zef_update before the compartment table exists.
        if not(isfield(zef,'h_compartment_table')) || not(isvalid(zef.h_compartment_table))
            return;
        end
        
        zef.aux_field_1 = zef.h_compartment_table.Data;
        
        % Ensure compartment_tags exists before accessing it
        if not(isfield(zef,'compartment_tags')) || not(iscell(zef.compartment_tags))
            zef.compartment_tags = {};
        end
        
        if not(isempty(zef.aux_field_1)) && size(zef.aux_field_1,1) > 0 && size(zef.aux_field_1,2) > 0
            not_isnan_row = find(not(cellfun(@isnan,zef.aux_field_1(:,1))));
            zef.aux_field_1 = zef.aux_field_1(not_isnan_row,:);
            if length(zef.compartment_tags) >= max(not_isnan_row)
                zef.compartment_tags = fliplr(zef.compartment_tags);
                zef.compartment_tags = zef.compartment_tags(not_isnan_row);
                zef.compartment_tags = fliplr(zef.compartment_tags);
            end
        end
        
        if not(isempty(zef.aux_field_1)) && size(zef.aux_field_1,1) > 0
            zef.aux_field_2 = zeros(size(zef.aux_field_1,1),1);
        else
            zef.aux_field_2 = [];
        end
        zef.aux_field_3 = [];
        zef.aux_field_4 = [];

if length(zef.compartment_tags) > 0

        if not(isempty(zef.aux_field_1))
            for zef_i = 1 : size(zef.aux_field_1,1)

                zef_j = length(zef.compartment_tags) - zef_i + 1;

                if not(isnan(zef.aux_field_1{zef_i,1}))
                    eval(['zef.' zef.compartment_tags{zef_j}, '_priority = ' num2str(zef.aux_field_1{zef_i,1}) ';']);
                    zef.aux_field_2(zef_j) = 1;
                    zef.aux_field_3(zef_i) = 1;
                elseif isnan(zef.aux_field_1{zef_i,1}) && zef.aux_field_1{zef_i,2}
                    eval(['zef.' zef.compartment_tags{zef_j}, '_priority = ' num2str(zef_i) ';']);
                    zef.aux_field_2(zef_j) = 1;
                    zef.aux_field_3(zef_i) = 1;
                else
                    zef.aux_field_2(zef_j) = 0;
                    zef.aux_field_3(zef_i) = 0;
                end

                if zef.aux_field_2(zef_j)

                    zef_get_data_compartment_table;

                    zef_n = 0;
                    for zef_k =  1  : size(zef.parameter_profile,1)
                        if isequal(zef.parameter_profile{zef_k,8},'Segmentation') && isequal(zef.parameter_profile{zef_k,6},'On') && isequal(zef.parameter_profile{zef_k,7},'On')
                            zef_n = zef_n + 1;

                            if isequal(zef.parameter_profile{zef_k,3},'Scalar')
                                eval(['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2} '='  num2str(zef.aux_field_1{zef_i, zef.compartment_table_size+zef_n}) ';']);
                            elseif isequal(zef.parameter_profile{zef_k,3},'String')
                                eval(['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2} '='  (zef.aux_field_1{zef_i, zef.compartment_table_size+zef_n}) ';']);
                            end
                        end
                    end
                else
                    zef.aux_field_4 = fieldnames(zef);
                    zef.aux_field_4 = zef.aux_field_4(find(startsWith(zef.aux_field_4,[zef.compartment_tags{zef_j} '_'])));
                    zef = rmfield(zef,zef.aux_field_4);
                end
            end

            zef.compartment_tags = zef.compartment_tags(find(zef.aux_field_2));
            if isfield(zef,'h_compartment_table') && isvalid(zef.h_compartment_table)
                % Temporarily disable callbacks to prevent recursion during programmatic updates
                original_callback = zef.h_compartment_table.CellEditCallback;
                zef.h_compartment_table.CellEditCallback = '';
                zef.h_compartment_table.Data = zef.aux_field_1(find(zef.aux_field_3),:);
                zef.h_compartment_table.CellEditCallback = original_callback;
            end

        end

end

 if isfield(zef,'h_compartment_table') && isvalid(zef.h_compartment_table) && not(isempty(zef.h_compartment_table.Data))
        % Temporarily disable callbacks to prevent recursion during programmatic updates
        original_callback = zef.h_compartment_table.CellEditCallback;
        zef.h_compartment_table.CellEditCallback = '';
        [~, I] = sort(cell2mat(zef.h_compartment_table.Data(:,1)));
        zef.h_compartment_table.Data = zef.h_compartment_table.Data(I,:);
        zef.h_compartment_table.CellEditCallback = original_callback;
        I = size(zef.h_compartment_table.Data,1) - I + 1;
        if length(zef.compartment_tags) >= length(I)
            zef.compartment_tags = zef.compartment_tags(flipud(I));
        end
 end
        % Only update compartment table if handle exists
        if isfield(zef,'h_compartment_table') && isvalid(zef.h_compartment_table)
            zef = zef_update_compartment_table_data(zef);
        end

        %sensors start

        % Check if h_sensors_table exists before accessing
        if isfield(zef,'h_sensors_table') && isvalid(zef.h_sensors_table)
            zef.aux_field_1 = zef.h_sensors_table.Data;
        else
            zef.aux_field_1 = [];
        end
        zef.aux_field_2 = [];
        zef.aux_field_3 = [];
        zef.aux_field_4 = [];
        
        % Ensure sensor_tags exists before accessing it
        if not(isfield(zef,'sensor_tags')) || not(iscell(zef.sensor_tags))
            zef.sensor_tags = {};
        end
        
        % sensors_table_synced is set by zef_build_sensors_table and cleared
        % when a project replaces zef underneath the live table. Until
        % then the table is a startup view and must not be written back.
        % One 8-column row per sensor tag is the Segmentation-tool layout.
        sensors_table_synced = isfield(zef, 'sensors_table_synced') ...
            && isequal(zef.sensors_table_synced, true);
        sensors_table_authoritative = sensors_table_synced ...
            && not(isempty(zef.aux_field_1)) ...
            && size(zef.aux_field_1, 1) == length(zef.sensor_tags) ...
            && size(zef.aux_field_1, 2) >= 8;

        if sensors_table_authoritative
            for zef_i = 1 : size(zef.aux_field_1,1)
                if not(isnan(zef.aux_field_1{zef_i,1})) ||  zef.aux_field_1{zef_i,4}
                    zef.aux_field_2 = [zef.aux_field_2 zef_i];
                    zef.aux_field_3 = [zef.aux_field_3 zef.aux_field_1{zef_i,1}];
                else
                    if zef_i <= length(zef.sensor_tags)
                        zef.aux_field_4 = fieldnames(zef);
                        zef.aux_field_4 = zef.aux_field_4(find(startsWith(zef.aux_field_4,[zef.sensor_tags{zef_i} '_'])));
                        zef = rmfield(zef,zef.aux_field_4);
                    end
                end
            end
            if not(isempty(zef.aux_field_2)) && not(isempty(zef.aux_field_3))
                [~, zef.aux_field_3] = sort(zef.aux_field_3);
                zef.aux_field_2 = zef.aux_field_2(zef.aux_field_3);
                zef.aux_field_3 = cell(0);
                if not(isempty(zef.sensor_tags)) && length(zef.sensor_tags) >= max(zef.aux_field_2)
                    zef.sensor_tags = zef.sensor_tags(zef.aux_field_2);
                end
            end
            if not(isempty(zef.aux_field_2))
                for zef_i = 1 : length(zef.aux_field_2)
                    zef.aux_field_3{zef_i,1} = zef.aux_field_1{zef.aux_field_2(zef_i),1};
                    zef.aux_field_3{zef_i,2} = zef.aux_field_1{zef.aux_field_2(zef_i),2};
                    zef.aux_field_3{zef_i,3} = zef.aux_field_1{zef.aux_field_2(zef_i),3};
                    zef.aux_field_3{zef_i,4} = zef.aux_field_1{zef.aux_field_2(zef_i),4};
                    zef.aux_field_3{zef_i,5} = zef.aux_field_1{zef.aux_field_2(zef_i),5};
                    zef.aux_field_3{zef_i,6} = zef.aux_field_1{zef.aux_field_2(zef_i),6};
                    if zef_i <= length(zef.sensor_tags)
                        zef.aux_field_3{zef_i,7} = eval(['not(isempty(zef.' zef.sensor_tags{zef_i} '_points))']);
                        zef.aux_field_3{zef_i,8} = eval(['not(isempty(zef.' zef.sensor_tags{zef_i} '_directions))']);
                    else
                        zef.aux_field_3{zef_i,7} = false;
                        zef.aux_field_3{zef_i,8} = false;
                    end
                end
                if isfield(zef,'h_sensors_table') && isvalid(zef.h_sensors_table)
                    % Temporarily disable callbacks to prevent recursion during programmatic updates
                    original_callback = zef.h_sensors_table.CellEditCallback;
                    zef.h_sensors_table.CellEditCallback = '';
                    zef.h_sensors_table.Data = zef.aux_field_3;
                    zef.h_sensors_table.CellEditCallback = original_callback;
                end
                for zef_i = 1 : length(zef.sensor_tags)
                    if zef_i <= size(zef.aux_field_3,1)
                        eval(['zef.' zef.sensor_tags{zef_i} '_name = zef.aux_field_3{zef_i,2};']);
                        eval(['zef.' zef.sensor_tags{zef_i} '_imaging_method_name = zef.aux_field_3{zef_i,3};']);
                        eval(['zef.' zef.sensor_tags{zef_i} '_on = zef.aux_field_3{zef_i,4};']);
                        eval(['zef.' zef.sensor_tags{zef_i} '_visible = zef.aux_field_3{zef_i,5};']);
                        eval(['zef.' zef.sensor_tags{zef_i} '_names_visible = zef.aux_field_3{zef_i,6};']);
                    end
                end
            end
        else
            zef = zef_build_sensors_table(zef);
        end

        %sensors end

        if isfield(zef,'h_zeffiro_menu')
            if isvalid(zef.h_zeffiro_menu)
                
                % Check if menu handles exist before accessing
                if isfield(zef,'h_menu_window') && isvalid(zef.h_menu_window)
                    zef.h_aux = allchild(zef.h_menu_window);
                else
                    zef.h_aux = [];
                end

                for zef_i = 1 : length(zef.h_aux)
                    if contains(zef.h_aux(zef_i).Label,'ZEFFIRO Interface:')
                        delete(zef.h_aux(zef_i));
                    end
                end

                if isfield(zef,'h_project_tag') && isvalid(zef.h_project_tag)
                    zef.project_tag = get(zef.h_project_tag,'Value');
                end
                zef.h_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*');
                for zef_i = 1 : length(zef.h_aux)
                    if not(isempty(strfind(zef.h_aux(zef_i).Name,'[')))
                        zef.h_aux(zef_i).Name = strtrim(zef.h_aux(zef_i).Name(1:strfind(zef.h_aux(zef_i).Name,'[')-1));
                    end
                    if not(isempty(zef.project_tag))
                        zef.h_aux(zef_i).Name = [zef.h_aux(zef_i).Name ' [' zef.project_tag ']' ];
                    end
                end

                zef.h_aux = findall(groot, '-property','ZefFig','-or','-property','ZefTool','-not','ZefTool','zef_menu_tool');
                if isfield(zef,'h_windows_open') && not(isempty(zef.h_windows_open))
                    zef.h_windows_open = zef.h_windows_open(find(ismember(zef.h_windows_open,zef.h_aux)));
                    zef.h_windows_open = [zef.h_windows_open ; setdiff(zef.h_aux, zef.h_windows_open)];
                else
                    zef.h_windows_open = zef.h_aux;
                end

                for zef_i = 1 : length(zef.h_windows_open)
                    if ~isvalid(zef.h_windows_open(zef_i))
                        continue
                    end
                    zef_win_name = char(string(zef.h_windows_open(zef_i).Name));
                    if contains(zef_win_name, 'Menu tool') || contains(zef_win_name, ': Task')
                        continue
                    end
                    zef.aux_field_1 = sum(contains(get(zef.h_windows_open(1:zef_i),'Name'),get(zef.h_windows_open(zef_i),'Name')));
                    zef_win_label = zef_ui_window_label(zef_win_name);
                    if zef.aux_field_1 > 1
                        zef_win_label = [zef_win_label ' ' num2str(zef.aux_field_1)];
                    end
                    if isfield(zef,'h_menu_window') && isvalid(zef.h_menu_window)
                        if contains(zef_win_name,'ZEFFIRO Interface: Figure tool')
                            uimenu(zef.h_menu_window,'label',zef_win_label,'callback',['zef_ui_shell(''raise_figure'');']);
                        else
                            uimenu(zef.h_menu_window,'label',zef_win_label,'callback',['figure(evalin(''base'', ''zef.h_windows_open(' num2str(zef_i) ')''))']);
                        end
                    end
                    zef.aux_field_2 = zef.h_windows_open(zef_i).CloseRequestFcn;
                    if (ischar(zef.aux_field_2) || isstring(zef.aux_field_2)) ...
                            && not(contains(char(zef.aux_field_2),'zef_update;'))
                        zef.h_windows_open(zef_i).CloseRequestFcn = [char(zef.aux_field_2) '; zef_update;'];
                    end
                end


                zef = rmfield(zef,{'aux_field_2','h_aux'});

            end
        end

        if isfield(zef,'h_project_information') && isvalid(zef.h_project_information)
            zef.h_project_information.Items = ...
                {['App folder: ' zef.program_path],...
                ['Current path: ' pwd],...
                ['Project file: ' zef.save_file], ...
                ['Project folder: ' zef.save_file_path],...
                ['Project size (MB): ' num2str(round(getfield(whos('zef'),'bytes')/1000000))], ...
                ['Number of windows: ' num2str(length(zef.h_windows_open))]};
        end

        zef = rmfield(zef,{'aux_field_1','aux_field_3','aux_field_4'});

        if isfield(zef,'h_project_notes') && isvalid(zef.h_project_notes)
            if length(zef.h_project_notes.Value) == 1 && isempty(zef.h_project_notes.Value{1})
                zef.h_project_notes.Value = zef.project_notes;
            else
                zef.project_notes = zef.h_project_notes.Value;
            end
        end

        if isempty(zef.sensor_tags)
            zef.current_sensors = [];
            if isfield(zef,'h_sensors_name_table') && isvalid(zef.h_sensors_name_table)
                zef.h_sensors_name_table.Data = [];
            end
            if isfield(zef,'h_parameters_table') && isvalid(zef.h_parameters_table)
                zef.h_parameters_table.Data = [];
            end
        elseif not(ismember(zef.current_sensors,zef.sensor_tags))
            zef.current_sensors = [];
            if isfield(zef,'h_sensors_name_table') && isvalid(zef.h_sensors_name_table)
                zef.h_sensors_name_table.Data = [];
            end
            if isfield(zef,'h_parameters_table') && isvalid(zef.h_parameters_table)
                zef.h_parameters_table.Data = [];
            end
        else
            zef.imaging_method = find(ismember(zef.imaging_method_cell,eval(['zef.' zef.current_sensors '_imaging_method_name'])),1);
            zef = zef_init_sensors_name_table(zef);
        end

        if isfield(zef,'h_profile_name') && isvalid(zef.h_profile_name)
            zef.h_profile_name.Value = zef.profile_name;
        end

        if isfield(zef,'h_zeffiro')
            if isvalid(zef.h_zeffiro)
                zef = zef_update_fig_details(zef);
            end
        end
        zef_toggle_lock_on;
        zef_toggle_lock_sensor_sets_on;
        zef_toggle_lock_sensor_names_on;
        zef_toggle_lock_transforms_on;

        clear zef_i zef_j zef_k zef_n;

    end
    end

    % Model → widgets. User edits of these tools go the other way through
    % ValueChangedFcn (zef_update_mesh_tool / zef_update_mesh_visualization_tool).
    zef = zef_apply_mesh_tool_values(zef);
    zef = zef_apply_mesh_visualization_tool_values(zef);

    if nargout == 0
        assignin('base','zef',zef);
    end

end
