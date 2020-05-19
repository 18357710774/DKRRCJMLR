clear;
load([cd '\synthetic_results\Hsim2_Baseline_paraSel_VaryTrNum.mat'],'testMSE_Baseline_Mean');
testMSE_Baseline_Mean = min(testMSE_Baseline_Mean,[],2);
load([cd '\synthetic_results\Hsim2and3_TrNumVary_timeComplexity.mat'],'testMSE_DKRRC_Mean');

NcrossInd = 3:37;
Ncross = 3000:500:20000;
DivideNumSel = [2 5 8 14 20 26];
CommNumSel = [2 3 4 5 9 17 1];
xlabelinterval = 4000:4000:20000;
for i = 1:length(xlabelinterval)
    xticklabel{i} = num2str(xlabelinterval(i));
end

for i = 1:length(DivideNumSel)
    testMSE_DKRRC_Mean_MachineNumFixTemp = zeros(length(CommNumSel),length(NcrossInd));
    for j = 1:length(NcrossInd)
        for k = 1:length(CommNumSel)
            testMSE_DKRRC_Mean_MachineNumFixTemp(k,j) = testMSE_DKRRC_Mean(DivideNumSel(i),CommNumSel(k),NcrossInd(j));
        end
    end
    testMSE_DKRRC_Mean_MachineNumFix{i} = testMSE_DKRRC_Mean_MachineNumFixTemp;
end

colorA = colormap(jet(length(CommNumSel)));
YLim = [0.001 0.005;0.001 0.0055;0.001 0.01;0.0009 100;0.0009 100; 0.0009 1e8];
for i = 1:length(DivideNumSel)
    figure(i);
    for j = 1:length(CommNumSel)-1
        plot(Ncross,testMSE_DKRRC_Mean_MachineNumFix{i}(j,:),'-','color',colorA(j,:),'linew',3);
        hold on;
    end
    plot(Ncross,testMSE_DKRRC_Mean_MachineNumFix{i}(length(CommNumSel),:),'m--','linew',2);
    hold on;
    plot(Ncross,testMSE_Baseline_Mean(NcrossInd),'k--','linew',2)
    
    title(['Local Machines # ' num2str(DivideNumSel(i)*2)]);
    xlabel('The number of training samples');
    ylabel('MSE');
    set(gca,'XTick',xlabelinterval);
    set(gca,'xticklabel',xticklabel);
    set(gca,'yscale','log');
    legend('Com. #1','Com. #2','Com. #3','Com. #4','Com. #8','Com. #16','DKRR','Baseline');    
    set(gca,'XLim',[2800 20200]);
    set(gca,'YLim',YLim(i,:));
    set(gca,'Ygrid','on')
end