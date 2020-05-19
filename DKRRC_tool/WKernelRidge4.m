function [hat_y,d] = WKernelRidge4(in_data,out_data,test_data,lamda)
%
% This function performs the kernel ridge regression using the 4th order Wendlan Kernel. 
%
% in_data - Input to the functio to be regressed.  N (points) x D (dimensional)
% out_data - Ouput of the function to be regressed. N x 1 (points)
% test_data - Input of testing set. n (points) x D (dimensions) 
% lamda - Regularization Parameter. (Carefully choose this)
% hat_y - Output for the testing set test_data (those that were not in training) n x 1 (points)  


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
    n = size(test_data, 1);
     % Construct Kernel Matrix for Training and Testing Sets
    Xtrain = Wendkernel4(in_data, in_data);
    Xtest = Wendkernel4(in_data, test_data);
    %% Compute hat_y
    hat_y = Xtest'*(Xtrain*Xtrain' + lamda*eye(N))^(-1)*Xtrain'*out_data;
end

