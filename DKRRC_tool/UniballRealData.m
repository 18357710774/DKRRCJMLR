function X = UniballRealData(X,r)
% �Ƚ��������Ļ����ٽ�����ģ��׼�����뾶r��
% X��ÿһ�д���һ������
d = size(X,2);
X = X -  repmat(mean(X,1),size(X,1),1);
Xnorm = sqrt(sum(X.^2,2));
rMax = max(Xnorm);

X = r*X/rMax; %��һ�� 

