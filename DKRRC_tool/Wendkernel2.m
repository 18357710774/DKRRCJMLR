function K = Wendkernel2(X,Y)

% Constructe a kernel matrix based on the seciond order wendlend function.

KK = pdist2(X,Y,'euclidean');

temp_index = find(KK>=1);

K = (1 - KK).^4.*(4*KK + 1);

K(temp_index) = 0;

end