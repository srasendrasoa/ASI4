function C = nouveaux_centres( X,clusters )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    classcode = unique(clusters);
    K = length(classcode);
    for k=1:K 
        indices = find(clusters==classcode(k));
        centreK=mean(X(indices,:));
        C(k,:)=centreK;
    end
end

