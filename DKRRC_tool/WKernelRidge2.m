function hat_y = WKernelRidge2(in_data,out_data,test_data,lamda,KerPara)
%
% This function performs the kernel ridge regression using the 2nd order Wendlan Kernel. 
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
    %% Compute K(x,x') on training set  
    Ktr = KernelComputation(in_data, in_data, KerPara);
    %% Compute K(x, x') on training and testing set
    Ktetr = KernelComputation(test_data,in_data,KerPara);
    %% Compute hat_y
    hat_y = Ktetr*((Ktr + lamda*eye(N)*N)^(-1)*out_data);
end

