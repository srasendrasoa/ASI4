function [ C,clusters,Jw ] = kmoyennes( X,CO,K,seuil)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    C = CO;
    iter = 1;
    Jcourant=1*10^3; %arbitraire
    Jold = 1*10^3+10*seuil; %arbitraire
    while (Jold-Jcourant) > seuil
        Jold=Jcourant;
        [clusters,Jcourant]=affectation(X,C,K);
        Jw(iter)=Jcourant;
        C=nouveaux_centres(X,clusters);
        iter=iter+1;
    end 

end

