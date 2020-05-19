
%Simulation 1 of DKRR with Dimensionality d = 3

%% Generating Data
clear;
clc;

ExNum = 30;
lambdacCross = 2:2:10; % The range of the parameter lambda
KernelType = 2;
KerPara.KernelType = KernelType;
NCross = 2000:500:20000; % Numbers of training samples

testMSE_Baseline = zeros(ExNum,length(lambdacCross),length(NCross));

vv = 0;
for N = NCross
    vv = vv+1;
    for Ex = 1:ExNum
        kk = 0;
        for lambdac = lambdacCross
            kk = kk+1;
            lambda = lambdac/N;
            % set seed
            tic;
            rand('seed', Ex) 
            randn('seed', Ex)
            % Generating Training Samples
            train_x = rand(N,3);
            e = 1/sqrt(5)*randn(N,1);
            train_y = Simf2(train_x)' + e;
            % Generating Test Set
            test_x = rand(1000, 3);
            test_y = Simf2(test_x)';

           %% BaseLine
            hat_y = WKernelRidge2(train_x,train_y,test_x, lambda, KerPara);
            % Compute MSE
            testMSE_Baseline(Ex,kk,vv) = (mean((test_y-hat_y).^2));
            t = toc;
            disp(['Tr# ' num2str(N) '    Ex# ' num2str(Ex) 'lambdac# ' num2str(lambdac)...
                '  BaselineMSE:   ' num2str( testMSE_Baseline(Ex,kk,vv)) ...
                '    timecosts = ' num2str(t)]);
        end
    end
    save Hsim2_Baseline_paraSel_VaryTrNum.mat
end

