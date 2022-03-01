function zef_3D_plot_specs(h)
%Coordinate system's visualization parameters
head2axes_ratio = 1.0255;   %percentual empty space between surface and coordinate limits
tick_number_limit = 8;      %maximum number of ticks on visualization

%compartment_tags = evalin('base','zef.compartment_tags');
compartment_tags = {'d1','d2','d3','d4','d5','d6','d7','d8','d9','d10','d11','d12','d13','d14','d15','d16','d17','d18','d19','d20','d21','d22','w','g','c','sk','sc'};
%Find indices of the visible compartments
i = 0;
aux_brain_ind = [];
for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
on_val = evalin('base',var_0);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0  && visible_val;
    aux_brain_ind = [aux_brain_ind i];
end
end
end

reuna_p = evalin('base','zef.reuna_p');
source_positions = [];

for k = aux_brain_ind
source_positions = [source_positions;reuna_p{k}];
end
%Set axe limits ans tick intervals
h.XAxis.Limits=head2axes_ratio*[min(source_positions(:,1)),max(source_positions(:,1))];
h.YAxis.Limits=head2axes_ratio*[min(source_positions(:,2)),max(source_positions(:,2))];
h.ZAxis.Limits=head2axes_ratio*[min(source_positions(:,3)),max(source_positions(:,3))];

%Find tick interval length on 10 base number system
x_scale = 10^floor(log10(max(abs(h.XAxis.Limits))));
y_scale = 10^floor(log10(max(abs(h.YAxis.Limits))));
z_scale = 10^floor(log10(max(abs(h.ZAxis.Limits))));
%check exception of values on multiple scale
if floor(max(abs(h.XAxis.Limits))/x_scale) < 2
    x_scale = 0.1*x_scale;
end
if floor(max(abs(h.YAxis.Limits))/y_scale) < 2
    y_scale = 0.1*y_scale;
end
if floor(max(abs(h.ZAxis.Limits))/z_scale) < 2
    z_scale = 0.1*z_scale;
end
%check exception of too tight interval length
if x_scale == 1
    x_scale = 5;
end
if y_scale == 1
    y_scale = 5;
end
if z_scale == 1
    z_scale = 5;
end
%Set tick sparsity
mult_x = ceil((ceil(h.XAxis.Limits(2)/x_scale)-floor(h.XAxis.Limits(1)/x_scale))/tick_number_limit);
mult_y = ceil((ceil(h.YAxis.Limits(2)/y_scale)-floor(h.YAxis.Limits(1)/y_scale))/tick_number_limit);
mult_z = ceil((ceil(h.ZAxis.Limits(2)/z_scale)-floor(h.ZAxis.Limits(1)/z_scale))/tick_number_limit);
%Set ticks
h.XAxis.TickValues = (floor(h.XAxis.Limits(1)/x_scale)*x_scale):(mult_x*x_scale):(ceil(h.XAxis.Limits(2)/x_scale)*x_scale);
h.YAxis.TickValues = (floor(h.YAxis.Limits(1)/y_scale)*y_scale):(mult_y*y_scale):(ceil(h.YAxis.Limits(2)/y_scale)*y_scale);
h.ZAxis.TickValues = (floor(h.ZAxis.Limits(1)/z_scale)*z_scale):(mult_z*z_scale):(ceil(h.ZAxis.Limits(2)/z_scale)*z_scale);

h.XAxis.TickLabels = num2cell(h.XAxis.TickValues);
h.YAxis.TickLabels = num2cell(h.YAxis.TickValues);
h.ZAxis.TickLabels = num2cell(h.ZAxis.TickValues);

%__ Visual appearance __
InitialPosition = [23.9500 239.2200 413.1000 304.7000]./[1920,1080,1920,1080];
window_ratio = evalin('base','zef.h_zeffiro.Position(3:4)./[0.239, 0.5134];');
screen_resolution = get(0,'screensize');
screen_resolution = screen_resolution(3:4);
h.Position(3:4)=InitialPosition(3:4).*window_ratio.*screen_resolution;
h.Position(1:2)=InitialPosition(1:2).*[1,window_ratio(2)].*screen_resolution;

h.XAxis.TickLength = [0.0100 0.0250];
h.YAxis.TickLength = [0.0100 0.0250];
h.ZAxis.TickLength = [0.0100 0.0250];

h.XAxis.TickLabelRotation = 0;
h.YAxis.TickLabelRotation = 0;
h.ZAxis.TickLabelRotation = 0;

h.XAxis.TickDirection = 'in';
h.YAxis.TickDirection = 'in';
h.ZAxis.TickDirection = 'in';

if isprop(h,'Legend')
    %h.Legend.Visible = 'off';
    delete(h.Legend);
end

h.PlotBoxAspectRatio = [1.0349,1.2555,1];
h.DataAspectRatioMode = 'manual';
set(h,'CLim',[0.01 1])
set(h,'CameraUpVector', [0 0 1])
%set(h,'PlotBoxAspectRatio',[1 1 1])
rotate3d(h,'on')

%__ View & Grid __
view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
axis('image');
set(h,'CameraViewAngle',evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(h,'visible','on');
set(h,'xGrid','on');
set(h,'yGrid','on');
set(h,'zGrid','on');
else
set(h,'visible','off');
set(h,'xGrid','off');
set(h,'yGrid','off');
set(h,'zGrid','off');
end

end
