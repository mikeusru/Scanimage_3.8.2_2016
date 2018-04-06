function y = Twogauss(beta0, x);

global spc;

y1 = beta0(2)*exp(-(x-beta0(3)).^2/2/beta0(4)^2);
y2 = beta0(5)*exp(-(x-beta0(6)).^2/2/beta0(7)^2);

y = y1+y2+beta0(1);