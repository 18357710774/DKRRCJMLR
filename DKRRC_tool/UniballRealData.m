function X = UniballRealData(X,r)
% 先将数据中心化，再将数据模标准化到半径r内
% X的每一行代表一个数据
d = size(X,2);
X = X -  repmat(mean(X,1),size(X,1),1);
Xnorm = sqrt(sum(X.^2,2));
rMax = max(Xnorm);

X = r*X/rMax; %归一化 

