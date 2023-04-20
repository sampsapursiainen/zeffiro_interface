%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%Plot estimated amplitudes as a bar plot
function zef_plot_GMM_amplitudes

%check if the amplitudes exists
if ~evalin('base','isfield(zef.GMM,''amplitudes'')')
    error('Amplitudes are not saved to zef.GMM structure. Please recalculate Gaussian mixature model.');
end

%___ Initial parameters ___
amp = evalin('base','zef.GMM.amplitudes');
end_frame = 1;
f_ind=1;
if iscell(amp)
    end_frame = length(amp);
    f_ind = str2num(evalin('base','zef.GMM.parameters.Values{20}'));
    if isempty(f_ind)
        error('Plotting frame is undefined. Please fill the ''Plot frame'' field.')
    end
    amp = amp{f_ind};
end

comp_ord = evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+1}');
ellip_coloring_type = evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+6}');
ellip_components = str2num(evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+5}'));
if strcmp(comp_ord,'3')
    ellip_num = min(str2num(evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+3}')),length(ellip_components));
else
    ellip_num = str2num(evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+3}'));
end

%___ construct the color array/cell ___
if strcmp(ellip_coloring_type,'1')
    colors = [1,0,0;0,1,0;0,0,1;1,0.5,0;0,1,1;0.5,0,1;1,0.5,0.5;0.4,1,0.8;0.2,0.6,1;1,0.8,0.6;0.8,1,0.6;0.6,1,1;0.8,0.6,1];
else
    colors = evalin('base','zef.GMM.parameters.Values{zef.GMM.meta{2}+7}');
    if ~iscell(colors)
        colors = str2num(colors);
        if size(colors,2) < 3 || size(colors,2) > 3
            colors = reshape(colors',3,[])';
        end
        if size(colors,1) < length(amp)
            colors = [colors; repmat(colors(end,:),length(amp)-size(colors,1),1)];
        end
    else
        last_ind = length(colors);
        zef_j = 0;
        colors_num_aux = nan(1,3);
        while zef_j < last_ind
            zef_j=zef_j + 1;
            if length(colors{zef_j}) > 1
                if isempty(str2num(erase(colors{zef_j},{'[',']'})))
                    colors_aux = colors(1:zef_j-1);
                    for zef_i = 1:length(colors{zef_j})
                        colors_aux{zef_j+zef_i-1} = colors{zef_j}(zef_i);
                    end
                    colors = [colors_aux,colors(zef_j+1:end)];
                    last_ind = last_ind + zef_i - 1;
                    zef_j = zef_j + zef_i - 1;
                else
                    if contains(colors{zef_j},'[')
                        colors_num_aux(1) = str2num(erase(colors{zef_j},'['));
                        first_num_ind = zef_j;
                    elseif contains(colors{zef_j},']')
                        colors_num_aux(3) = str2num(erase(colors{zef_j},']'));
                        last_num_ind = zef_j;
                    else
                        colors_num_aux(2) = str2num(colors{zef_j});
                    end

                    if sum(isnan(colors_num_aux)) == 0
                        colors{first_num_ind} = colors_num_aux;
                        colors(first_num_ind+1:last_num_ind) = [];
                        last_ind = length(colors);
                        colors_num_aux = nan(1,3);
                    end
                end
            end
        end
        if length(colors) < length(amp)
            for zef_j = (last_ind+1):length(amp)
                colors{zef_j} = colors{last_ind};
            end
        end
    end
end

%___ construct the dipole component order ___
max_comps = min(length(amp),ellip_num);
if strcmp(comp_ord,'1')
    order = 1:length(amp);
elseif strcmp(comp_ord,'2')
    [~,order] = sort(amp,'descend');
elseif strcmp(comp_ord,'3')
    order = ellip_components(ismember(ellip_components,intersect(ellip_components,1:length(amp))));
    max_comps = min(length(order),max_comps);
end

%Figure visualization setups
zef_temp_axis = evalin('base','zef.h_axes1');
axes(zef_temp_axis);
cla(zef_temp_axis);
hold(zef_temp_axis,'off');
if ~isempty(findobj(zef_temp_axis.Parent.Children,'Tag','image_details'))
    TimeVars = evalin('base','zef.GMM.time_variables');
    if ~isempty(TimeVars)
        time_string = ['Time: ' num2str(TimeVars.time_1 + TimeVars.time_2/2 + TimeVars.sampling_frequency*(f_ind - 1)*TimeVars.time_3,'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(end_frame) '.'];
    else
        time_string = ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + evalin('base','zef.inv_sampling_frequency')*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(end_frame) '.'];
    end
set(findobj(zef_temp_axis.Parent.Children,'Tag','image_details').Children,'String',time_string)
end
set(zef_temp_axis,'visible','on')
set(zef_temp_axis,'CLim',[0 1])
set(zef_temp_axis,'CameraUpVector', [0 1 0])
set(zef_temp_axis,'CameraViewAngle', 6.6086)
%set(zef_temp_axis,'DataAspectRatio', [1 67.6694 14.4928])
set(zef_temp_axis,'DataAspectRatio', [1 50 5])
set(zef_temp_axis,'DataAspectRatioMode', 'auto')
set(zef_temp_axis,'TickDir','in')
set(zef_temp_axis,'View',[0 90])
set(zef_temp_axis.Colorbar,'visible','off')
rotate3d(zef_temp_axis,'off')

%___ Plot Bars ___
if iscell(colors)
    for i = 1 : max_comps
        bar(order(i),amp(order(i)),0.7,'facecolor',colors{i});
        if i == 1
            hold(zef_temp_axis,'on');
        end
    end
else
    for i = 1 : max_comps
        bar(order(i),amp(order(i)),0.7,'facecolor',colors(i,:));
        if i == 1
            hold(zef_temp_axis,'on');
        end
    end
end
%Set a tick for every source
xticks(zef_temp_axis,1:length(amp));
set(zef_temp_axis,'xlim',[-0.15, (1.15+length(amp))]);
set(zef_temp_axis,'ylim',[0 1.05*max(amp(:))]);
set(zef_temp_axis,'ygrid','on');

%Change plot to proper size
window_ratio = evalin('base','zef.h_zeffiro.Position(3:4)./[0.239, 0.5134];');
screen_resolution = get(0,'screensize');
screen_resolution = screen_resolution(3:4);
zef_temp_axis.Position(3:4)=window_ratio.*[0.1325, 0.281].*screen_resolution;
zef_temp_axis.Position(4)=0.9*zef_temp_axis.Position(4);
zef_temp_axis.Position(2)=window_ratio(2)*0.25*screen_resolution(2);
hold(zef_temp_axis,'off');

clear zef_temp_axis
end
