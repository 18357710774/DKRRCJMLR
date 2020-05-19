function [Machine, Nvec, Time_tr] = DKRR_train(train_x, train_y, lambda, m, KerPara, Nvec)
N = size(train_x,1);
if nargin < 6
    % Data division, 如果没有特殊要求，按照平均分配
    Nvec = zeros(m,1);
    n = floor(N/m); 
    for k = 1:m-1
        Nvec(k) = n;
    end
    Nvec(m) = N-n*(m-1);
end

Time_tr = zeros(m,1);
Machine = cell(1,m);
count = 0;
for k = 1:m
    tic;
    Machine{k}.IndData = count+1:count+Nvec(k);
    Machine{k}.DataNum = Nvec(k);
    Machine{k}.train_x = train_x(Machine{k}.IndData,:);
    Machine{k}.train_y = train_y(Machine{k}.IndData,:);
    Machine{k}.K_DjDj = KernelComputation(Machine{k}.train_x, Machine{k}.train_x, KerPara);
    Machine{k}.M_Dj = inv( Machine{k}.K_DjDj + lambda*Nvec(k)*eye(Nvec(k)) );
    Machine{k}.alpha_j = Machine{k}.M_Dj*Machine{k}.train_y;
    count = count+Nvec(k);
    t_tmp = toc;
    Time_tr(k) = t_tmp;
end