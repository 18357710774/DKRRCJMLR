function MSE_est = KRR(in_data, out_data, test_data, test_y, lambda, ker)
%
%
% This function performs the Spectral Cutoff regression using the Simple Kernel. 
%
% in_data - Input to the functio to be regressed.  N (points) x D (dimensional)
% out_data - Ouput of the function to be regressed. N x 1 (points)
% test_data - Input of testing set. n (points) x D (dimensions) 
% test_y - Output of testing set. n  x 1 (points)
% lambda - Regularization Parameter. (Carefully choose this)
% 如果lambda输入是一个向量，即表示要计算lambda的参数选择


if nargin < 5
    lambda = 1; % 
end
if nargin < 6
    ker.Type = 4;
    ker.para = 1;
end
lambdaNum = length(lambda);
MSE_est = zeros(1,lambdaNum);
if size(in_data,1) ~= size(out_data,1)
    fprintf('\nTotal number of points for function input and output are unequal');
    fprintf('\n Exitting program');
    return
elseif size(test_data,2) ~= size(in_data,2)
    fprintf('\nTest data and Input data are of unequal dimensions');
    fprintf('\nExitting program')
    return
else
     N = size(in_data,1);
    %% Compute K(x,x') on training set  
    Ktr = KernelComputation(in_data, in_data, ker.Type, ker.para);
    Ktr = (Ktr+Ktr')/2;
    %% Compute K(x, x') on training and testing set
    Ktetr = KernelComputation(test_data, in_data, ker.Type, ker.para);
    %% Compute alpha
    [U, S] = svd(Ktr, 'econ'); % Ktr = U*S*U'
    diagS = diag(S);
    for k = 1:lambdaNum
        lambdac = lambda(k);
        KlambdaInv = U*diag(1./(diagS+N*lambdac))*U';
        alpha = KlambdaInv*out_data;
        
        %% Compute hat_y
        hat_y = Ktetr*alpha;
        MSE_est(k) = mean((hat_y-test_y).^2);
        
%         hat_y1 = Ktetr*((Ktr + lambdac*eye(N)*N)^(-1)*out_data); 
%         MSE_est1(k) = mean((hat_y-test_y).^2);
    end
      
end

