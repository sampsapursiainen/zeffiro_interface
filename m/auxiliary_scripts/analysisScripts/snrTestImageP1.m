pat='p1';

load(strcat(pat, '_resectionStuff.mat'));
A=alphaShape(res_zef(:,1), res_zef(:,2), res_zef(:,3),3.4);
[AF, AP]=alphaTriangulation(A);

%allHashes=fieldnames(zef.dataBank.tree);
%allHashes=allHashes(startsWith(allHashes,strcat( 'node_3_3', num2str(nodeInde))));

psnr=[-50 -40-30 -20 -10 -5 0 5 10 15 20 30 40 50 6070 80 90];

snr=-20:10:30;
methIndex=[1, 55, 109];
figure;
pInd=1;

for mod=[1,2,4] %[1,2, 3]
    index=1;
    for ind=1:3

        %index=methIndex(ind);

        distances=nan(12,6);
        % clc;
        for p=1:16
            for s=1:10

                if mod~=4

                zef.dataBank.hash=strcat('node_', num2str(mod),'_4_', num2str(index));
                else
                    zef.dataBank.hash=strcat('node_', num2str(mod),'_3_', num2str(index));
                end

                %zef.dataBank.loadParents=true;

                zef_dataBank_setData;
                %   zef.reconstruction_information

                %zef.dataBank.loadParents=false;

                % find maximum of reconstruction

                values=nan(length(zef.reconstruction{1})/3,1);
                j=1;
                for k=1:3:length(zef.reconstruction{1})
                    values(j)=zef.reconstruction{1}(k)^2+zef.reconstruction{1}(k+1)^2+zef.reconstruction{1}(k+2)^2;
                    j=j+1;
                end

                [~, Maxind]=max(values);

                %[~, posDiffmax]=knnsearch(signal_pos, zef.source_positions(ind, :));
                %[~, posDiffmax_res]=knnsearch(AP, zef.source_positions(ind, :));
                %nearestNeighbor(A,zef.source_positions(ind, 1),zef.source_positions(ind, 2),zef.source_positions(ind, 3) );
                distances(p,s)=zef_distance_to_resection(zef.source_positions(Maxind, :),AP, AF);

                index=index+1;
            end
        end
        disp(index);

        %%
        subplot(3,3,pInd)
        pInd=pInd+1;
        imagesc(distances');
        xticks(1:length(psnr));
        yticks(1:length(snr))
        xticklabels(psnr);
        xlabel('psnr');
        yticklabels(snr);
        ylabel('snr');
        caxis([0, 50]);

        switch ind
            case 1
                title('Ramus');
            case 2
                title('mne');
            case 3
                title('sLoreta');
        end

    end
end

