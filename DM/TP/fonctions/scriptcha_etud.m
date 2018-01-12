% ========================================================
% Utilisation de AGGCLUST
% ========================================================

close all;
clear all;
clc

%%% les donnees
vmu1 = [0 0]';
vmu2 = [3 3]';
SIGMA = eye(2);

n = 50; % nombre de points par cluster

% generation de donnees aleatoires suivant lois gaussiennes
X1 =  mvnrnd(vmu1,SIGMA,n);   % classe 1
X2 =  mvnrnd(vmu2,SIGMA,n);    % classe 2

figure, plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')
title('La verite vraie','fontsize', 14)

% on concatene les donnees (on suppose qu'on ne sait pas quel 
% point est du cluster 1 ou 2
X = [X1; X2];

% Calcul de la matrice de distance
M = distance(X);


%% ========== CHA ===========
% -------- ultra-metrique : diametre maximal -------
method='complete'; 
level_max = aggclust(M, method);

% Affichage du dendogramme 
figure
dendro(level_max);
title('Clustering avec distance max', 'fontsize', 24)

K=2; % nombre de clusters voulus
% recuperation des indices des points de chaque cluster
N = size(X, 1);
clusters=level_max(N-K+1).cluster;

% trace des clusters obtenus
plotclusters(clusters, X, K);
title('Clustering avec distance max', 'fontsize', 24)

% ------- ultra-metrique : diametre min -------
method='single'; % saut minimal
level_min = aggclust(M, method);


% Affichage du dendogramme 
figure
dendro(level_min);
title('Clustering avec distance mix', 'fontsize', 24)

K=2; % nombre de clusters voulus
% recuperation des indices des points de chaque cluster
N = size(X, 1);
clusters=level_min(N-K+1).cluster;

% trace des clusters obtenus
plotclusters(clusters, X, K);
title('Clustering avec distance min', 'fontsize', 24)

