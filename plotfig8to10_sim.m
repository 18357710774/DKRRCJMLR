clear;clc;
load([cd '\synthetic_results\sim2_Baseline_paraSel_VaryTrNum.mat'],'testMSE_Baseline_Mean');
testMSE_Baseline_MeanMin = min(testMSE_Baseline_Mean,[],2);
load([cd '\synthetic_results\sim2and3_TrNumVary_timeComplexity.mat'],'testMSE_DKRRC_Mean','TimeTe_DKRRC','TimeTr_DKRRC');

NCross = 2000:500:20000;
ExNum = 30;
Dim = 1;
ComNum = 50; % The number of communications
divideCross = 20:20:600; % The range of the number of local machines
dNum = 20;
ComNumInd = [2 4 8 16 32]; % The selected number of communications
epsRatio = 0.05;

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

% For each N and l, compute the estimated optimal number m_star of local machines
m_star = zeros(ComNum,length(NCross));
m_star_hat = m_star;
m_star_ind = m_star;
for i = 1:length(NCross)
    for  j = 1:ComNum
        N = NCross(i);
        l = j;
        aa = kappa+l;
        bb = sqrt(aa^2+12*l);
        cc = (aa+bb)/(2*l);
        m_star(j,i) = round(sqrt(cc*N));
        m_star_ind(j,i) = ceil(m_star(j,i)/dNum);
        m_star_hat(j,i) = m_star_ind(j,i)*dNum;
    end
end

% For each N and l, compute the training time of DKRRC with m_star local machines 
TrTime_DKRRC_mean_opt = zeros(ComNum,length(NCross));
for i = 1:length(NCross)
    for j = 1:ComNum
        TrTime_DKRRC_mean_opt(j,i) = TrTime_DKRRC_mean(m_star_ind(j,i),j+1,i);
    end
end

% Figure 8 The relation between the number of local machines and the training time for fixed numbers of communications.
uuu = 37;
plot(dNum:dNum:dNum*DKRR_mIndMax(uuu),TrTime_DKRR_mean(1:DKRR_mIndMax(uuu),uuu),'m:','linew',5)
colorA = colormap(jet(length(ComNumInd)));
for kk = 1:length(ComNumInd)
    hold on;
    plot(dNum:dNum:dNum*DKRRC_mIndMax(ComNumInd(kk),uuu),TrTime_DKRRC_mean_m1toIndMaxCell{ComNumInd(kk),uuu},'-','color',colorA(kk,:),'linew',3);
end
% plot the estimated m_star
m_star_hat_sel = zeros(1,length(ComNumInd));
TrTime_DKRRC_mean_sel = zeros(1,length(ComNumInd));
for kk = 1:length(ComNumInd)
    m_star_hat_sel(kk) = m_star_hat(ComNumInd(kk),uuu);
    TrTime_DKRRC_mean_sel(kk) = TrTime_DKRRC_mean_m1toIndMaxCell{ComNumInd(kk),uuu}(m_star_ind(ComNumInd(kk),uuu));
end
hold on;
plot(m_star_hat_sel,TrTime_DKRRC_mean_sel,'rp','Markersize',10)
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
set(gca,'XLim',[10 510]);

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
    plot(NCross(3:end),TrTime_DKRRC_mean_opt(ComNumInd(kk),3:end)','-','color',colorA(kk,:),'linew',3);
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