function ypred = reglogval(X,theta)
% X = Matrices des données
% theta = paramètre (vecteur)
% ypred = le vecteur des labels prédits
n = size(X,1);
phi_t = [ones(n,1) X];

ypred = zeros(n,1);
score = phi_t*theta;
ypred(score > 0) = 1;

end

