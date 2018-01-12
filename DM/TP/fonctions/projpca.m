function Ct = projpca(X,moy,P)
%projpca Ct = projpca(X,moy,P)
%   moy: la valeur moyenne fournie par la fonction mypca
%   P: la matrice contenant les d premiers vecteurs propres fournis par la fonction mypca
%   C: matrice des composantes principales (projection des xi sur P)


[n,p] = size(X);
X_c = X-ones(n,1)*moy;
Ct = X_c * P;
end

