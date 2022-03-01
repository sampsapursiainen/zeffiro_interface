
%signal_pos=[-16, 56.5, 41.6];

p='p1';

load(strcat(p, '_resectionStuff.mat'));
A=alphaShape(res_zef(:,1), res_zef(:,2), res_zef(:,3),3.4);
[AF, AP]=alphaTriangulation(A);

%%
signal_pos=res_zef;
alpha = str2num(evalin('base','zef.GMM.parameters.Values{6}'))/100;
r = sqrt(chi2inv(alpha,3));

SNR=[-30 -25 -20 -15 -10 -5];

for nodeInde=1:3

N=1; %levels of runs
D_comp=4;  %number of max gmm components
M=5; %number of methods
SNR_number=1; %number of different SNR runs
M_space=5; % space between methods
GMM_space=2; %space between GMModels (ans maximum)
GMM_number=2+1; %number of GMModels (plus 1 for the maximum)

matBig=nan(N, M*(GMM_number*SNR_number+(GMM_number-1)*GMM_space)+(M-1)*M_space);
matBig_imp=matBig;
matBig_min=matBig;
matBig_amp=matBig;
matBig_exc=matBig;
matBig_vol=matBig;
matBig_vdi=matBig;
matBig_vdA=matBig;
matBig_vdO=matBig;
matBig_vdWO=matBig;
matBig_2max=matBig;
matBig_disp=matBig;

 mat_color=[];

matSuperBig=[];
matSuperBig_imp=[];
matSuperBig_min=[];
matSuperBig_amp=[];
matSuperBig_vol=[];
matSuperBig_exc=[];
matSuperBig_vdi=[];
matSuperBig_vdA=[];
matSuperBig_vdO=[];
matSuperBig_vdWO=[];
matSuperBig_2max=[];
matSuperBig_disp=[];

for runIndex=1

for snr_i=1:SNR_number
    allHashes=fieldnames(zef.dataBank.tree);

    allHashes=allHashes(startsWith(allHashes,strcat( 'node_', num2str(nodeInde))));

    snr_now=SNR(snr_i);
    %a=strcat('..\p2\treeAt_SNR_', num2str(snr_now), '.mat');
    %a=strcat('..\p2\tree\eegtreeAt_SNR_', num2str(snr_now),'_', num2str(runIndex),  '.mat');
    %load(a);
   % zef.dataBank.tree=tree;

diff_ind=1;
%open gmm tool first and set the parameters
diff=cell(0,0);
diff_vol=cell(0,0);
diff_exc=cell(0,0);
diff_amp=cell(0,0);
diff_vdi=cell(0,0);
diff_vdA=cell(0,0);
diff_vdO=cell(0,0);
diff_vdWO=cell(0,0);

diff_max=cell(0,0);
diff_2max=cell(0,0);
diff_disp=cell(0,0);

for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')

        for meth=1:M

            for gmmInd=1:2

                zef.dataBank.hash=strcat(allHashes{i},'_',num2str(meth),'_',num2str(gmmInd));
                zef.dataBank.loadParents=true;

                zef_dataBank_setData;

                zef.dataBank.loadParents=false;

                [amp, dip_ind_all]=maxk(sum(zef.GMM.dipoles.^2,2),10); %this is used by Joonas, so I

                % find maximum of reconstruction

                values=nan(length(zef.reconstruction{1})/3,1);
                j=1;
                for k=1:3:length(zef.reconstruction{1})
                    values(j)=zef.reconstruction{1}(k)^2+zef.reconstruction{1}(k+1)^2+zef.reconstruction{1}(k+2)^2;
                    j=j+1;
                end

                [~, ind]=max(values);

                [~, posDiffmax]=knnsearch(signal_pos, zef.source_positions(ind, :));
                %[~, posDiffmax_res]=knnsearch(AP, zef.source_positions(ind, :));
                %nearestNeighbor(A,zef.source_positions(ind, 1),zef.source_positions(ind, 2),zef.source_positions(ind, 3) );
                   posDiffmax_res=zef_distance_to_resection(zef.source_positions(ind, :),AP, AF);

                %diff_array_max=[diff_array_max,posDiffmax]; %

                diff_array=[];
                diff_array_max=[];
                diff_array_toMax=[];
                vol=[];
                exc=[];
                vol_diff=[];
                vol_diffO=[];
                vol_diffA=[];
                vol_diffWO=[];

                for j=1:length(dip_ind_all)
                    dip_ind=dip_ind_all(j);
                    pos=[zef.GMM.model.mu(dip_ind,1),zef.GMM.model.mu(dip_ind,2),zef.GMM.model.mu(dip_ind,3)];
                    [~, posDiff]=knnsearch(signal_pos, pos);
                    posDiff_res=zef_distance_to_resection(pos,AP, AF);

                    [~, posDiff2max]=knnsearch(zef.source_positions(ind, :), pos);
                    diff_array_toMax=[diff_array_toMax, posDiff2max];

                    diff_array=[diff_array, posDiff_res];

                    diff_array_max=[diff_array_max,posDiffmax_res];

                    [principal_axes,semi_axes]=eig(inv(zef.GMM.model.Sigma(1:3,1:3,j)));
                    semi_axes = transpose(r./sqrt(diag(semi_axes)));
                    [X,Y,Z]=ellipsoid(zef.GMM.model.mu(j,1),zef.GMM.model.mu(j,2),zef.GMM.model.mu(j,3),semi_axes(1),semi_axes(2),semi_axes(3),100);

                    vol(j)=semi_axes(1)*semi_axes(2)*semi_axes(3);
                    vol(j)=vol(j)^(1/3);
                    exc(j)=semi_axes(3)/semi_axes(1);

                    [vol_diff(j), vol_diffA(j), vol_diffO(j)]=zef_GMM_resection_volume(res_zef, FB,D, zef.GMM,dip_ind);
                   vol_diffWO(j)=vol_diffA(j)/(4/3*pi*semi_axes(1)*semi_axes(2)*semi_axes(3));

                end

                diff{diff_ind,meth, gmmInd}=diff_array;
                diff_max{diff_ind,meth, gmmInd}=diff_array_max;
                diff_2max{diff_ind,meth, gmmInd}=diff_array_toMax;
                diff_vol{diff_ind,meth, gmmInd}=vol;
                diff_exc{diff_ind,meth, gmmInd}=exc;
                diff_amp{diff_ind,meth, gmmInd}=amp;
                diff_vdi{diff_ind,meth, gmmInd}=vol_diff;
                diff_vdA{diff_ind,meth, gmmInd}=vol_diffA;
                diff_vdO{diff_ind,meth, gmmInd}=vol_diffO;
                diff_vdWO{diff_ind,meth, gmmInd}=vol_diffWO;

                [~, distGMM]=knnsearch(mean(zef.GMM.model.mu(:,1:3),1), zef.GMM.model.mu(:,1:3));
                diff_disp{diff_ind,meth, gmmInd}=sqrt(mean(distGMM.^2));

            end

        end
        diff_ind=diff_ind+1;
    end
end

    for meth=1:M

        for n=1:N
        matBig(n, snr_i+                                                           (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)    +            (meth-1)*M_space)=diff_max{n, meth, 1}(1);
                matBig_min(n, snr_i+                                                           (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)    +            (meth-1)*M_space)=diff_max{n, meth, 1}(1);

        end

        for g=1:(GMM_number-1)

            for n=1:N
                matBig    (n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff    {n, meth, g}(1);

                matBig_imp    (n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=(diff{n, meth, g}(1)-min(diff    {n, meth, g}))/diff{n, meth, g}(1);

                matBig_min    (n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=min(diff    {n, meth, g});

                matBig_amp(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_amp{n, meth, g}(1);
                matBig_vol(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_vol{n, meth, g}(1);
                matBig_exc(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_exc{n, meth, g}(1);
                matBig_vdi(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_vdi{n, meth, g}(1);
                matBig_vdA(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_vdA{n, meth, g}(1);
                matBig_vdO(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_vdO{n, meth, g}(1);
                matBig_vdWO(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_vdWO{n, meth, g}(1);
                matBig_2max(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_2max{n, meth, g}(1);

                matBig_disp(n,snr_i+               (SNR_number+GMM_space)*g+          (meth-1)*(GMM_number*(SNR_number+GMM_space)-GMM_space)            +       (meth-1)*M_space)=diff_disp{n, meth, g};

            end

        end

    end

end

matSuperBig=[matSuperBig; matBig];
matSuperBig_imp=[matSuperBig_imp; matBig_imp];
matSuperBig_min=[matSuperBig_min; matBig_min];
matSuperBig_amp=[matSuperBig_amp; matBig_amp];
matSuperBig_vol=[matSuperBig_vol; matBig_vol];
matSuperBig_exc=[matSuperBig_exc; matBig_exc];
matSuperBig_vdi=[matSuperBig_vdi; matBig_vdi];
matSuperBig_vdA=[matSuperBig_vdA; matBig_vdA];
matSuperBig_vdO=[matSuperBig_vdO; matBig_vdO];
matSuperBig_vdWO=[matSuperBig_vdWO; matBig_vdWO];
matSuperBig_2max=[matSuperBig_2max; matBig_2max];
matSuperBig_disp=[matSuperBig_disp; matBig_disp];

end

%%
mLab={'mne', 'sLoreta', 'RAMUS-4-10', 'DipScan', 'Beamformer'};

gLab={'max','gmm\_50', 'gmm\_75'};
gColor={'black', 'blue', 'green'};

myXticks=[];
newTick=floor(SNR_number/2);
for m=1:M

    for g=1:GMM_number
    newTick=newTick;
    myXticks=[ myXticks newTick];
    newTick=newTick+(GMM_space+SNR_number);
    end
    newTick=newTick+M_space-GMM_space;
end
%%

for m=1:M

    myXLabel{(m-1)*3 +1}=gLab{1};
    myXLabel{(m-1)*3 +2}=strcat(gLab{2}, '\newline', mLab{m});
    myXLabel{(m-1)*3 +3}= gLab{3};
    %myXLabel{(m-1)*4 +4}= gLab{4};

%     myXC{(m-1)*3 +1}=gColor{1};
%     myXC{(m-1)*3 +2}=gColor{2};
%     myXC{(m-1)*3 +3}= gColor{3};

end

%%

% figure;
% subplot(4,1,1)
% bar(matSuperBig);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, inf]);
% title('Distance to source');
%
% subplot(4,1,2)
% bar(matSuperBig_2max);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, inf]);
% title('distance to max position');
%
% subplot(4,1,3)
% bar(matSuperBig_vol);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, inf]);
% title('mean axes of gmm elipsoid');
%
% subplot(4,1,4)
% bar(matSuperBig_exc);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, 1]);
% title('Excentricity of gmm elipsoid');
%%

switch nodeInde
    case 1
        nom='eeg';
    case 2
        nom='meg';
    case 3
        nom='meeg';
end

plottingStuff.(nom).matSuperBig=matSuperBig;
plottingStuff.(nom).matSuperBig_2max=matSuperBig_2max;
plottingStuff.(nom).matSuperBig_vol=matSuperBig_vol;
plottingStuff.(nom).matSuperBig_amp=matSuperBig_amp;
plottingStuff.(nom).matSuperBig_exc=matSuperBig_exc;
plottingStuff.(nom).matSuperBig_imp=matSuperBig_imp;
plottingStuff.(nom).matSuperBig_min=matSuperBig_min;
plottingStuff.(nom).matSuperBig_disp=matSuperBig_disp;

%
% figure;
% subplot(4,1,1)
%
% bar(matSuperBig_vdi);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, 1]);
% title('Volume differences V_{and}/V_{or}');
%
%
%
% subplot(4,1,2)
%
% bar(matSuperBig_vdWO);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, 1]);
% title('Volume differences V_{and}/V_{gmm}');
%
%
%
%
% subplot(4,1,3)
%
% bar(matSuperBig_vdA);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, 5*10^3]);
% title('Volume (and)');
%
% subplot(4,1,4)
%
% bar(matSuperBig_vdO);
% ax=gca;
% ax.TickLabelInterpreter = 'tex';
% xticks(myXticks)
% xticklabels(myXLabel);
% ylim([0, inf]);
% title('Volume (or)');

%%
end
%%

% plottingStuff.(nom).matSuperBig=matSuperBig;
% plottingStuff.(nom).matSuperBig_2max=matSuperBig_2max;
% plottingStuff.(nom).matSuperBig_vol=matSuperBig_vol;
% plottingStuff.(nom).matSuperBig_amp=matSuperBig_amp;
% plottingStuff.(nom).matSuperBig_exc=matSuperBig_exc;

%%
% plottingStuff.all.matSuperBig=thingOrNan(plottingStuff.('eeg').matSuperBig,[nan, plottingStuff.('meg').matSuperBig]);
% plottingStuff.all.matSuperBig=thingOrNan(plottingStuff.('all').matSuperBig, [nan, nan, plottingStuff.('meeg').matSuperBig]);

%determine colors
c1=zeros(length(plottingStuff.eeg.matSuperBig), 3);
col=zeros(length(plottingStuff.eeg.matSuperBig), 3);

iii=1;

myXticks=[];
for ci=1:length(plottingStuff.eeg.matSuperBig)
    if ~isnan(plottingStuff.eeg.matSuperBig(ci))

        myXticks=[myXticks, ci];

        if iii==1
        col(ci,:)=[0,1,0];
        iii=2;
        end
        if iii==2
        col(ci,:)=[0,0,1];
        iii=3;
        end
         if iii==3
        col(ci,:)=[1,0,0];
        iii=1;
        end

    end

end

%%
%
%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('Distance to resection');
% bar(plottingStuff.eeg.matSuperBig, 'r');
% bar([nan, plottingStuff.meg.matSuperBig], 'b');
% bar([nan, nan, plottingStuff.meeg.matSuperBig], 'c');
%
% xticks(myXticks);
% xticklabels(myXLabel);
% legend('eeg', 'meg', 'meeg');
%
%
% yL=ylim;
%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('Minimal GMM Distance to resection');
% bar(plottingStuff.eeg.matSuperBig_min, 'r');
% bar([nan, plottingStuff.meg.matSuperBig_min], 'b');
% bar([nan, nan, plottingStuff.meeg.matSuperBig_min], 'c');
% ylim(yL);
% xticks(myXticks);
% xticklabels(myXLabel);
% legend('eeg', 'meg', 'meeg');
%
%
%
%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('Improvement for GMM');
% bar(plottingStuff.eeg.matSuperBig_imp, 'r');
% bar([nan, plottingStuff.meg.matSuperBig_imp], 'b');
% bar([nan, nan, plottingStuff.meeg.matSuperBig_imp], 'c');
%
% xticks(myXticks);
% xticklabels(myXLabel);
% legend('eeg', 'meg', 'meeg');
%
%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('GMM dispersion');
% bar(plottingStuff.eeg.matSuperBig_disp, 'r');
% bar([nan, plottingStuff.meg.matSuperBig_disp], 'b');
% bar([nan, nan, plottingStuff.meeg.matSuperBig_disp], 'c');
%
% xticks(myXticks);
% xticklabels(myXLabel);
% legend('eeg', 'meg', 'meeg');
%
%
%

%%

for nomIndex=1:3

switch nomIndex
    case 1
        nom='eeg';
    case 2
        nom='meg';
    case 3
        nom='meeg';
end

%
colors = [1,0.4,0.4;0.6,1,0.6;0.6,0.6,1;1,0.4,0.7];
subplot(3,3,subIndex);

%figure;
hold on;
title(strcat(typ, '-' ,nom, '-', 'Distance to resection'));
colorIndex=1;
for pIndex=1:length(plottingStuff.(nom).matSuperBig)
    b=bar(pIndex, plottingStuff.(nom).matSuperBig(pIndex), 2 );
    b.FaceColor=colors(colorIndex,:);

    if ~isnan(plottingStuff.(nom).matSuperBig(pIndex))
        colorIndex=colorIndex+1;
        if colorIndex==4
            colorIndex=1;
        end
    end
    %drawnow;
    %disp(colorIndex);
    %pause(0.5);

end

pbaspect([3,1,1]);
%set(gca,'FontSize',10);
set(gca,'LineWidth',2);

% bar([nan, plottingStuff.(nom).matSuperBig_min], 'g');

subIndex=subIndex+1;
xticks(myXticks);
xticklabels(myXLabel);

% name=strcat('./', p, '_', nom, '_distance');
% % saveas(gca, name, 'epsc');
%
 yL=ylim;

% pause(2);
%
%

% figure('Position',[120,20, 1200, 800]);
% hold on;
% title(strcat(nom, '-','Minimal GMM Distance to resection'));
% bar(plottingStuff.(nom).matSuperBig_min);
%
% %ylim(yL);
% xticks(myXticks);
% xticklabels(myXLabel);
%

% name=strcat('./', p, '_', nom, '_MinimalDistance');
% saveas(gca, name, 'epsc');
% pause(2);

%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('Improvement for GMM');
% bar(plottingStuff.(nom).matSuperBig_imp);
%
% xticks(myXticks);
% xticklabels(myXLabel);
%
% name=strcat('./', p, '_', nom, '_Improv');
% saveas(gca, name, 'epsc');
%
%
%
% pause(2);
%
%
%
%
%
% figure('Position',[120,20, 1200, 800]);
% hold on;
% title('GMM dispersion');
% bar(plottingStuff.(nom).matSuperBig_disp);
%
% xticks(myXticks);
% xticklabels(myXLabel);
%
%
% name=strcat('./', p, '_', nom, '_dispersion');
% saveas(gca, name, 'epsc');
%

end

