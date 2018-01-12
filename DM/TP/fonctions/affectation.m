function [clusters, Jw] = affectation(X,C,K)
%affectation    [clusters, Jw] = affectation(X,C,K)
%   X: matrice des donnés
%   K: centres de gavité dans la matrice C
%   Jw : critère d'inertie intra-classe
%   clusters : les clusters


    N = size(X,1);
    Jw=0;
    for i=1:N
        for k=1:K
            d(k)= norm(X(i,:)-C(k,:),2)^2;
        end
        [val,indice] = min(d);
        clusters(i) = indice;
        Jw = Jw+val;
    end
end

