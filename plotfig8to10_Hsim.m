clear;clc;
load([cd '\synthetic_results\Hsim2_Baseline_paraSel_VaryTrNum.mat'],'testMSE_Baseline_Mean');
testMSE_Baseline_MeanMin = min(testMSE_Baseline_Mean,[],2);
load([cd '\synthetic_results\Hsim2and3_TrNumVary_timeComplexity.mat'],'testMSE_DKRRC_Mean','TimeTe_DKRRC','TimeTr_DKRRC');

NCross = 2000:500:20000;
ExNum = 30;
Dim = 3;
ComNum = 50; % The number of communications
divideCross = 2:2:60; % The range of the number of local machines
dNum = 2;
ComNumInd = [2 4 8 16 32]; % The selected number of communications
epsRatio = 0.05;
kappa = 3;

% The traing time of Step1 in DKRRC is the training time of DKRR
TrTime_DKRR = zeros(length(divideCross),length(NCross),ExNum);
for i = 1:length(NCross)
    for j = 1:ExNum
        for k = 1:length(divideCross)
             TimeTr_tmp = TimeTr_DKRRC{i}{k,j};
             TrTime_DKRR(k,i,j) = mean(TimeTr_tmp.Step1);
        end
    end
end
TrTime_DKRR_mean = mean(TrTime_DKRR,3);

% The traning time of DKRRC
TrTime_DKRRC = zeros(length(divideCross),ComNum+1,length(NCross),ExNum);
for i = 1:length(NCross)
    for j = 1:ExNum
        for k = 1:length(divideCross)
            TimeTr_tmp = TimeTr_DKRRC{i}{k,j};
            TrTime_DKRRC(k,1,i,j) = mean(TimeTr_tmp.Step1)+TimeTr_tmp.Step2;
            for v = 1:ComNum
                 TrTime_DKRRC(k,v+1,i,j) = TrTime_DKRRC(k,v,i,j)+mean(TimeTr_tmp.Step4(:,v))+TimeTr_tmp.Step5(:,v)+...
                                           mean(TimeTr_tmp.Step6(:,v))+TimeTr_tmp.Step7(:,v);                
            end
        end
    end
end
TrTime_DKRRC_mean = mean(TrTime_DKRRC,4); 
% The first dimension is the number of local machines; the sencond
% dimension is the number of communications; the third dimension is the
% number of training samples; the forth dimension is the number of
% experiments.

% For each N, compute the maximum number m_B of local machines and the corresponding training time in DKRR
DKRR_mIndMax = zeros(1,length(NCross));
TrTime_DKRR_mean_mMax = zeros(1,length(NCross));
for i = 1:length(NCross)
    epsilon = testMSE_Baseline_MeanMin(i)*epsRatio;
    Indtmp = find(abs(testMSE_DKRRC_Mean(:,1,i)-testMSE_Baseline_MeanMin(i))<epsilon);
    DKRR_mIndMax(i) = Indtmp(end);
    TrTime_DKRR_mean_mMax(i) = TrTime_DKRR_mean(DKRR_mIndMax(i),i);
end
DKRR_mMax = dNum*DKRR_mIndMax;

% For each N and l, compute the maximum number m_B of local machines and the corresponding training time in DKRRC
for i = 1:length(NCross)
    for k = 1:length(divideCross)
        epsilon = testMSE_Baseline_MeanMin(i)*epsRatio;
        Indtmp = find(abs(testMSE_DKRRC_Mean(k,2:ComNum+1,i)-testMSE_Baseline_MeanMin(i))<epsilon);
        if isempty(find(Indtmp == ComNum, 1)) % juge the convergence
            testMSE_DKRRC_Mean(k,2:ComNum+1,i) = inf; % if it is convergent, the MSE is set as inf
        end
    end
end

DKRRC_mIndMax = zeros(ComNum,length(NCross));
TrTime_DKRRC_mean_mIndMax = zeros(ComNum,length(NCross));
TrTime_DKRRC_mean_m1toIndMaxCell = cell(ComNum,length(NCross));
for i = 1:length(NCross)
    for j = 1:ComNum
        epsilon = testMSE_Baseline_MeanMin(i)*epsRatio;
        Indtmp = find(abs(testMSE_DKRRC_Mean(:,j+1,i)-testMSE_Baseline_MeanMin(i))<epsilon);
        DKRRC_mIndMax(j,i) = Indtmp(end);
        TrTime_DKRRC_mean_mIndMax(j,i) = TrTime_DKRRC_mean(DKRRC_mIndMax(j,i),j,i);
        TrTime_DKRRC_mean_m1toIndMaxCell{j,i} = TrTime_DKRRC_mean(Indtmp,j,i);
    end
end
DKRRC_mMax = dNum*DKRRC_mIndMax;

% Figure 8 The relation between the number of local machines and the training time for fixed numbers of communications.
uuu = 37;
plot(dNum:dNum:dNum*DKRR_mIndMax(uuu),TrTime_DKRR_mean(1:DKRR_mIndMax(uuu),uuu),'m:','linew',5)
colorA = colormap(jet(length(ComNumInd)));
for kk = 1:length(ComNumInd)
    hold on;
    plot(dNum:dNum:dNum*DKRRC_mIndMax(ComNumInd(kk),uuu),TrTime_DKRRC_mean_m1toIndMaxCell{ComNumInd(kk),uuu},'-','color',colorA(kk,:),'linew',3);
end

str1 = cell(1,length(ComNumInd)+1);
str1{1} = 'DKRR';
for i = 1:length(ComNumInd)
    str1{i+1} = ['Com. # ' num2str(ComNumInd(i))];
end
str1{length(ComNumInd)+2} = 'estimated m*';
legend(str1);
xlabel('The number of local machines');
ylabel('The training time (second)');
set(gca,'Ygrid','on');
set(gca,'XLim',[1 49]);
set(gca,'yscale','log');

% Figure 9 The relation between the number of training samples and the maximum number of local machines.
figure;
plot(NCross(3:end),DKRR_mMax(3:end),'m--','linew',2)
colorA = colormap(jet(length(ComNumInd)));
for kk = 1:length(ComNumInd)
    hold on;
    plot(NCross(3:end),DKRRC_mMax(ComNumInd(kk),3:end)','-','color',colorA(kk,:),'linew',6-(kk-1));   
end
str2 = cell(1,length(ComNumInd)+1);
str2{1} = 'DKRR';
for i = 1:length(ComNumInd)
    str2{i+1} = ['Com. # ' num2str(ComNumInd(i))];
end
legend(str2);
xlabel('The number of training samples');
ylabel('The maximum # m_B of local machines');
set(gca,'Ygrid','on');
set(gca,'XLim',[2800 20200]);

% Figure 10. % The relationship between the number of training samples and the training time with optimal number of local machines
figure;
plot(NCross(3:end),TrTime_DKRR_mean_mMax(3:end),'m:','linew',3)
hold on;
colorA = colormap(jet(length(ComNumInd)));
for kk = 1:length(ComNumInd)
    plot(NCross(3:end),TrTime_DKRRC_mean_mIndMax(ComNumInd(kk),3:end)','-','color',colorA(kk,:),'linew',3);
    hold on;
end
str3 = cell(1,length(ComNumInd)+1);
str3{1} = 'DKRR';
for i = 1:length(ComNumInd)
    str3{i+1} = ['Com. # ' num2str(ComNumInd(i))];
end
legend(str3);
xlabel('The number of training samples');
ylabel('Training time (second)');
set(gca,'Ygrid','on');
set(gca,'XLim',[2800 20200]);