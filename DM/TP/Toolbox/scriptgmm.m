
% mon TP Kmeans

clear all, close all, clc

% ajout du chemin de la toolbox
addpath(genpath('./netlab'))

%%% les donnees
vmu1 = [0 0]';
vmu2 = [2 2]';
SIGMA = eye(2);

load('george.dat');
load('ds2.dat');

n = 50;
% generation de donnees aleatoires suivant lois gaussiennes
% X1 =  mvnrnd(vmu1,SIGMA,n);   % classe 1
% X2 =  mvnrnd(vmu2,SIGMA,n);    % classe 2
X1 = george;

figure(1), plot(X1(:,1), X1(:,2), 'bp', 'markersize', 8)
% hold on
% plot(X2(:,1), X2(:,2), 'ro', 'markersize', 8)
title('La v�rit� vraie','fontsize', 14)
% on concatene les donn�es (on suppose qu'on ne sait pas quel
% point est du cluster 1 ou 2
%X = [X1; X2];
%X = ds2;
X=george;
% ------------- Definition du modele gmm -------------
% Nombre de clusters
nbclusters = 2;
dim = size(X, 2);
covar_type = 'full'; % 'diag', 'spherical' of 'full'

% Creation du modele 
mixgauss = gmm(dim, nbclusters, covar_type);

% Options pour le GMM
options = foptions; 
options(1) = 1; % affichage (1) ou non (0) au fil des iterations

% ------------- Initialisation -------------
initKmeans = 2; % 1 on initialise avec quelques iterations de K-means
if initKmeans
    % Initialisation des centres via Kmeans, les matrices de covariance
    % sont calculees de fa�on correspondante
    options(14) = 2; % 
    mixgauss = gmminit(mixgauss, X, options);
else
    % initialisation aleatoire des centres, les matrices de covariance = I
    N = size(X, 1);
    index = randperm(N);
    mixgauss.centres = X(index(1:nbclusters), :);
end

% Trace des clusters et centres initiaux 
clusters=affectation(X,mixgauss.centres,nbclusters);
% affichage des clusters
plotclusters(clusters, X, nbclusters);
title('Initialisation')
% trace des centres initiaux
figure(gcf)
for k=1:nbclusters
    plot(mixgauss.centres(k,1), mixgauss.centres(k,2), 'ks', 'markersize', 18, 'markerfacecolor', 'y');
end
% Trace des ellipses
plotcovariances(mixgauss)

% ------------- Algo EM -----------------
options(14) = 150; % A single iteration
[mixgauss, ~, logvraisemblance] = gmmem(mixgauss, X, options);
figure, 
plot(logvraisemblance, '*--'), title('Evolution de la log vraisemblance')

% ------------- Affectation finale des points aux clusters -------------
% calcul des proba a posteriori
probapost = gmmpost(mixgauss, X);
% affectation
[~, clusters] = max(probapost, [],2);

% ------------- trace resultats de clustering -------------
plotclusters(clusters, X, nbclusters);
title('Resultat final')
% trace des centres finaux
figure(gcf)
for k=1:nbclusters
    plot(mixgauss.centres(k,1), mixgauss.centres(k,2), 'ks', 'markersize', 18, 'markerfacecolor', 'y');
end
% Trace des ellipses
plotcovariances(mixgauss)

%% Comparaisons