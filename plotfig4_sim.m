clear;clc;
load([cd '\synthetic_results\sim1.mat'],'testMSE_Baseline_Mean','testMSE_DKRRC_Mean','testMSE_DKRR_Mean');
load([cd '\synthetic_results\sim1_BlockPureData.mat'],'testMSE_PureBlockData');
testMSE_PureBlockData_Mean = mean(testMSE_PureBlockData,2);
figure;
SelComInd = [2 3 5 9 17]; % 1 represents no communication, 2 represents 1 communications, 3 represents 2 communications and so forth.
SelComNum = length(SelComInd);
colorA = colormap(jet(SelComNum+1));
MachineNum = 20:20:480;
xlabelinterval = 80:80:480;
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
set(gca,'XLim',[10 490]);
set(gca,'YLim',[0.00005 0.005]);
set(gca,'yscale','log');
set(gca,'Ygrid','on');