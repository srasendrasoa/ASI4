function Xhat = reconstructpca(C,P,moy)
%reconsructpca Xhat = reconstructpca(C,P,moy)
%   P: la matrice contenant les d premiers vecteurs propres fournis par la fonction mypca
%   C: matrice des composantes principales fournie par la fonction projpca


[n,p]=size(C);
Xhat = C*P'+ones(n,1)*moy;
end

