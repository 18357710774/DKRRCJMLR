clear;clc;
load([cd '\synthetic_results\sim1.mat'],'testMSE_Baseline_Mean','testMSE_DKRRC_Mean','testMSE_DKRR_Mean');

DivideNumInd = [1 4 7 10 13 16]; % corresponding to the number of local machines [20 80 140 200 260 320]
CommNumSel = 1:20;
xlabelinterval = 2:2:20;
for i = 1:length(xlabelinterval)
    xticklabel{i} = num2str(xlabelinterval(i));
end

colorA = colormap(jet(length(DivideNumInd)));   
kk = 0;
for DivideNum = DivideNumInd
    kk = kk+1;  
    uu = 0;
    for ComNum = CommNumSel
        uu = uu+1;
        ComMSE(kk,uu) = testMSE_DKRRC_Mean(DivideNum,1+ComNum);
    end
    NonComMSE(:,kk) = testMSE_DKRR_Mean(DivideNum,1);
    plot(CommNumSel,ComMSE(kk,CommNumSel),'-','color',colorA(kk,:),'linew',3);
    hold on;
end

plot(CommNumSel,NonComMSE(kk)*ones(size(CommNumSel)),'m--','linew',2)
hold on;
plot(CommNumSel,testMSE_Baseline_Mean*ones(size(CommNumSel)),'k--','linew',2)

xlabel('The number of communications');
ylabel('MSE');
set(gca,'XTick',xlabelinterval);
set(gca,'xticklabel',xticklabel);
set(gca,'YLim',[2 6]*0.0001);
set(gca,'Ygrid','on');
legend('DKRR(l): m=20','DKRR(l): m=80','DKRR(l): m=140','DKRR(l): m=200','DKRR(l): m=260','DKRR(l): m=320','DKRR: m=320','Baseline');

