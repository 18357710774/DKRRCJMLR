% calculate the kernel matrix.
% X是mxd矩阵，Y是nxd矩阵，每一行表示一个d维数据
% type = 1 : K(x,y) = 1+min(x,y);
%      = 2 : K(x,y) = h(||x-y||_2),
%                       /  (1-t)^4*(4*t+1),    if  0<t<=1
%            其中h(t) = |
%                       \   0                  if  t>1
%      = 4 : K(x,y) = exp{-||x-y||_2^2/(2*Sigma^2)}
function K = KernelComputation(X, Y, KerPara) 
m = size(X,1);
n = size(Y,1);
type = KerPara.KernelType;
if isfield(KerPara,'para')
    para = KerPara.para;
end
switch type
    case 1
       XX = X*ones(1,n);
       YY = ones(m,1)*Y';
       K = ones(m,n) + (XX + YY)/2 - abs(XX - YY)/2;
    case 2
       KK = pdist2(X,Y,'euclidean');
       temp_index = KK>=1;
       K = (1 - KK).^4.*(4*KK + 1);
       K(temp_index) = 0;
    case 3
       KK = pdist2(X,Y,'euclidean');
       temp_index = KK>=1;
       K = (1 - KK).^6.*(35*KK.^2+18*KK+3);
       K(temp_index) = 0;
    case 4
       Sigma = para;
       KK = pdist2(X,Y,'euclidean');
       KK = KK/Sigma;
       K = exp((-KK.^2)/2);    
end
