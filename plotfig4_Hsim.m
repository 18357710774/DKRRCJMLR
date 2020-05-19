clear;clc;
load([cd '\synthetic_results\Hsim1.mat'],'testMSE_Baseline_Mean','testMSE_DKRRC_Mean','testMSE_DKRR_Mean');
load([cd '\synthetic_results\Hsim1_BlockPureData.mat'],'testMSE_PureBlockData');
testMSE_PureBlockData_Mean = mean(testMSE_PureBlockData,2);
figure;
SelComInd = [2 3 5 9 17]; 
SelComNum = length(SelComInd);
colorA = colormap(jet(SelComNum+1));
MachineNum = 2:2:60;
xlabelinterval = 10:10:60;
for i = 1:length(xlabelinterval)
    xticklabel{i} = num2str(xlabelinterval(i));
end

uu = 1;
plot(MachineNum,testMSE_DKRR_Mean,'-','color',colorA(uu,:),'linew',3);
hold on;
for i = SelComInd
    uu = uu+1;
    plot(MachineNum,testMSE_DKRRC_Mean(:,i),'-','color',colorA(uu,:),'linew',3);
    hold on;
end
plot(MachineNum,testMSE_Baseline_Mean*ones(1,length(MachineNum)),'k--','linew',2)
hold on;
plot(MachineNum,testMSE_PureBlockData_Mean,'linew',3);

xlabel('The number of local machines');
ylabel('MSE');
set(gca,'XTick',xlabelinterval);
set(gca,'xticklabel',xticklabel);
legend('DKRR','Com. #1','Com. #2','Com. #4','Com. #8','Com. #16','Baseline','Local approximation');
set(gca,'XLim',[1 61]);
set(gca,'YLim',[0.0004 0.1]);
set(gca,'yscale','log')
set(gca,'Ygrid','on')