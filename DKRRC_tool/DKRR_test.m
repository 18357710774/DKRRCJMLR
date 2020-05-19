function [y_hat, Time_te] = DKRR_test(Machine, test_x, m, KerPara, Nvec)
%% Step2: global estimates
tic;
Ntr = sum(Nvec);
Nr = Nvec/Ntr;
Nte = size(test_x,1);
Xi = zeros(Nte,m);
t_tmp = toc;
t_Step2 = t_tmp;

%% Step1: local estimates
t_Step1 = zeros(m,1);
for k = 1:m
    tic;
    Machine{k}.K_DteDj = KernelComputation(test_x, Machine{k}.train_x, KerPara);
    Xi(:,k) = Machine{k}.K_DteDj*Machine{k}.alpha_j;
    t_tmp = toc;
    t_Step1(k) = t_tmp;
end

%% Step2: global estimates
tic;
y_hat = Xi*Nr;
t_tmp = toc;
t_Step2 = t_Step2+t_tmp;

Time_te.Step1 = t_Step1;
Time_te.Step2 = t_Step2;

