function [valprop,U,moy] = mypca(X)
%mypca [valprop,U,moy] = mypca(X)
%   X: données
%   valprop: valeurs propres de la matrice de covariance triées dans l’ordre décroissant
%   U: la matrice des vecteurs propres (respectant l’ordre des valeurs propres)
%   moy: la valeur moyenne des D variables xj



[n,p] = size(X);
%calcul moyenne x
moy = mean(X);
%centrer
X = X-ones(n,1)*moy;
%matrice de covariance
sigma_cov = cov(X);
%decomposition
[vecteur_propre,p_values] = eig(sigma_cov);
%tri valeurs propres 
vect_val_propre = diag(p_values);
[valprop,index] = sort(vect_val_propre,1,'descend');
U = vecteur_propre(:,index);
end

