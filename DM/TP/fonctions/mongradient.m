function d = mongradient(t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    d=zeros(2,1);
    d=[400*t(1).^3+2*t(1)*(1-200*t(2))-2;200*(t(2)-t(1)^2)];

end

