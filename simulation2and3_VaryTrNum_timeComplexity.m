%Simulation 3 of DKRR with Dimensionality d = 1

clear;
clc;
loadPath = cd;
addpath(genpath([loadPath '\DKRRC_tool']));

% Number of Training Sample
NCross = 2000:500:20000;
ExNum = 30;
Dim = 1;
KernelType = 1;
KerPara.KernelType = KernelType;
% optimal parameters
lambdacSel = [5*ones(1,8) 10*ones(1,22) 15*ones(1,7)];

ComNum = 50; % The number of communications
divideCross = 20:20:600;  % The number of local machines

testMSE_DKRRC = cell(1,length(NCross));
testMSE_DKRRC_Mean = zeros(length(divideCross),ComNum+1,length(NCross));

TimeTr_DKRRC = cell(1,length(NCross));
TimeTe_DKRRC = cell(1,length(NCross));

for vv = 1:length(NCross)
    N = NCross(vv);
    testMSE_DKRRC_temp = zeros(length(divideCross),ComNum+1,ExNum);
    lambda = lambdacSel(vv)/N; 
    
    Time_tr = cell(length(divideCross),ExNum);
    Time_te = cell(length(divideCross),ExNum);
    for Ex = 1:ExNum
            % set seed
        rand('seed', Ex) 
        randn('seed', Ex)
        % Generating Training Samples
        train_x = rand(N,Dim);
        e = 1/sqrt(5)*randn(N,1);
        train_y = Simf1(train_x) + e;
        % Generating Test Set
        test_x = rand(1000, Dim);
        test_y = Simf1(test_x);

        %% DKRRC
        uu = 0;
        for m = divideCross
           % Number of Local Machines
            uu = uu+1;
            [Machine, Nvec, Time_tr_tmp] = DKRRC_train(train_x, train_y, lambda, ComNum, m, KerPara);
            Time_tr{uu,Ex} = Time_tr_tmp;
            
            [fte_Dlambda, Time_te_tmp] = DKRRC_test(Machine, test_x, lambda, ComNum, m, KerPara, Nvec); 
            Time_te{uu,Ex} = Time_te_tmp;
            testMSE_DKRRC_temp(uu,:,Ex) = mean((fte_Dlambda-test_y*ones(1,ComNum+1)).^2,1);
            
            disp(['Tr# ' num2str(N) '    Ex# ' num2str(Ex)  '    m# ' num2str(m) ...
                ':    MSE = ' num2str(testMSE_DKRRC_temp(uu,11:10:51,Ex))] );
        end
    end
    TimeTr_DKRRC{vv} = Time_tr;
    TimeTe_DKRRC{vv} = Time_te;
    testMSE_DKRRC{vv} = testMSE_DKRRC_temp;
    testMSE_DKRRC_Mean(:,:,vv) = mean(testMSE_DKRRC_temp,3);
    
    save([loadPath '\synthetic_results\sim2and3_TrNum' num2str(N) '_timeComplexity.mat'],'ExNum','KernelType','ComNum','divideCross','NCross',...
        'testMSE_DKRRC','testMSE_DKRRC_Mean','TimeTr_DKRRC','TimeTe_DKRRC','lambdacSel');
end