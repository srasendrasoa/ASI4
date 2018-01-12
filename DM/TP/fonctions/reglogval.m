function ypred = reglogval(X,theta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = size(X,1);
phi_t = [ones(n,1) X];

ypred = zeros(n,1);
score = phi_t*theta;
ypred(score > 0) = 1;

end

