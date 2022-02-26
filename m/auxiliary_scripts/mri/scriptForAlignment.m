
%%

%%

%get the voxel to ras matrix with freeSurfer from orig.mri

%% voxel-to-ras
T=[-0.9995  -0.0280  -0.0112   133.3754
    -0.0301   0.9302   0.3657  -142.3206
    -0.0002  -0.3659   0.9306   -40.3920
    0.0000   0.0000   0.0000     1.0000];

%% voxel-to-ras modified
Trot=[-0.9995  -0.0280  -0.0112   0
    -0.0301   0.9302   0.3657 0
    -0.0002  -0.3659   0.9306   0
    0.0000   0.0000   0.0000     1.0000];

Tmove=[1 0 0 -128+32; 0 1 0 -128; 0 0 1 -128; 0 0 0 1]; %our mri format is from 1:256, but freeSurfer assumes 128:128. The first dimension is shorter and is corrected
T=Trot*Tmove;

%%

sources=source_grid;
sources=myAffine3d(sources, Tmove);
sources(:,1)=sources(:,1);
sources=myAffine3d(sources, Trot);

figure;
hold on;
%myscatter3(sources,'*', 'red');
%myscatter3(zef.source_positions,'*', 'blue')
scatter3(sources(:,1), sources(:,2), sources(:,3), '*', 'red');
scatter3(zef.source_positions(:,1), zef.source_positions(:,2), zef.source_positions(:,3), '*', 'blue');

%%
res_zef=pointList;

res_zef=myAffine3d(res_zef, Tmove);
res_zef(:,1)=-res_zef(:,1);
res_zef=myAffine3d(res_zef, Trot);

%%
load('./media/datadisk/perepi/p1/res_zef');

hold on;
scatter3(res_zef(:,1),res_zef(:,2), res_zef(:,3),'*', 'green');

%%
saveas(gcf, strcat('./presentation/', 'eeg', zef.reconstruction_information.tag), 'jpg');
%%
hold on;
scatter3(res_zef(:,1),res_zef(:,2), res_zef(:,3),'*', 'green');

%%
saveas(gcf, strcat('./presentation/', 'eeg', zef.reconstruction_information.tag,'res'), 'jpg');

%% reconstruction
saveas(gcf, strcat('./presentation/', 'eeg', zef.reconstruction_information.tag), 'jpg');

%%
saveas(gcf, strcat('./presentation/', 'eeg', zef.reconstruction_information.tag, 'gmm'), 'jpg');

%% own name
saveas(gcf, strcat('./presentation/','resection'), 'jpg');

%%
figure;
hold on;
myscatter3(source_grid,'*', 'red');

myscatter3(resection,'*', 'green')

%%

%%

sources=sources_free;%+[-192/2, -256/2, -256/2];

sources=myAffine3d(sources, T);

figure;
hold on;
myscatter3(sources,'*', 'green');
myscatter3(zef.source_positions,'*', 'blue')

%%
close all;

%%

figure;
hold on;
myscatter3(source_orig,'*', 'red');
myscatter3(source_grid,'*', 'green')

%% ras to voxel

Trot= [      -0.9995  -0.0301  -0.0002   0
-0.0280   0.9302  -0.3659   0
-0.0112   0.3657   0.9306    0
-0.0000  -0.0000  -0.0000     1.0000];

% Trot=[-0.9995  -0.0280  -0.0112   0
%     -0.0301   0.9302   0.3657 0
%     -0.0002  -0.3659   0.9306   0
%     0.0000   0.0000   0.0000     1.0000];
%
% Trot=inv(Trot);

Tmove=[1 0 0 128-32; 0 1 0 128; 0 0 1 128; 0 0 0 1];

T=Tmove*Trot;

%%
sources=zef.source_positions;%+[-192/2, -256/2, -256/2];

sources=myAffine3d(sources, Trot);
sources(:,1)=-sources(:,1);
sources=myAffine3d(sources, Tmove);

figure;
hold on;
myscatter3(sources,'*', 'blue');
myscatter3(source_grid,'*', 'red')

%%

figure;
hold on;

myscatter3(source_grid,'*', 'red')

myscatter3(zef.source_positions,'*', 'red')

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤p2

T=[-0.9985   0.0310  -0.0443   122.5687
                0.0149   0.9451   0.3263  -134.4635
               -0.0520  -0.3252   0.9442   -40.4984
                0.0000   0.0000   0.0000     1.0000];

%%

Trot=[-0.9985   0.0310  -0.0443   0
    0.0149   0.9451   0.3263  0
    -0.0520  -0.3252   0.9442   0
    0.0000   0.0000   0.0000     1.0000];

Tmove=[1 0 0 -128+32; 0 1 0 -128; 0 0 1 -128; 0 0 0 1];

T=Trot*Tmove;

%%

sources=source_grid;
sources=myAffine3d(sources, Tmove);
sources(:,1)=-sources(:,1);
sources=myAffine3d(sources, Trot);

figure;
hold on;
%myscatter3(sources,'*', 'red');
%myscatter3(zef.source_positions,'*', 'blue')
scatter3(sources(:,1), sources(:,2), sources(:,3), '*', 'red');
scatter3(zef.source_positions(:,1), zef.source_positions(:,2), zef.source_positions(:,3), '*', 'blue');

%%

sources=res_zef;
sources=myAffine3d(sources, Tmove);
sources(:,1)=-sources(:,1);
sources=myAffine3d(sources, Trot);

scatter3(sources(:,1), sources(:,2), sources(:,3), '*', 'green');

%%

res_middle=mean(sources);
scatter3(res_middle(:,1), res_middle(:,2), res_middle(:,3), 1100, '*', 'yellow');

%%
figure;
hold on;

%%
scatter3(res_zef(:,1), res_zef(:,2), res_zef(:,3), '*', 'green');

