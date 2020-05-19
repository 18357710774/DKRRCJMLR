function y = Simf1(x)
if ~all(x<=1)
    fprintf('Wrong Evaluation!\n');
end
y = x;
indtemp = x>0.5;
y(indtemp) = 1- x(indtemp);