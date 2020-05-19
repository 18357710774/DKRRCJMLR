function MSE_est = NuMethod(in_data, out_data, test_data, test_y, iterMax, nu, ker)
%
%
% This function performs the Iterative Landweber regression using the Simple Kernel. 
%
% in_data - Input to the functio to be regressed.  N (points) x D (dimensional)
% out_data - Ouput of the function to be regressed. N x 1 (points)
% test_data - Input of testing set. n (points) x D (dimensions) 
% test_y - Output of testing set. n  x 1 (points)
% iterMax - Regularization Parameter. (Carefully choose this)
% nu - is not an important parameter
% hat_y - Output for the testing set test_data (those that were not in training) n x 1 (points)  
DISPLAYNUM = 100;
if nargin < 4
    iterMax = 1000;
end
if nargin < 5
    nu = 5; % 
end
if nargin < 6
    ker.Type = 4;
    ker.para = 1;
end
dif = zeros(1,iterMax);
MSE_est = zeros(1,iterMax);
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
    %% Compute K(x, x') on training and testing set
    Ktetr = KernelComputation(test_data, in_data, ker.Type, ker.para);
    %% Compute alpha
    alpha0 = zeros(N,1);
    alpha1 = zeros(N,1);
    for k = 1:iterMax
        u = (k-1)*(2*k-3)*(2*k+2*nu-1)/(k+2*nu-1)/(2*k+4*nu-1)/(2*k+2*nu-3);
        w = 4*(2*k+2*nu-1)*(k+nu-1)/(k+2*nu-1)/(2*k+4*nu-1);
        alpha_new = alpha1+u*(alpha1-alpha0)+w*(out_data-Ktr*alpha1)/N;
        dif(k) = norm(alpha_new-alpha1)/norm(alpha1);
        %% Compute hat_y
        hat_y = Ktetr*alpha_new;
        MSE_est(k) = mean((hat_y-test_y).^2);
        alpha0 = alpha1;
        alpha1 = alpha_new;
       if mod(k,DISPLAYNUM) == 0
            disp(['iter# ' num2str(k) ': MSE_est = ' num2str(MSE_est(k)) '   dif = ' num2str(dif(k))]);
        end
    end    
end

