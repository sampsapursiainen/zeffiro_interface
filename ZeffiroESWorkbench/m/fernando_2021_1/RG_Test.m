%% Param_struct & Threshold
param_struct.max_amplitude          = 0.002;
param_struct.tolerance              = [];
param_struct.reg_param              = [];
param_struct.constraint_tolerance   = 1e-3;
param_struct.variable_tolerance     = 1e-3;
param_struct.algorithm              = 'dual-simplex';
%threshold                           = [0.125 0.25];
relative_magnitude = 0.26;

results_general                         = cell(0);
if exist('threshold','var') == 1
    results_threshold                   = cell(0);
    results_active                      = cell(0);
end

%Physiological constant
    cortex_thickness = 4;
    ref_current_density = 0.77;
    ref_vol = cortex_thickness/ref_current_density;

%Folder name generator
    allOneString = sprintf('%.0f,' , zef.inv_synth_source(1,1:3));
    allOneString = allOneString(1:end-1);
    pathname1 = './SP_images';
    pathname2 = allOneString;
    pathname3 = param_struct.algorithm;
    mkdir(fullfile(pathname1,pathname2,pathname3))

%Prelocation of projections
    L_aux = zef.L;
    source_position_index = [];
    source_positions_tes = zef.inv_synth_source(:,1:3);
    for i = 1 : size(source_positions_tes,1)
        [~,aux_index] = min(sqrt(sum((zef.source_positions - source_positions_tes(i,:)).^2,2)));
        source_position_index(i) = aux_index; %#ok<SAGROW>
    end
    clear aux_index
    
    source_directions = zef.inv_synth_source(:,4:6);
    source_magnitude  = zef.inv_synth_source(:,7);
    source_directions = source_directions./sqrt(sum(source_directions.^2,2));
    L_tes_projections = zeros(3*length(source_position_index),size(zef.L,2));
    x_tes_projections = zeros(3*length(source_position_index),1);
    J_x_tes = [];
    for running_index = 1:length(source_position_index)
        J_x_tes = [J_x_tes ; [3*(source_position_index(running_index)-1)+1:3*source_position_index(running_index)]']; %#ok<NBRAK,AGROW>
        for ell_ind = 1 : 3
           %L_tes_projections(running_index,:) = L_tes_projections(running_index,:) + zef.L(3*(source_position_index(running_index)-1)+ell_ind,:)*ref_vol*source_magnitude(running_index).*source_directions(running_index,ell_ind);
           %L_tes_projections(running_index,:) = L_tes_projections(running_index,:) + zef.L(3*(source_position_index(running_index)-1)+ell_ind,:)*ref_vol.*source_directions(running_index,ell_ind);
           L_tes_projections(running_index,:) = L_tes_projections(running_index,:) + zef.L(3*(source_position_index(running_index)-1)+ell_ind,:).*source_directions(running_index,ell_ind);
        end
        x_tes_projections(running_index) = relative_magnitude/ref_vol;
    end
    clear ell_ind
    J_x_tes = setdiff([1:size(zef.L,1)]',J_x_tes);                       %#ok<NBRAK>
    L_tes_projections = [zef.L(J_x_tes,:) ; L_tes_projections];         
    x_tes_projections = [zeros(length(J_x_tes),1) ; x_tes_projections]; 

%%
    % Tolerance & Reg_Param : Begin
    bplot = 0;
    
    param_struct.tolerance_aux  = 10.^(-[2      2 2 3 3 5 5 7 7 9]);
    param_struct.reg_param_aux  =       [0 10.^[2 3 3 5 5 7 7 9 9]];
    param_struct.min_tol        = 1E-9;

    %for w = 1:10
    
    for i = 1:7
            param_struct.tolerance = power(10,-(3+i));    % 1e-4 : 1e-10
        for j = 1:9
        if j == 1
            param_struct.reg_param = [];
        else
            param_struct.reg_param = power(10,(6+j));     % 1e 8 : 1e 15.
        end
        param_struct.active_electrodes = [];
        tic
        [y_tes, residual, flag_val] = zef_optimize_tes_current(L_tes_projections, x_tes_projections, param_struct);
        timer = toc;
        fprintf(['Calculations (' num2str(i) ',' num2str(j) ') are done. ----- Total time: ' num2str(timer) ' seconds.','\n'])
        if ismember(flag_val, [1 3])
            [results_general, vector_field_aux] = source_calculations(results_general, L_aux, i, j, y_tes, residual, flag_val, timer, source_position_index, source_directions, source_magnitude);
            %%%% Threshold aspect
            if exist('threshold','var') == 1
                for t = 1:length(threshold) %length(threshold)
                    [results_threshold, vector_field_aux] = source_calculations(results_threshold, L_aux, i, j, y_tes, residual, flag_val, timer, source_position_index, source_directions, source_magnitude, threshold(t), t);

                    %%%% Active aspect
                    I_active = find(abs(results_threshold.y_tes{i,j,t}));
                    param_struct.active_electrodes = I_active;
                    tic
                    [y_tes_aux_vec, residual_act, flag_val_act] = zef_optimize_tes_current(L_tes_projections, x_tes_projections, param_struct);
                    timer = toc;
                    fprintf(['Calculations (' num2str(i) ',' num2str(j) ') with threshold ' num2str(threshold(t)*100) '%% are done. ----- Total time: ' num2str(timer) ' seconds.','\n'])
                    if ismember(flag_val_act, [1 3])
                        y_tes = zeros(size(zef.L,2),1);
                        y_tes(I_active) = y_tes_aux_vec;
                        [results_active, vector_field_aux] = source_calculations(results_active, L_aux, i, j, y_tes, residual_act, flag_val_act, timer, source_position_index, source_directions, source_magnitude, threshold(t), t, y_tes_aux_vec); 
                    end
                    if ismember(flag_val_act, [-2]) %#ok<NBRAK>
                        [results_active, vector_field_aux] = source_calculations(results_active, L_aux, i, j, y_tes, residual_act, flag_val_act, timer, source_position_index, source_directions, source_magnitude, threshold(t), t, y_tes_aux_vec);
                    end
                end
            end
        end
        if ismember(flag_val, [-2]) %#ok<NBRAK>
            [results_general, ~] = source_calculations(results_general, L_aux, i, j, y_tes, residual, flag_val, timer, source_position_index, source_directions, source_magnitude);
        end
        
        %percentage = 0.25;
        %fprintf(['Active channels above ' num2str(percentage*100) '%% in General:         ' num2str(length(find(abs(results_general.y_tes{1,1})  >= percentage*param_struct.max_amplitude))),'\n' ]);
        %fprintf(['Active channels above ' num2str(percentage*100) '%% in Active:          ' num2str(length(find(abs(results_active.y_tes{1,1})  >= percentage*param_struct.max_amplitude))),'\n' ]);
        
        if bplot == 1
        %Barplotting
            t = 1;
            b = figure(w+200);
            b.Position = [493 752 2068 570];
            %sgtitle({'Somatosensory cortex','Montage comparison'});
            p = bar(results_general.y_tes{w,1}*1000,0.7);
            p.FaceColor = '[0.85 0.85 0.85]';
            p.LineWidth = 0.1; hold on;

            p_max = max(get(p,'ydata'))*1.15;
            %if exist('threshold','var') == 1
            p_min = -p_max;%min(get(p,'ydata'));

            set(gca,'ylim',1.15*[p_min p_max]);
            set(gca,'LineWidth',1.5)
            set(gca,'FontSize', 16)
            
            if exist('threshold','var') == 1
                p = bar(results_active.y_tes{w,1,t}*1000,0.3);
                p.FaceColor = '[0.2 0.2 0.2]';
                p.LineWidth = 0.1;
                set(gca,'ylim',1.15*[p_min p_max]);
                set(gca,'Xlim',[0 129]);
                set(gca,'LineWidth',1.5)
                set(gca,'FontSize', 16)
             end
         
            hold on;
            plot(xlim,[ 2  2],'LineWidth',1.5,'Color','r','LineStyle','--')
            plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
            hold off;

            xlabel('Electrode Channel'); ylabel('Ampere (mA)');
            grid on; %grid minor;
            if exist('threshold','var') == 1
                legend('General',['Active ' num2str(threshold(t)*100) '% (Regularized)' ],'Location','Northwest');    
            else
                legend('General','Location','Northwest');    
                
            end
            
            pbaspect([4 1 4])
            clear p
            
            y_tes_norm_general = [];
            y_tes_norm_general = [y_tes_norm_general results_general.y_tes_norm{1,1}]; %#ok<AGROW>
            if exist('threshold','var') == 1
                y_tes_norm_active = [];
                y_tes_norm_active  = [y_tes_norm_active results_active.y_tes_norm{1,1}];   %#ok<AGROW>
            end
            figure(1000); clf; plot(y_tes_norm_general, 'b'); hold on
            if exist('threshold','var') == 1
                               plot(y_tes_norm_active, 'r'); hold off
            end
            drawnow;
            hold off
        end
        end
    end

    %Minimal Peaks
    [results_general]     = source_minimal(results_general);
    if exist('threshold','var') == 1
        [results_threshold] = source_minimal(results_threshold, threshold);
        [results_active]    = source_minimal(results_active, threshold);
        fprintf(['Calculations has ended. ----- Total time: ' num2str( sum([results_general.elapsed_time{:}]) + sum([results_active.elapsed_time{:}]) ) ' seconds.','\n'])
    else
        fprintf(['Calculations has ended. ----- Total time: ' num2str( sum([results_general.elapsed_time{:}]) ) ' seconds.','\n'])
    end
%%
%Save the workspace (.mat file)
    fprintf(['End of calculations on source position (' allOneString ') using (' pathname3 ') method','\n'])
    filename = fullfile(pathname1,pathname2,pathname3,['tes_results_(' pathname2 ')_with_(' pathname3 ')_(2mA)_and_(source_2.6nAm)_Murakama_and_Okada_method.mat']);
    %save(filename,'results_general','results_threshold','results_active','source_directions','source_magnitude', 'source_position_index','source_positions_tes','threshold','L_tes_projections','x_tes_projections','ref_vol','L_aux');
    fprintf(['A .mat file with the results from (' allOneString ') using (' pathname3 ') method has been generated','\n'])
%% Run this to get the colorbars (y_tes)
for w = 1:10
    close(findobj('type','figure','number',w))
end
clear w A B C t

t = 0;
if t >= 1
    A = cell2mat(results_active.y_tes_norm(:,:,t)); 
    B = cell2mat(results_active.residual_norm(:,:,t));
else
    A = cell2mat(results_general.y_tes_norm(:,:));
    B = cell2mat(results_general.residual_norm(:,:));
end
    C = (B/max(abs(B(:)))) + A/max(abs(A(:)));

b = figure(5);
    b.Position= [050 566 837 541];
    imagesc(A); colorbar; title('y_t_e_s norm');
    colormap('bone');
    grid on; xlabel('Regularization parameter'); ylabel('Termination tolerance');
    h = colorbar; set(h, 'ylim', [min(A,[],'all') max(A,[],'all')]);
    set(gca, 'XTick', [1:9]);
    set(gca, 'XTicklabel', {'0','1e^{2}','1e^{3}','1e^{4}','1e^{5}','1e^{6}','1e^{7}','1e^{8}', '1e^{9}'});
    xtickangle(45);
    set(gca, 'YTick', [1:7]);
    set(gca, 'YTicklabel', {'1e^{-4}','1e^{-5}','1e^{-6}','1e^{-7}','1e^{-8}','1e^{-9}','1e^{-10}'});
    set(gca,'FontSize', 16)
    pbaspect([1 1 1]);

b = figure(6);
    b.Position= [900 566 837 541];
    imagesc(B); colorbar; title('residual norm');
    colormap('bone');
    grid on; xlabel('Regularization parameter'); ylabel('Termination tolerance');
    h = colorbar;
    set(h, 'ylim', [min(B,[],'all') max(B,[],'all')]);
    h.Ruler.Exponent=4;
    set(gca, 'XTick', [1:9]);
    set(gca, 'XTicklabel', {'0','1e^{2}','1e^{3}','1e^{4}','1e^{5}','1e^{6}','1e^{7}','1e^{8}', '1e^{9}'});
    xtickangle(45);
    set(gca, 'YTick', [1:7]);
    set(gca, 'YTicklabel', {'1e^{-4}','1e^{-5}','1e^{-6}','1e^{-7}','1e^{-8}','1e^{-9}','1e^{-10}'});
    set(gca,'FontSize', 16)
    pbaspect([1 1 1]);

b = figure(7);
    b.Position= [1800 566 837 541];
    imagesc(C); colorbar; title('max(abs(residual norm) + max(abs(y_t_e_s)');
    colormap('bone');
    grid on; xlabel('Regularization parameter'); ylabel('Termination tolerance');
    h = colorbar; set(h, 'ylim', [min(C,[],'all') max(C,[],'all')]);
    set(gca, 'XTick', [1:9]);
    set(gca, 'XTicklabel', {'0','1e^{2}','1e^{3}','1e^{4}','1e^{5}','1e^{6}','1e^{7}','1e^{8}', '1e^{9}'});
    xtickangle(45);
    set(gca, 'YTick', [1:7]);
    set(gca, 'YTicklabel', {'1e^{-4}','1e^{-5}','1e^{-6}','1e^{-7}','1e^{-8}','1e^{-9}','1e^{-10}'});
    set(gca,'FontSize', 16)
    pbaspect([1 1 1]);

hold on;
if t >= 1
    plot(results_active.min_value(t,3),results_active.min_value(t,2),'go','MarkerFaceColor','g','MarkerSize',12);
else
    plot(results_general.min_value(1,3),results_general.min_value(1,2),'go','MarkerFaceColor','g','MarkerSize',12);
end
hold off;
legend('Minimal cost','Location','southwest');
%% barplot gen (non-reg)
b = figure(10);
b.Position = [493 752 2068 570];
    %sgtitle({'Somatosensory cortex','Non-regularized results'});
    p = bar(results_general.y_tes{results_general.min_value(1,2),1}*1000,0.7);
    p.FaceColor = '[0.3 0.3 0.3]';
    p.LineWidth = 0.1;
    
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    
    set(gca,'ylim',1.15*[p_min p_max]);
    xlabel('Electrode Channel');
    ylabel('Ampere (mA)');
    set(gca,'Xlim',[0 129])
    set(gca,'FontSize', 16)
    set(gca,'LineWidth',1.5)
    hold on;
    plot(xlim,[ 2  2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    
grid on; %grid minor;
%legend('Results general','Results threshold','Location','Northwest');
pbaspect([4 1 4])
clear p
%% barplot gen (reg)
b = figure(12);
b.Position = [493 752 2068 570];

    %sgtitle({'Somatosensory cortex','Regularized results (general)'});
    p = bar(results_general.y_tes{1,1,1}*1000,0.7);
    p.FaceColor = '[0.3 0.3 0.3]';
    p.LineWidth = 0.1;
    
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'Xlim',[0 129])
    set(gca,'FontSize', 16)
    set(gca,'LineWidth',1.5)
    hold on; plot(xlim,[2 2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    
xlabel('Electrode Channel'); ylabel('Ampere (mA)');
set(gca,'Xlim',[0 129])
grid on; %grid minor;
%legend('Results general','Results threshold','Results active','Location','Northwest');
%pbaspect([4 1 4])
clear p
%% barplot threshold
t = 1;
b = figure(12);
b.Position = [493 752 2068 570];
    %sgtitle({'Somatosensory cortex','Results threshold (10%)'});
    p = bar(results_threshold.y_tes{results_threshold.min_value(t,2),results_threshold.min_value(t,3),t}*1000,0.7);
    p.FaceColor = '[0.4 0.4 0.4]';
    p.LineWidth = 0.1;
    
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'Xlim',[0 129])
    set(gca,'FontSize', 16)
    set(gca,'LineWidth',1.5)
    hold on;
    plot(xlim,[2 2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    
xlabel('Electrode Channel'); ylabel('Ampere (mA)');
grid on; %grid minor;
%legend('Results general','Results threshold','Results active','Location','Northwest');
pbaspect([4 1 4])
clear p
%% barplot active
t = 2;
b = figure(13);
b.Position = [493 752 2068 570];
    %sgtitle({'Somatosensory cortex','Electrode montage reduction (active)'});
    p = bar(results_active.y_tes{results_active.min_value(t,2),results_active.min_value(t,3),t}*1000,0.7);
    p.FaceColor = '[0.2 0.2 0.2]';
    p.LineWidth = 0.1;
    
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'Xlim',[0 129])
    set(gca,'FontSize', 16)
    set(gca,'LineWidth',1.5)
    hold on; plot(xlim,[2 2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    xlabel('Electrode Channel'); ylabel('Ampere (mA)');
grid on; %grid minor;
%legend('Results general','Results threshold','Results active','Location','Northwest');
pbaspect([4 1 4])
clear p2.6000 
%% barplot gen (reg) vs act (reg)
t = 1;
b = figure(15);
b.Position = [493 752 2068 570];
    %sgtitle({'Somatosensory cortex','Montage comparison'});
    p = bar(results_general.y_tes{1,1}*1000,0.7);
    p.FaceColor = '[0.85 0.85 0.85]';
    p.LineWidth = 0.1; hold on;
    
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'LineWidth',1.5)
    set(gca,'FontSize', 16)

    p = bar(results_active.y_tes{1,1}*1000,0.3);
    p.FaceColor = '[0.2 0.2 0.2]';
    p.LineWidth = 0.1;
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'Xlim',[0 129]);
    set(gca,'LineWidth',1.5)
    set(gca,'FontSize', 16)
    
    hold on;
    plot(xlim,[2 2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    hold off;
    
xlabel('Electrode Channel'); ylabel('Ampere (mA)');
grid on; %grid minor;
legend('General',['Active ' num2str(threshold(t)*100) '% (Regularized)' ],'Location','Northwest');
pbaspect([4 1 4])
clear p
%% barplot non-reg vs reg
b = figure(65);
b.Position = [493 752 2068 570];

t = 0;
if t >= 1 % Gen or Act ?
    p = bar(results_active.y_tes{results_active.min_value(t,2),1,t}*1000,0.7);
    else
    p = bar(results_general.y_tes{results_general.min_value(1,2),1}*1000,0.7);
end
    %sgtitle({'Somatosensory cortex','Regularization comparison'});
    %p = bar(results_general.y_tes{5,1,1}*1000,0.7);
    p.FaceColor = '[0.8 0.8 0.8]';
    p.LineWidth = 0.1; hold on;
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    set(gca,'ylim',1.15*[p_min p_max]);
    set(gca,'LineWidth',1.5)
    set(gca,'FontSize', 16)
if t >= 1
    p = bar(results_active.y_tes{results_active.min_value(t,2),results_active.min_value(t,3),t}*1000,0.3);
else
    p = bar(results_general.y_tes{results_general.min_value(1,2),1}*1000,0.3);
    %p = bar(results_general.y_tes{2,5}*1000,0.3);
end
    p.FaceColor = '[0.2 0.2 0.2]';
    %p = bar(results_general.y_tes{5,5,1}*1000,0.7);
    p.LineWidth = 0.1;
    set(gca,'Xlim',[0 129]);
    set(gca,'LineWidth',1.5)
    p_max = max(get(p,'ydata'))*1.15;
    p_min = -p_max;%min(get(p,'ydata'));
    %set(gca,'ylim',1.15*[p_min p_max]);
    plot(xlim,[2 2],'LineWidth',1.5,'Color','r','LineStyle','--')
    plot(xlim,[-2 -2],'LineWidth',1.5,'Color','r','LineStyle','--')
    hold off;
    
xlabel('Electrode Channel'); ylabel('Ampere (mA)');
grid on; %grid minor;
if t >= 1
    legend(['Active ' num2str(threshold(t)*100) '% (Non-regularized) '],['Active ' num2str(threshold(t)*100) '% (Regularized)'],'Location','Northwest');
else
    legend('General (Non-regularized)','General (Regularized)','Location','Northwest');
end

pbaspect([4 1 4])
clear p
%% Loading the latest data
allOneString = ['-15,-90,20'];
load(['SP_images/' allOneString '/dual-simplex/tes_results_(' allOneString ')_with_(dual-simplex)_(2mA)_and_(source_2.6nAm)_Murakama_and_Okada_method.mat']);
%% Number of NNZ 
t=1;
NoLGenReg = nnz(results_general.y_tes{1,1})
NoLThr    = nnz(results_threshold.y_tes{1,1,t})
NoLAct    = nnz(results_active.y_tes{1,1,t})
clear NoLGenReg NoLThr NoLAct