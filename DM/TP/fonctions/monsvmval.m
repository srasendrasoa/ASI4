
function ypred = monsvmval(Xv, w, b)

% Xv : matrice des donnees de validation de dimension Nv x d
% w, b parametres du svm avec w vecteur de dim d et b scalaire

ypred = Xv*w + b;
