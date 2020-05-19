function K = Gkernel(X, Y, Sigma)

% Constructe a kernel matrix based on the Gaussian function.

KK = pdist2(X,Y,'euclidean');

KK = KK/Sigma;

K = exp((-KK.^2)/2);

end