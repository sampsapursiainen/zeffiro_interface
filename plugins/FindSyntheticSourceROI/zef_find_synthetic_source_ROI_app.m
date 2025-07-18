zef.h_find_synthetic_source_ROI = figure(...
    'PaperUnits','inches',...
    'Units','normalized',...
    'Position',[0.565833333333333 1.10641025641026 0.176388888888889 2*0.3],...
    'Visible',get(0,'defaultfigureVisible'),...
    'Color',get(0,'defaultfigureColor'),...
    'IntegerHandle','off',...
    'Colormap',get(0,'defaultfigureColormap'),...
    'MenuBar','none',...
    'ToolBar',get(0,'defaultfigureToolBar'),...
    'ToolBarMode',get(0,'defaultfigureToolBarMode'),...
    'Name','Find synthetic source',...
    'NumberTitle','off',...
    'HandleVisibility','callback',...
    'Tag','figure1',...
    'Resize',get(0,'defaultfigureResize'),...
    'PaperPosition',get(0,'defaultfigurePaperPosition'),...
    'PaperSize',[8.5 11],...
    'PaperSizeMode',get(0,'defaultfigurePaperSizeMode'),...
    'PaperType','usletter',...
    'PaperTypeMode',get(0,'defaultfigurePaperTypeMode'),...
    'PaperUnitsMode',get(0,'defaultfigurePaperUnitsMode'),...
    'ScreenPixelsPerInchMode','manual');

% standard
commonConfig = struct(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text3',...
    'UserData',[],...
    'FontSize',0.460386368569568); 
left_pos = 0.0388471177944862 ;
height_edit = 0.0633663366336633;
box_width = 0.135338345864662 ;
box_height = 0.0633663366336633;
y_dis =  1/9;
on_box =  0.05;
box_pos_1 = 0.497493734335839;
box_pos_2 = 0.662907268170426;
box_pos_3 = 0.828320802005012;
box_pos_0 =  0.3321;
a=0;
%roi shape

a=a+1
hc = uicontrol(commonConfig, ...
    'String',{  'Flat','Spherical','Ellipsoid' },...
    'Style','popupmenu',...
    'Value',1,...
    'Position',[box_pos_0 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Tag','ROIshape', ...
    'Callback', 'zef = zef_disable_box_ROIsource(zef);');
zef.h_synth_source_ROI_style = hc;

uicontrol(commonConfig, ...
    'Style','text',...
    'String','ROI shape:',...
    'Position',[left_pos 1-y_dis*a box_width 0.0561056105610561]...
    );


%radius 
uicontrol(commonConfig,...
    'String','radius/radii [mm]:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_1 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'HorizontalAlignment','right',...
    'Position',[box_pos_1 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1]...
    );

zef.h_synth_source_ROI_radius = hc;

%width
uicontrol(commonConfig,...
    'String','width(s) [mm]:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_2 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'HorizontalAlignment','right',...
    'Position',[box_pos_2 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1]...
    );


zef.h_synth_source_ROI_width = hc;

%curvature
uicontrol(commonConfig,...
    'String','curvature(s):',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_3 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );



hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_3 1-y_dis*a box_width box_height],...
    'Callback','zef = zef_check_curvature_range(zef);'...
    );

zef.h_synth_source_ROI_curvature = hc;

%roi orientation

a=a+1
hc = uicontrol(commonConfig, ...
    'String',{  'Custom', 'Max SVD direction', 'Min SVD direction','Normal to cortex'},...
    'Style','popupmenu',...
    'Value',1,...
    'Position',[box_pos_0 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Tag','ROIshape', ...
    'Callback', 'zef = zef_disable_box_ROIsource(zef);');
zef.h_synth_source_ROI_ori_settings = hc;

uicontrol(commonConfig, ...
    'Style','text',...
    'String','ROI orientation(s):',...
    'Position',[left_pos 1-y_dis*a box_width 0.0561056105610561]...
    );


%coordinates
uicontrol(commonConfig,...
    'String','x-coord:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_1 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'HorizontalAlignment','right',...
    'Position',[box_pos_1 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1]...
    );

zef.h_synth_source_ROI_ori_x = hc;


uicontrol(commonConfig,...
    'String','y-coord:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_2 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'HorizontalAlignment','right',...
    'Position',[box_pos_2 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1]...
    );

zef.h_synth_source_ROI_ori_y = hc;


uicontrol(commonConfig,...
    'String','z-coord.:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_3 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


hc = uicontrol(commonConfig,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'HorizontalAlignment','right',...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1]...
    );


zef.h_synth_source_ROI_ori_z = hc;

%positions
a=a+1;
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'String','ROI center position(s):',...
    'Style','text',...
    'Position',[left_pos 1-y_dis*a box_width 0.0561056105610561],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text3',...
    'UserData',[],...
    'FontSize',0.460386368569568);

%position edit boxes
h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_1 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_x = h_c;

h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_2 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit4',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_y = h_c;

h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit3',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_z = h_c;

%position coordinate labels
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','x-coord.:',...
    'Style','text',...
    'Position',[box_pos_1 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text5',...
    'UserData',[],...
    'FontSize',0.602043712744819);

uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','y-coord.:',...
    'Style','text',...
    'Position',[box_pos_2 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text6',...
    'UserData',[],...
    'FontSize',0.602043712744819);

uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','z-coord.:',...
    'Style','text',...
    'Position',[box_pos_3 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text7',...
    'UserData',[],...
    'FontSize',0.602043712744819);


%orientations
a = a+1;
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'String','Dipole orientation(s):',...
    'Style','text',...
    'Position',[left_pos 1-y_dis*a 0.471177944862155 0.0561056105610561],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text12',...
    'UserData',[],...
    'FontSize',0.460386368569568);

% orientation drop down
hc = uicontrol(commonConfig, ...
    'String',{  'Custom','Max SVD direction','Min SVD direction','Normal to cortex','Normal to patch surface'},...
    'Style','popupmenu',...
    'Value',1,...
    'Position',[box_pos_0 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
     'Callback', 'zef = zef_disable_box_ROIsource(zef);'...
    );
zef.h_synth_source_ROI_dipOri_style = hc;

% orientation edit boxes


h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_1 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn',  '' ,...
    'DeleteFcn',blanks(0),...
    'Tag','edit8',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_dipOri_x = h_c;

h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_2 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit7',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_dipOri_y = h_c;

h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '' ,...
    'DeleteFcn',blanks(0),...
    'Tag','edit6',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_dipOri_z = h_c;

% orientation axis labels


uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','x-coord.:',...
    'Style','text',...
    'Position',[box_pos_1 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text13',...
    'UserData',[],...
    'FontSize',0.602043712744821);

uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','y-coord.:',...
    'Style','text',...
    'Position',[box_pos_2 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text14',...
    'UserData',[],...
    'FontSize',0.602043712744821);

uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','z-coord.:',...
    'Style','text',...
    'Position',[box_pos_3 1-y_dis*a+on_box box_width 0.0429042904290429],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text15',...
    'UserData',[],...
    'FontSize',0.602043712744821);

%amplitude
a=a+1;
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'String','Amplitude(s) (nAm):',...
    'Style','text',...
    'Position',[left_pos 1-y_dis*a 0.171177944862155 0.0561056105610561],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text18',...
    'UserData',[],...
    'FontSize',0.460386368569568);


%amplitude box
h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','1',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...,
    'CreateFcn','',...
    'DeleteFcn',blanks(0),...
    'Tag','edit1',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_amp = h_c;

%noise
a=a+1;
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'String','Noise STD w.r.t. amplitude:',...
    'Style','text',...
    'Position',[left_pos 1-y_dis*a 0.271177944862155 0.0561056105610561],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text4',...
    'UserData',[],...
    'FontSize',0.460386368569568);




%noise edit box
h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','0',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit2',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_noise = h_c;





%plotting settings
a=a+1;
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','left',...
    'ListboxTop',0,...
    'String','Plotting:',...
    'Style','text',...
    'Position',[left_pos 1-y_dis*a 0.471177944862155 0.0561056105610561],...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','text19',...
    'UserData',[],...
    'FontSize',0.460386368569568);


%color drop down

uicontrol(commonConfig,...
    'String','Color:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_2 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String',{  'Black'; 'Red'; 'Green'; 'Blue'; 'Yellow'; 'Purple'; 'Cyan' },...
    'Style','popupmenu',...
    'Value',1,...
    'Position',[box_pos_2 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit10',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_color = h_c;

% plotting style
hc = uicontrol(commonConfig, ...
    'String',{  'ROIs','Dipoles'},...
    'Style','popupmenu',...
    'Value',1,...
    'Position',[box_pos_1 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
'Callback','zef = zef_disable_box_ROIsource(zef);');
zef.h_synth_source_ROI_plot_style = hc;


%length
uicontrol(commonConfig,...
    'String','Dipole length:',...
    'Style','text',...
    'HorizontalAlignment','right',...
    'Position',[box_pos_3 1-y_dis*a+on_box box_width 0.0429042904290429]...
  );


%length edit box

h_c = uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'HorizontalAlignment','right',...
    'ListboxTop',0,...
    'String','1',...
    'Style','edit',...
    'Value',1,...
    'Position',[box_pos_3 1-y_dis*a box_width 0.0633663366336633],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'CreateFcn', '',...
    'DeleteFcn',blanks(0),...
    'Tag','edit9',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.407633763837639);

zef.h_synth_source_ROI_length = h_c;

%start buttons
a=a+1
uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'String','Create synthetic data',...
    'Position',[0.208150584795322 1-y_dis*a 0.355263157894737 0.0898105558587354],...
    'Callback','zef = zef_update_fss_ROI(zef); zef.measurements = zef_find_source_ROI(zef);',...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','pushbutton2',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.287608266707667);




uicontrol(...
    'Parent',zef.h_find_synthetic_source_ROI,...
    'Units','normalized',...
    'FontUnits','normalized',...
    'String','Plot source(s)',...
    'Position',[0.5765716374269 1-y_dis*a 0.355263157894737 0.0898105558587354],...
    'Callback','zef = zef_update_fss_ROI(zef); zef= zef_plot_source_ROI(zef);',...
    'Children',[],...
    'ButtonDownFcn',blanks(0),...
    'DeleteFcn',blanks(0),...
    'Tag','pushbutton1',...
    'KeyPressFcn',blanks(0),...
    'FontSize',0.287608266707667);








