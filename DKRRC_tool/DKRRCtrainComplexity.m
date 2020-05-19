function y = DKRRCtrainComplexity(m,N,kap,l)
y = N^2*kap./m+N^3./(m.^3)+N^2*l./m+m*N*l;