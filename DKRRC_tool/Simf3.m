function y = Simf3(x)

[n, p] = size(x);

for i = 1:n
    r = norm(x(i,:));
if  r <= 1
    y(i) = (1 - r)^4*(4*r + 1);
else
    y(i) = 0;
end
end