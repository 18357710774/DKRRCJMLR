function [Machine, Nvec, Time_tr] = DKRRC_train(train_x, train_y, lambda, ComNum, m, KerPara, Nvec)
N = size(train_x,1);
if nargin < 7
    % Data division, 如果没有特殊要求，按照平均分配
    Nvec = zeros(m,1);
    n = floor(N/m); 
    for k = 1:m-1
        Nvec(k) = n;
    end
    Nvec(m) = N-n*(m-1);
end


Nr = Nvec/N; 
f_Dlambda = zeros(N,ComNum+1); % 第一列为没有交流时训练样本的函数值
Xi = zeros(N,m);

%% Step 1: local process -- initialization
t_Step1 = zeros(m,1);
Machine = cell(1,m);
count = 0;
for k = 1:m
    tic;
    Machine{k}.IndData = count+1:count+Nvec(k);
    Machine{k}.train_x = train_x(Machine{k}.IndData,:);
    Machine{k}.train_y = train_y(Machine{k}.IndData,:);
    Machine{k}.K_DDj = KernelComputation(train_x, Machine{k}.train_x, KerPara);
    Machine{k}.K_DjDj = Machine{k}.K_DDj(Machine{k}.IndData,:);
    Machine{k}.M_Dj = inv( Machine{k}.K_DjDj + lambda*Nvec(k)*eye(Nvec(k)) );
    Machine{k}.alpha_j = Machine{k}.M_Dj*Machine{k}.train_y;
    Xi_tmp = Machine{k}.K_DDj*Machine{k}.alpha_j;
    count = count+Nvec(k);
    t_tmp = toc;
    t_Step1(k) = t_tmp;
    Xi(:,k) = Xi_tmp;
end

%% Step 2: synthesization
tic;
f_Dlambda_tmp = Xi*Nr;
t_tmp = toc;
t_Step2 = t_tmp;

f_Dlambda(:,1) = f_Dlambda_tmp;

t_Step5 = zeros(1,ComNum);
t_Step7 = zeros(1,ComNum);
t_Step4 = zeros(m,ComNum);
t_Step6 = zeros(m,ComNum);
for iterNum = 1:ComNum
    G_Dlambda = zeros(N,m);
    %% Step 4: local gradients
    for k = 1:m
        f_DlamDj_tmp = f_Dlambda(Machine{k}.IndData,iterNum);
        f_Dlambda_tmp = f_Dlambda(:,iterNum);
        tic
        eta_j_tmp = f_DlamDj_tmp - Machine{k}.train_y;
        G_Dlambda_tmp = Machine{k}.K_DDj*eta_j_tmp/Nvec(k) + lambda*f_Dlambda_tmp;
        t_tmp = toc;
        t_Step4(k,iterNum) = t_tmp;
        Machine{k}.eta_j(:,iterNum) = eta_j_tmp;
        G_Dlambda(:,k) = G_Dlambda_tmp;        
%         tic
%         Machine{k}.f_DlamDj(:,iterNum) = f_Dlambda(Machine{k}.IndData,iterNum);
%         Machine{k}.eta_j(:,iterNum) = Machine{k}.f_DlamDj(:,iterNum) - Machine{k}.train_y;        
%         G_Dlambda(:,k) = Machine{k}.K_DDj*Machine{k}.eta_j(:,iterNum)/Nvec(k) + lambda*f_Dlambda(:,iterNum);
%         t_tmp = toc;
%         t_Step4(k,iterNum) = t_tmp;
    end
    
    %% Step 5: synthesizing gradients
    tic
    g_Dlambda = G_Dlambda*Nr;
    t_tmp = toc;
    t_Step5(iterNum) = t_Step5(iterNum)+t_tmp;
    H_Dlambda = zeros(N,m);
    
    %% Step 6: KRR on gradient data
    for k = 1:m 
        g_Dlambda_tmp = g_Dlambda(Machine{k}.IndData,:);
        tic
        beta_j_tmp = Machine{k}.M_Dj*g_Dlambda_tmp;
        H_Dlambda_tmp = g_Dlambda - Machine{k}.K_DDj*beta_j_tmp;
        t_tmp = toc;
        t_Step6(k,iterNum) = t_tmp;
        Machine{k}.beta_j(:,iterNum) = beta_j_tmp;
        H_Dlambda(:,k) = H_Dlambda_tmp;
%         tic
%         Machine{k}.beta_j(:,iterNum) = Machine{k}.M_Dj*g_Dlambda(Machine{k}.IndData,:);
%         H_Dlambda(:,k) = g_Dlambda - Machine{k}.K_DDj*Machine{k}.beta_j(:,iterNum);
%         t_tmp = toc;
%         t_Step6(k,iterNum) = t_tmp;
    end
    
    %% Step 7: final estimator
    f_Dlambda_tmp = f_Dlambda(:,iterNum);
    tic
    f_Dlambda_tmp = f_Dlambda_tmp-H_Dlambda*Nr/lambda;
    t_tmp = toc;
    t_Step7(iterNum) = t_tmp;
    f_Dlambda(:,iterNum+1) = f_Dlambda_tmp;
%     tic
%     f_Dlambda(:,iterNum+1) = f_Dlambda(:,iterNum)-H_Dlambda*Nr/lambda;
%     t_tmp = toc;
%     t_Step7(iterNum) = t_tmp;
end
Time_tr.Step1 = t_Step1;
Time_tr.Step2 = t_Step2;
Time_tr.Step4 = t_Step4;
Time_tr.Step5 = t_Step5;
Time_tr.Step6 = t_Step6;
Time_tr.Step7 = t_Step7;