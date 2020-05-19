function [fte_Dlambda, Time_te] = DKRRC_test(Machine, test_x, lambda, ComNum, m, KerPara, Nvec)

Ntr = sum(Nvec);
Nr = Nvec/Ntr;
Nte = size(test_x,1);
Xi = zeros(Nte,m);
fte_Dlambda = zeros(Nte,ComNum+1);

%% Step1: local estimates
t_Step1 = zeros(m,1);
for k = 1:m
    tic;
    Machine{k}.K_DteDj = KernelComputation(test_x, Machine{k}.train_x, KerPara);
    Xi_tmp = Machine{k}.K_DteDj*Machine{k}.alpha_j;
    t_tmp = toc;
    t_Step1(k) = t_tmp;
    Xi(:,k) = Xi_tmp;
end

%% Step2: global estimates
tic;
fte_Dlambda_tmp = Xi*Nr;
t_tmp = toc;
t_Step2 = t_tmp;
fte_Dlambda(:,1) = fte_Dlambda_tmp;

t_Step3 = zeros(m,ComNum);
t_Step45 = zeros(1,ComNum);

for iterNum = 1:ComNum

    fte_DlambdaTemp = zeros(Nte,m);
    
    %% Step3: local gradients
    for k = 1:m
        beta_j_tmp =  Machine{k}.beta_j(:,iterNum);
        eta_j_tmp = Machine{k}.eta_j(:,iterNum);
        tic;
        fte_DlambdaTemp_tmp = Machine{k}.K_DteDj * (beta_j_tmp*Nr(k) - eta_j_tmp/Ntr);
        t_tmp = toc;
        t_Step3(k,iterNum) = t_tmp;
        fte_DlambdaTemp(:,k) = fte_DlambdaTemp_tmp;       
%         tic;
%         fte_DlambdaTemp(:,k) = Machine{k}.K_DteDj * (Machine{k}.beta_j(:,iterNum)*Nr(k) - Machine{k}.eta_j(:,iterNum)/Ntr);
%         t_tmp = toc;
%         t_Step3(k,iterNum) = t_tmp;
    end
    
    %%  Step4 and Step 5: final estimator
    tic;
    fte_Dlambda_tmp =  sum(fte_DlambdaTemp,2)/lambda;
    t_tmp = toc;
    t_Step45(iterNum) = t_tmp;
    fte_Dlambda(:,iterNum+1) = fte_Dlambda_tmp;
%     tic;
%     fte_Dlambda(:,iterNum+1) =  sum(fte_DlambdaTemp,2)/lambda;
%     t_tmp = toc;
%     t_Step45(iterNum) = t_Step45(iterNum)+t_tmp;
end
Time_te.Step1 = t_Step1;
Time_te.Step2 = t_Step2;
Time_te.Step3 = t_Step3;
Time_te.Step45 = t_Step45;

