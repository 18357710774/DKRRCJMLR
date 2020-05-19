function y = Simf2(x)

[n, p] = size(x);

for i = 1:n
    r = norm(x(i,:));
if  r <= 1
    y(i) = (1 - r)^6*(35*r^2+18*r+3);
else
    y(i) = 0;
end
end