%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_plot_parcellation_time_series(void)

void = [];

time_series = evalin('base','zef.parcellation_time_series');
plot_type = evalin('base','zef.parcellation_plot_type');
selected_list = evalin('base','zef.parcellation_selected');
parcellation_colortable = evalin('base','zef.parcellation_colortable');
parcellation_colormap = evalin('base','zef.parcellation_colormap');
y_string = get(evalin('base','zef.h_parcellation_plot_type'),'string');
y_string = y_string{plot_type};

if size(parcellation_colortable,1) > 0
zef_k = 0; 
parcellation_list = cell(0);
for zef_j = 1 : length(parcellation_colortable)
for zef_i = 1 : size(parcellation_colortable{zef_j}{2},1)
    zef_k = zef_k + 1; 
    parcellation_list{zef_k} = [parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ];   
end
end
end

if plot_type == 1

time_series = time_series./sum(time_series);
y_vals = max(time_series,[],2); 

plot_mode = 1;

end

if plot_type == 2

y_vals = max(time_series,[],2); 

plot_mode = 1;

end
   
if plot_type == 3

time_series = time_series./sum(time_series);
y_vals = mean(time_series,2); 

plot_mode = 1;

end

if plot_type == 4

y_vals = mean(time_series,2); 

plot_mode = 1;

end

if plot_type == 5

time_series = time_series./sum(time_series);
y_vals = std(time_series'); 

plot_mode = 1;

end

if plot_type == 6

y_vals = std(time_series'); 

plot_mode = 1;

end

if plot_type == 7

time_series = time_series./sum(time_series);    
y_vals = corr(time_series'); 

plot_mode = 2;

end


if plot_type == 8
  
y_vals = corr(time_series'); 

plot_mode = 2;

end

if plot_type == 9

time_series = time_series./sum(time_series);    
D = diag(sqrt(mean(time_series,2)));
D = D./max(D(:));
y_vals = corr(time_series'); 
y_vals = D*y_vals*D;


plot_mode = 2;

end

if plot_type == 10

time_series = time_series./sum(time_series);    
D = diag(sqrt(max(time_series,[],2)));
D = D./max(D(:));
y_vals = corr(time_series'); 
y_vals = D*y_vals*D;


plot_mode = 2;

end


if plot_type == 11

time_series = time_series./sum(time_series);      
y_vals = cov(time_series'); 

plot_mode = 2;

end


if plot_type == 12
     
y_vals = cov(time_series'); 

plot_mode = 2;

end


if plot_type == 13

time_series = time_series./sum(time_series);     
y_vals = zeros(size(time_series,1), size(time_series,1));    
for i = 1 : size(time_series,1)
    for j = 1 : size(time_series,1)
y_vals(i,j) = dtw(time_series(i,:),time_series(j,:)); 
    end
end

plot_mode = 2;

end

if plot_type == 14
  
y_vals = zeros(size(time_series,1), size(time_series,1));    
for i = 1 : size(time_series,1)
    for j = 1 : size(time_series,1)
y_vals(i,j) = dtw(time_series(i,:),time_series(j,:)); 
    end
end

plot_mode = 2;

end


if plot_mode == 1
x_vals = [1:length(selected_list)]+0.5;
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
for i = 1 : length(selected_list)
bar(x_vals(i),y_vals(i),0.7,'facecolor',2*parcellation_colormap(selected_list(i)+1,:),'Parent',evalin('base','zef.h_axes1'));
if i == 1
hold(evalin('base','zef.h_axes1'),'on');
end
end
set(evalin('base','zef.h_axes1'),'xticklabel',[]);
set(evalin('base','zef.h_axes1'),'ticklength',[0 0]);
set(evalin('base','zef.h_axes1'),'xlim',[1 length(selected_list)+1]);
set(evalin('base','zef.h_axes1'),'ylim',[0 1.05*max(y_vals)]);
set(evalin('base','zef.h_axes1'),'ygrid','on');
x_labels = text(x_vals-0.25,-0.01*max(y_vals)*ones(size(x_vals)),parcellation_list(selected_list),'Parent',evalin('base','zef.h_axes1'));
y_label = text(1.01*(length(x_vals)+1),1.05*max(y_vals)/2,y_string,'Parent',evalin('base','zef.h_axes1'));
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
set(y_label,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);


end


if plot_mode == 2
colormap_size = 4096;
if evalin('base','zef.inv_colormap') == 1
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec_aux = [([20*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*[1:c_aux_2-c_aux_1] 6*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 7.5*[1:colormap_size-c_aux_2]])];
colormap_vec = zeros(3,size(colormap_vec_aux,2));
colormap_vec = colormap_vec + 0.52*[50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:)];
colormap_vec = colormap_vec + 0.5*[85*colormap_vec_aux(3,:) ; 197*colormap_vec_aux(3,:) ; 217*colormap_vec_aux(3,:)];
colormap_vec = colormap_vec + 0.1*[2*colormap_vec_aux(2,:) ; 118*colormap_vec_aux(2,:) ; 132*colormap_vec_aux(2,:)];
colormap_vec = colormap_vec + [203*colormap_vec_aux(4,:) ; 203*colormap_vec_aux(4,:) ; 100*colormap_vec_aux(4,:)];
clear colormap_vec_aux;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 2
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(1,:) =10*([colormap_size:-1:1]/colormap_size);
colormap_vec(2,:) = [10*( (3/2)*[c_aux_2:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_2)];
colormap_vec(3,:) = [10*((3)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];  
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 3
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(2,:) = 10*([colormap_size:-1:1]/colormap_size);
colormap_vec(1,:) = [10*(3/2)*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
colormap_vec(3,:) = [10*(3*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
%colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 4
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(3,:) = 10*([colormap_size:-1:1]/colormap_size);
colormap_vec(2,:) = [10*(3/2)*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
colormap_vec(1,:) = [10*(3*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
%colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 5
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = [([20*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*[1:c_aux_2-c_aux_1] 6*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 7.5*[1:colormap_size-c_aux_2]])];
colormap_vec([1 2],:) = colormap_vec([2 1],:);
colormap_vec(1,:) = colormap_vec(1,:) + colormap_vec(2,:);
colormap_vec(3,:) = colormap_vec(4,:) + colormap_vec(3,:);
colormap_vec(2,:) = colormap_vec(4,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(4,:) + colormap_vec(1,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 6
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
c_aux_3 = floor(colormap_size/2);
colormap_vec = [([20*[c_aux_3:-1:1] zeros(1,colormap_size-c_aux_3)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 7*[1:c_aux_2-c_aux_1] 7*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 10.5*[1:colormap_size-c_aux_2]])];
colormap_vec(3,:) = colormap_vec(4,:) + colormap_vec(3,:);
colormap_vec(2,:) = colormap_vec(4,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(4,:) + colormap_vec(1,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 7
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 3*[1: c_aux_1] 3*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec([1 2],:) = colormap_vec([2 1],:);
colormap_vec(1,:) = colormap_vec(1,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(3,:) + colormap_vec(1,:);
colormap_vec(2,:) = colormap_vec(3,:) + colormap_vec(2,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 8
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 3*[1: c_aux_1] 3*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec([2 3],:) = colormap_vec([3 2],:);
colormap_vec(1,:) = colormap_vec(2,:) + colormap_vec(1,:);
colormap_vec(3,:) = colormap_vec(2,:) + colormap_vec(3,:);
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 9
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 2*[1: c_aux_1] 2*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec(1,:) = colormap_vec(3,:) + colormap_vec(1,:);
colormap_vec(2,:) = colormap_vec(3,:) + colormap_vec(2,:);
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 10
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 8*[1: c_aux_1] 8*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 5*[1:colormap_size-c_aux_1]];
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 11
colormap_vec = [(colormap_size/5)^3 + colormap_size^2*[1 : colormap_size] ; (colormap_size/2)^3 + ((colormap_size)/2)*[1:colormap_size].^2 ; ...
    (0.7*colormap_size)^3+(0.5*colormap_size)^2*[1:colormap_size]];
colormap_vec = colormap_vec'/max(colormap_vec(:));
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 12
colormap_vec = [[1:colormap_size] ; 0.5*[1:colormap_size] ; 0.5*[colormap_size:-1:1] ];
colormap_vec = colormap_vec'/max(colormap_vec(:));
set(evalin('base','zef.h_zeffiro'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 13
set(evalin('base','zef.h_zeffiro'),'colormap',evalin('base','zef.parcellation_colormap'));
end

x_vals = [1:length(selected_list)];
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
imagesc(y_vals,'Parent',evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'visible','off');
colorbar(evalin('base','zef.h_axes1'),'fontsize',8);
hold(evalin('base','zef.h_axes1'),'on');
set(evalin('base','zef.h_axes1'),'xticklabel',[]);
set(evalin('base','zef.h_axes1'),'ticklength',[0 0]);
x_labels = text(x_vals-0.5,(1.01*(size(y_vals,1)+1)-0.5)*ones(size(x_vals)),parcellation_list(selected_list),'Parent',evalin('base','zef.h_axes1'));
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
y_labels = text((-0.05*(length(x_vals)+1)+0.5)*ones(1,length(x_vals(1:2:end))),x_vals(1:2:end)-0.5,parcellation_list(selected_list(1:2:end)),'Parent',evalin('base','zef.h_axes1'));
set(y_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');
y_labels = text((-0.01*(length(x_vals)+1)+0.5)*ones(1,length(x_vals(2:2:end))),x_vals(2:2:end)-0.5,parcellation_list(selected_list(2:2:end)),'Parent',evalin('base','zef.h_axes1'));
set(y_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
set(evalin('base','zef.h_axes1'),'xlim',[0 length(x_vals)+1]);
set(evalin('base','zef.h_axes1'),'ylim',[0 length(x_vals)+1]);
y_label = text((length(x_vals)+1)/2,-0.01*(length(x_vals)+1),y_string,'Parent',evalin('base','zef.h_axes1'));
set(y_label,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');

end

end
