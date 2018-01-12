

clear all, close all, clc
vmu1 = [0 0]';
vmu2 = [2 2]';
SIGMA = [1 0.5;0.5 4];

N = 100;
% generation de donnees aleatoires suivant lois gaussiennes
X1 =  mvnrnd(vmu1,SIGMA,N); Y1 = ones(N,1);  % classe 1
X2 =  mvnrnd(vmu2,SIGMA,N); Y2 = -ones(N,1); % classe 2

% on met les données bout à bout
X = [X1; X2];
Ytrue = [Y1; Y2];

figure(1),
hold on
plot(X1(:,1), X1(:,2), 'ro', 'markersize', 6, 'markeredgecolor', 'r', 'markerfacecolor','r')
plot(X2(:,1), X2(:,2), 'bs', 'markersize', 6, 'markeredgecolor', 'b', 'markerfacecolor','b')
plot(vmu1(1), vmu1(2), 'sr','markersize', 12, 'markeredgecolor', 'k', 'markerfacecolor','y')
plot(vmu2(1), vmu2(2), 'd', 'markersize', 12, 'markeredgecolor', 'k', 'markerfacecolor','g')
legend('classe 1', 'classe 2')

%% Frontiere de decision theorique de Bayes
% param de l'hyperplan 
% proba a priori
pi1 = 0.5;
pi2 = 1-pi1;
w = SIGMA\(vmu1 - vmu2);
wo1 = -0.5*vmu1'*(SIGMA\vmu1) + log(pi1);
wo2 = -0.5*vmu2'*(SIGMA\vmu2) + log(pi2);
wo = wo1 - wo2;

% calcul prediction sur les données d'apprentissage
gpoints = X*w + wo;
Ypred = sign(gpoints);

% calcul de l'erreur
err = 100*sum(Ytrue ~= Ypred)/length(Ytrue)
precision = 100*sum(Ytrue == Ypred)/length(Ytrue)

%return







% calcul matrice de confusion
classcode = unique(Ytrue); % la vraie classe des données (app, val ou test)
nclass = length(classcode);
MatConfTh = zeros(nclass, nclass); % initialiser la matrice de confusion
for i = 1 : nclass
    for j = 1 : nclass
        MatConfTh(i, j) = sum((Ytrue == classcode(i)).*(Ypred == classcode(j)));
    end
end

TauxErreur = 100*(MatConfTh(1,2) + MatConfTh(2,1))/(sum(sum(MatConfTh)))

Precision = 100*(sum(diag(MatConfTh)))/(sum(sum(MatConfTh)))


% Trace des lignes de niveau de la distribution conditionnelle des donnees
% selon les classes
M = 50;
% definition du maillage du plan
[auxdim1, auxdim2]=meshgrid(linspace(-8, 8, M)); 
auxdata = [reshape(auxdim1,M*M,1) reshape(auxdim2,M*M,1)]; 

% % evaluation des lois conditionnnelles pour leur trace
% % classe 1 p(x/c1)
%  pxC1 = mvnpdf(auxdata, vmu1', SIGMA);
% % % classe 2 p(x/c2)
% pxC2 = mvnpdf(auxdata, vmu2', SIGMA);
% % trace du contour
% % de p(x/C1)
% [c,h]=contour(auxdim1, auxdim2, reshape(pxC1,M,M), 'r'); hold on
% clabel(c,h)
% % de p(x/C2)
% [c,h]=contour(auxdim1, auxdim2, reshape(pxC2,M,M), 'b'); hold on

% trace frontiere theorique de bayes selon la grille
gx = auxdata*w + wo;
[c,h]=contour(auxdim1, auxdim2, reshape(gx,M,M), [0 0]);
set(h, 'linewidth', 1.5, 'color', 'g')
clabel(c,h)


%% Utilisation de l'estimation des parametres
% proba a priori
pi1 = length(find(Ytrue==1))/length(Ytrue);
pi2 = 1-pi1;
estmu1 = mean(X1)';
estmu2 = mean(X2)';
estSIGMA = (cov(X1)+cov(X2))/2;


% param de l'hyperplan 
estw = estSIGMA\(estmu1 - estmu2);
estwo1 = -0.5*estmu1'*(estSIGMA\estmu1) + log(pi1);
estwo2 = -0.5*estmu2'*(estSIGMA\estmu2) + log(pi2);
estwo = estwo1 - estwo2;
% trace selon la grille
%gx = auxdata*estw + estwo;
%[c,h]=contour(auxdim1, auxdim2, reshape(gx,M,M), [0 0], 'c--');
%set(h, 'linewidth', 1.5)
%clabel(c,h)

% calcul erreur
gpoints = X*estw + estwo;

Ypred = sign(gpoints);

% calcul matrice de confusion
classcode = unique(Ytrue); % la vraie classe des données (app, val ou test)
nclass = length(classcode);
MatConfPratique = zeros(nclass, nclass); % initialiser la matrice de confusion
for i = 1 : nclass
    for j = 1 : nclass
        MatConfPratique(i, j) = sum((Ytrue == classcode(i)).*(Ypred == classcode(j)));
    end
end

TauxErreur = 100*(MatConfPratique(1,2) + MatConfPratique(2,1))/(sum(sum(MatConfPratique)))

Precision = 100*(sum(diag(MatConfPratique)))/(sum(sum(MatConfPratique)))

ind = find((Ytrue.*gpoints) < 0);
estTauxErreur = length(ind)/length(Ytrue);

%% proba a posteriori
% lois cdtionnelles
% pxC1pts = mvnpdf(X, vmu1', SIGMA);
% pxC2pts = mvnpdf(X, vmu2', SIGMA);
% % loi marginale
% px = pxC1pts*pi1 + pxC2pts*pi2;
% % proba a posteriori
% pC1x = (pxC1pts*pi1)./px;
% pC2x = 1 - pC1x;

