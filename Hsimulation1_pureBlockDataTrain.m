%Local approximation (Dimensionality d = 3)
clear;
clc;

loadPath = cd;
addpath(genpath([loadPath '\DKRRC_tool']));

% Number of Training Sample
N = 10000;
ExNum = 30;

% optimal parameters
lambdac = 4; 
KernelType = 2;
KerPara.KernelType = KernelType;

Dim = 3;

divideNumCross = 2:2:60; % The number of local machines
testMSE_PureBlockData = zeros(length(divideNumCross),ExNum);
for Ex = 1:ExNum
    lambda = lambdac/N;
        % set seed
    rand('seed', Ex) 
    randn('seed', Ex)
    % Generating pure Training Samples
    train_x = rand(N,Dim);
    train_y = Simf2(train_x)';
    
    % Generating Test Set
    test_x = rand(1000, Dim);
    test_y = Simf2(test_x)';
    
    %% BlockData MSE
    for i = length(divideNumCross)
       % Number of Local Machines
        m = divideNumCross(i);
     
        Nvec = zeros(m,1);
        n = floor(N/m); 
        for k = 1:m-1
            Nvec(k) = n;
        end
        Nvec(m) = N-n*(m-1);
        Nr = Nvec/N; 
        
        count = 0;
        for BlockNum = 1:m
            IndData{BlockNum} = count+1:count+Nvec(BlockNum);
            count = count+Nvec(BlockNum);
        end

        for BlockNum = 1:m
             hat_y = WKernelRidge2(train_x(IndData{BlockNum},:),train_y(IndData{BlockNum},:),test_x, lambda, KerPara);
             testMSE_PureBlockDataTemp(BlockNum)  =  (mean((test_y-hat_y).^2));
            
        end
        testMSE_PureBlockDataIter{i}(:,Ex) = testMSE_PureBlockDataTemp;
        testMSE_PureBlockData(i,Ex) = mean(testMSE_PureBlockDataTemp);
        
        disp(['Tr# ' num2str(N) '    Ex# ' num2str(Ex)  '    m# ' num2str(m) ...
                ':    MSE = ' num2str(testMSE_PureBlockData(i,Ex)) ] );
            
        clear testMSE_PureBlockDataTemp
    end
end
save([loadPath '\synthetic_results\Hsim1_BlockPureData.mat'],...
                'lambda','ExNum','KernelType','divideNum','Dim',...
                'testMSE_PureBlockData','testMSE_PureBlockDataIter');