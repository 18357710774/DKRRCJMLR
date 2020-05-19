Xtrain = Wendkernel4(in_data, in_data);
Xtest = Wendkernel4(in_data, test_data);

function K = Wendkernel4(X,Y)

% Constructe a kernel matrix based on the fourth order wendlend function.

KK = pdist2(X,Y,'euclidean');

temp_index = find(KK>=1);

 K = (1 - KK).^6.*(35*KK.^2+18*KK+3);

K(temp_index) = 0;

end