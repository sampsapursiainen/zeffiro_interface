function [h_current_ES, h_current_coords] = zef_ES_plot_current_pattern
%% clear Axes handle
if isfield(evalin('base','zef'),'h_current_ES')
    evalin('base', 'delete(zef.h_current_ES)')
end
%% Variables and parameter setup
switch evalin('base','zef.ES_search_method')
    case {1,2}
        switch evalin('base','zef.ES_search_type')
            case 1
                y_ES = evalin('base','zef.y_ES_single.y_ES');
            case 2
                [~,sr, sc] = zef_ES_objective_function;
                if isempty(sr)
                    sr = 1;
                end
                if isempty(sc)
                    sc = 1;
                end
                y_ES = evalin('base','zef.y_ES_interval.y_ES');
                y_ES = cell2mat(y_ES(sr,sc));
        end
    case 3
        y_ES = evalin('base','zef.y_ES_4x1.y_ES');
end
nodes   = evalin('base','zef.nodes');
sensors = evalin('base','zef.sensors');
%% Sensors attachment
if evalin('base','zef.attach_electrodes')
    sensors(:,4) = 0;
    I_aux = find(sensors(:,5)~=0);
    sensors(I_aux,5) = 1; %#ok<*FNDSB>
    sensors = zef_attach_sensors_volume(sensors);
    unique_sensors_point_like = unique(sensors(:,1));
    sensors_point_like = zeros(length(unique_sensors_point_like),3);
    for spl_ind = 1:length(unique_sensors_point_like)
        spl_aux_ind = find(sensors(:,1)==unique_sensors_point_like(spl_ind));
        sensors_point_like(spl_ind,:) = mean(nodes(sensors(spl_aux_ind,2),:),1);
    end
    sensors = sensors_point_like;
end
%% Sphere generation and allocation of color indexes
aux_scale_val = 100/max(sqrt(sum((sensors(:,1:3) - repmat(mean(sensors(:,1:3)),size(sensors,1),1)).^2,2)));
[X_s, Y_s, Z_s] = sphere(20);
sphere_scale = evalin('base','zef.sensors_visual_size')*aux_scale_val;
X_s = sphere_scale*X_s;
Y_s = sphere_scale*Y_s;
Z_s = sphere_scale*Z_s;

colormap_size = 4096;
colortune_param = evalin('base','zef.colortune_param');

if evalin('base','zef.ES_inv_colormap') == 1
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
    colormap_vec_aux = [([20/colortune_param*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ([15/colortune_param*[1: c_aux_1] 15*(1-2/3)/(1-2*colortune_param/3)*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*(1-2/3)/(1-2*colortune_param/3)*[1:c_aux_2-c_aux_1] 6/colortune_param*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 7.5/colortune_param*[1:colormap_size-c_aux_2]])]; %#ok<*NBRAK>
    ES_colormap_vec = zeros(3,size(colormap_vec_aux,2));
    ES_colormap_vec = ES_colormap_vec + 0.52*[50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:)];
    ES_colormap_vec = ES_colormap_vec + 0.5*[85*colormap_vec_aux(3,:) ; 197*colormap_vec_aux(3,:) ; 217*colormap_vec_aux(3,:)];
    ES_colormap_vec = ES_colormap_vec + 0.1*[2*colormap_vec_aux(2,:) ; 118*colormap_vec_aux(2,:) ; 132*colormap_vec_aux(2,:)];
    ES_colormap_vec = ES_colormap_vec + [203*colormap_vec_aux(4,:) ; 203*colormap_vec_aux(4,:) ; 100*colormap_vec_aux(4,:)];
    clear colormap_vec_aux;
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = ES_colormap_vec(:,1:3);
elseif evalin('base','zef.ES_inv_colormap') == 2
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
    ES_colormap_vec = zeros(3,colormap_size);
    ES_colormap_vec(1,:) =10*([colormap_size:-1:1]/colormap_size);
    ES_colormap_vec(2,:) = [10*(3*(1  - 1/3)/(2*(1- colortune_param/3)))*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
    ES_colormap_vec(3,:) = [10*((3/colortune_param)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
    ES_colormap_vec = ES_colormap_vec(:,1:3);
    ES_colormap_vec = ES_colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
    ES_colormap_vec = ES_colormap_vec/max(ES_colormap_vec(:));
elseif evalin('base','zef.ES_inv_colormap') == 3
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
    ES_colormap_vec = zeros(3,colormap_size);
    ES_colormap_vec(2,:) = 10*([colormap_size:-1:1]/colormap_size);
    ES_colormap_vec(1,:) = [10*(3*(1  - 1/3)/(2*(1- colortune_param/3)))*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
    ES_colormap_vec(3,:) = [10*((3/colortune_param)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
    %colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
    ES_colormap_vec = ES_colormap_vec(:,1:3);
    ES_colormap_vec = ES_colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
    ES_colormap_vec = ES_colormap_vec/max(ES_colormap_vec(:));
elseif evalin('base','zef.ES_inv_colormap') == 4
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
    ES_colormap_vec = zeros(3,colormap_size);
    ES_colormap_vec(3,:) = 10*([colormap_size:-1:1]/colormap_size);
    ES_colormap_vec(2,:) = [10*(3*(1  - 1/3)/(2*(1- colortune_param/3)))*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
    ES_colormap_vec(1,:) = [10*((3/colortune_param)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
    %colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
    ES_colormap_vec = ES_colormap_vec(:,1:3);
    ES_colormap_vec = ES_colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
    ES_colormap_vec = ES_colormap_vec/max(ES_colormap_vec(:));
elseif evalin('base','zef.ES_inv_colormap') == 5
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size - colortune_param*colormap_size/3);
    ES_colormap_vec = [([20*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1)]); ([15*(colormap_size/3)*[1: c_aux_1]/c_aux_1 15*(colormap_size/3)*[c_aux_2-c_aux_1:-1:1]/(c_aux_2-c_aux_1) zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*(colormap_size/3)*[1:c_aux_2-c_aux_1]/(c_aux_2-c_aux_1) 6*(colormap_size/3)*[colormap_size-c_aux_2:-1:1]/(colormap_size-c_aux_2)]);([zeros(1,c_aux_2) 7.5*(colormap_size/3)*[1:colormap_size-c_aux_2]/(colormap_size-c_aux_2)])];
    ES_colormap_vec([1 2],:) = ES_colormap_vec([2 1],:);
    ES_colormap_vec(1,:) = ES_colormap_vec(1,:) + ES_colormap_vec(2,:);
    ES_colormap_vec(3,:) = ES_colormap_vec(4,:) + ES_colormap_vec(3,:);
    ES_colormap_vec(2,:) = ES_colormap_vec(4,:) + ES_colormap_vec(2,:);
    ES_colormap_vec(1,:) = ES_colormap_vec(4,:) + ES_colormap_vec(1,:);
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
    ES_colormap_vec = ES_colormap_vec(:,1:3);
elseif evalin('base','zef.ES_inv_colormap') == 6
    c_aux_1 = floor(colortune_param*colormap_size/3);
    c_aux_2 = floor(colormap_size - colortune_param*colormap_size/3);
    c_aux_3 = floor(colormap_size/2);
    ES_colormap_vec = [([20*[c_aux_3:-1:1] zeros(1,colormap_size-c_aux_3)]); ([15*(colormap_size/3)*[1: c_aux_1]/c_aux_1 15*(colormap_size/3)*[c_aux_2-c_aux_1:-1:1]/(c_aux_2-c_aux_1) zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 7*(colormap_size/3)*[1:c_aux_2-c_aux_1]/(c_aux_2-c_aux_1) 7*(colormap_size/3)*[colormap_size-c_aux_2:-1:1]/(colormap_size-c_aux_2)]);([zeros(1,c_aux_2) 10.5*(colormap_size/3)*[1:colormap_size-c_aux_2]/(colormap_size-c_aux_2)])];
    ES_colormap_vec(3,:) = ES_colormap_vec(4,:) + ES_colormap_vec(3,:);
    ES_colormap_vec(2,:) = ES_colormap_vec(4,:) + ES_colormap_vec(2,:);
    ES_colormap_vec(1,:) = ES_colormap_vec(4,:) + ES_colormap_vec(1,:);
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
    ES_colormap_vec = ES_colormap_vec(:,1:3);
elseif evalin('base','zef.ES_inv_colormap') == 7
    c_aux_1 = floor(colormap_size - colortune_param*colormap_size/2);
    ES_colormap_vec = [10*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); 3*(colormap_size/3)*[1: c_aux_1]/c_aux_1 3*(colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); zeros(1,c_aux_1) 3.8*(colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size-c_aux_1)];
    ES_colormap_vec([1 2],:) = ES_colormap_vec([2 1],:);
    ES_colormap_vec(1,:) = ES_colormap_vec(1,:) + ES_colormap_vec(2,:);
    ES_colormap_vec(1,:) = ES_colormap_vec(3,:) + ES_colormap_vec(1,:);
    ES_colormap_vec(2,:) = ES_colormap_vec(3,:) + ES_colormap_vec(2,:);
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
elseif evalin('base','zef.ES_inv_colormap') == 8
    c_aux_1 = floor(colormap_size - colortune_param*colormap_size/2);
    ES_colormap_vec = [10*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); 3*(colormap_size/3)*[1: c_aux_1]/c_aux_1 3*(colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); zeros(1,c_aux_1) 3.8*(colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size-c_aux_1)];
    ES_colormap_vec([2 3],:) = ES_colormap_vec([3 2],:);
    ES_colormap_vec(1,:) = ES_colormap_vec(2,:) + ES_colormap_vec(1,:);
    ES_colormap_vec(3,:) = ES_colormap_vec(2,:) + ES_colormap_vec(3,:);
    ES_colormap_vec = ES_colormap_vec+100;
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
elseif evalin('base','zef.ES_inv_colormap') == 9
    c_aux_1 = floor(colormap_size - colortune_param*colormap_size/2);
    ES_colormap_vec = [10*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); 2*(colormap_size/3)*[1: c_aux_1]/c_aux_1 2*(colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); zeros(1,c_aux_1) 3.8*(colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size-c_aux_1)];
    ES_colormap_vec(1,:) = ES_colormap_vec(3,:) + ES_colormap_vec(1,:);
    ES_colormap_vec(2,:) = ES_colormap_vec(3,:) + ES_colormap_vec(2,:);
    ES_colormap_vec = ES_colormap_vec+100;
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
elseif evalin('base','zef.ES_inv_colormap') == 10
    c_aux_1         = floor(colormap_size - colortune_param*colormap_size/2);
    ES_colormap_vec = [10*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); 8*(colormap_size/3)*[1: c_aux_1]/c_aux_1 8*(colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); zeros(1,c_aux_1) 5*(colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size-c_aux_1)];
    ES_colormap_vec = ES_colormap_vec+100;
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = flipud(ES_colormap_vec);
elseif evalin('base','zef.ES_inv_colormap') == 11
    ES_colormap_vec = [(colormap_size/5)^3 + (colormap_size)^2*[1 : colormap_size] ; (colormap_size/2)^3 + ((colormap_size)/2)*[1:colormap_size].^2 ; ...
        (0.7*colormap_size)^3+(0.5*colormap_size)^2*[1:colormap_size]];
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = ES_colormap_vec.^(colortune_param);
elseif evalin('base','zef.ES_inv_colormap') == 12
    ES_colormap_vec = [[1:colormap_size] ; 0.5*[1:colormap_size] ; 0.5*[colormap_size:-1:1] ];
    ES_colormap_vec = ES_colormap_vec + 1;
    ES_colormap_vec = ES_colormap_vec'/max(ES_colormap_vec(:));
    ES_colormap_vec = ES_colormap_vec.^(colortune_param);
elseif evalin('base','zef.ES_inv_colormap') == 13
    ES_colormap_vec = evalin('base','zef.parcellation_colormap');
    colormap_size = size(ES_colormap_vec,1);
end

axes(evalin('base','zef.h_axes1'));
hold on;

max_colorbar_value = evalin('base','zef.ES_boundary_color_limit');
min_colorbar_value = -(max_colorbar_value);

index_aux = floor( (colormap_size-1)*(min(max_colorbar_value,max(min_colorbar_value,y_ES(:)))-min_colorbar_value) / (max_colorbar_value-min_colorbar_value) )+1;
ES_colormap_vec(index_aux,:);

%% Printing color and their properties
h_current_ES     = zeros(size(sensors,1),1);
h_current_coords = zeros(size(sensors,1),1);
for i = 1:size(sensors,1)
    h_current_ES(i) = surf(sensors(i,1) + X_s, sensors(i,2) + Y_s, sensors(i,3) + Z_s);
    h_current_coords(i) = h_current_ES(i);
    set(h_current_ES(i),'edgecolor','none');
    if not(y_ES(i)) == 0
        set(h_current_ES(i),'facecolor',ES_colormap_vec(index_aux(i),:));
        %set(h_current_ES(i),'facealpha',(abs(y_ES(i))/max(abs(y_ES)))*(1-evalin('base','zef.brain_transparency'))+evalin('base','zef.brain_transparency'));
        set(h_current_ES(i),'specularstrength',0.9);
        set(h_current_ES(i),'diffusestrength',0.7);
        set(h_current_ES(i),'ambientstrength',0.7);
    else
        %set(h_current_ES(i),'edgecolor',[0.8 0.8 0.8]);
        set(h_current_ES(i),'facecolor',[1 1 1]);
        set(h_current_ES(i),'facealpha',0.1);
        set(h_current_ES(i),'meshstyle','both');
        set(h_current_ES(i),'linestyle',':');
    end
end
hold off;
%% Wrapping up and return of variables
h_axes = axes('Units','normalized','Position',[0 0 0 0],'visible','off');
set(h_axes,'TitleHorizontalAlignment','left');
imagesc(linspace(min_colorbar_value,max_colorbar_value,colormap_size));

colormap(h_axes, ES_colormap_vec);

h_colorbar = colorbar('WestOutside','Position',[0.03 0.65 0.01 0.25]);

%h_colorbar.Limits = [min(y_ES(:)) max(y_ES(:))];
h_colorbar.Limits = [min_colorbar_value max_colorbar_value];
%h_colorbar.Ruler.Exponent = -3;

h_colorbar.Label.String     = 'Amplitude (mA)';
h_colorbar.Label.Position   = [-2 0];
h_colorbar.Label.Rotation   = 90;

h_current_ES = [h_axes; h_colorbar; h_current_ES(:)];
end
