
%Simulation 1 of DKRR with Dimensionality d = 3

%% Generating Data
clear;
clc;

loadPath = cd;
addpath(genpath([loadPath '\DKRRC_tool']));
mkdir('synthetic_results');
% Number of Training Sample
N = 10000;
ExNum = 30;

% optimal parameters
lambdac = 4; 
KernelType = 2;
KerPara.KernelType = KernelType;

Dim = 3;

ComNum = 20; % The number of communications
divideNumCross = 2:2:60; % The number of local machines
testMSE_DKRR = zeros(length(divideNumCross),ExNum);
testMSE_DKRRC = zeros(length(divideNumCross),ComNum+1,ExNum);
testMSE_Baseline = zeros(1,ExNum);

TimeTr_DKRR = cell(length(divideNumCross),ExNum);
TimeTe_DKRR = cell(length(divideNumCross),ExNum);

TimeTr_DKRRC = cell(length(divideNumCross),ExNum);
TimeTe_DKRRC = cell(length(divideNumCross),ExNum);
for Ex = 1:ExNum
    lambda = lambdac/N;
        % set seed
    rand('seed', Ex) 
    randn('seed', Ex)
    % Generating Training Samples
    train_x = rand(N,Dim);
    e = 1/sqrt(5)*randn(N,1);
    train_y = Simf2(train_x)' + e;
    % Generating Test Set
    test_x = rand(1000, Dim);
    test_y = Simf2(test_x)';
    
    %% BaseLine
    hat_y = WKernelRidge2(train_x,train_y,test_x, lambda, KerPara);
    testMSE_Baseline(Ex) = (mean((test_y-hat_y).^2));

    %% DKRR
    for i = 1:length(divideNumCross)
       % Number of Local Machines
        m = divideNumCross(i);
        [Machine, Nvec, Time_tr_tmp] = DKRR_train(train_x, train_y, lambda, m, KerPara);
        TimeTr_DKRR{i,Ex} = Time_tr_tmp;
        
        [hat_y, Time_te_tmp] = DKRR_test(Machine, test_x, m, KerPara, Nvec); 
        TimeTe_DKRR{i,Ex} = Time_te_tmp;            
        testMSE_DKRR(i,Ex) = mean((test_y-hat_y).^2); 
        
        disp(['Tr# ' num2str(N) '    Ex# ' num2str(Ex)  '    m# ' num2str(m) ...
                ':    DKRR_MSE = ' num2str(testMSE_DKRR(i,Ex)) ] );            
    end
    
   %% DKRRC
    for i = 1:length(divideNumCross)
       % Number of Local Machines
        m = divideNumCross(i);
        [Machine, Nvec, Time_tr_tmp] = DKRRC_train(train_x, train_y, lambda, ComNum, m, KerPara);
        TimeTr_DKRRC{i,Ex} = Time_tr_tmp;
        
        [fte_Dlambda, Time_te_tmp] = DKRRC_test(Machine, test_x, lambda, ComNum, m, KerPara, Nvec); 
        TimeTe_DKRRC{i,Ex} = Time_te_tmp;            
        testMSE_DKRRC(i,:,Ex) = mean((fte_Dlambda-test_y*ones(1,ComNum+1)).^2,1); 
        disp(['Tr# ' num2str(N) '    Ex# ' num2str(Ex)  '    m# ' num2str(m) ...
                ':    DKRRCMSE = ' num2str(testMSE_DKRRC(i,6:5:ComNum+1,Ex)) ] );
    end
end
testMSE_Baseline_Mean = mean(testMSE_Baseline);
testMSE_DKRRC_Mean = mean(testMSE_DKRRC,3);
testMSE_DKRR_Mean = mean(testMSE_DKRR,2);

save([loadPath '\synthetic_results\Hsim1.mat'],...
     'ExNum','KernelType','lambdac','N','Dim','ComNum','divideNumCross',...
        'testMSE_DKRR','testMSE_DKRR_Mean','testMSE_DKRRC','testMSE_DKRRC_Mean',...
    'testMSE_Baseline','testMSE_Baseline_Mean','TimeTr_DKRRC',...
        'TimeTr_DKRR', 'TimeTe_DKRRC','TimeTe_DKRR');