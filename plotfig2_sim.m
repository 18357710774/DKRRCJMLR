clear;clc;
load([cd '\synthetic_results\sim1.mat'],'testMSE_Baseline_Mean','testMSE_DKRRC_Mean','testMSE_DKRR_Mean');
load([cd '\synthetic_results\sim1_BlockPureData.mat'],'testMSE_PureBlockData');
testMSE_PureBlockData_Mean = mean(testMSE_PureBlockData,2);

xlabelinterval = 80:80:480;
for i = 1:length(xlabelinterval)
    xticklabel{i} = num2str(xlabelinterval(i));
end
MachineNum = 20:20:480;
figure(1);
plot(MachineNum,testMSE_DKRRC_Mean(:,1),'b-','linew',3);
hold on;
plot(MachineNum,testMSE_Baseline_Mean*ones(1,length(MachineNum)),'k--','linew',2)
hold on;
plot(MachineNum,testMSE_PureBlockData_Mean,'linew',3);

xlabel('The number of local machines');
ylabel('MSE');
set(gca,'XTick',xlabelinterval);
set(gca,'xticklabel',xticklabel);
legend('DKRR','KRR','Local approximation');
set(gca,'XLim',[10 490]);