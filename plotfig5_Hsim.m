clear;clc;
load([cd '\synthetic_results\Hsim1.mat'],'testMSE_Baseline_Mean','testMSE_DKRRC_Mean','testMSE_DKRR_Mean');

DivideNumInd = [2 5 8 11 14 17]; % corresponding to the number of local machines [4 10 16 22 28 34]
CommNumSel = 1:12;
xlabelinterval = 2:2:12;
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
set(gca,'YLim',[1.6 4.2]*0.001);
set(gca,'XLim',[0.9 12.1]);
set(gca,'Ygrid','on')
legend('DKRR(l): m=4','DKRR(l): m=10','DKRR(l): m=16','DKRR(l): m=22','DKRR(l): m=28','DKRR(l): m=34','DKRR: m=34','Baseline');

