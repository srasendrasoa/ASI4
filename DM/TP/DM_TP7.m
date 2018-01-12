clear all
close all

%%
% Script � compl�ter pour r�alise le TP 

randn('state', 1200)

% G�n�ration des donn�es
vmu1 = [0; 2];
vmu2 = [-2; -1];
vSIGMA1 = 1.5*[1 0.1; 0.1 1];
vSIGMA2 = 3.5*[1 -0.25; -0.25 1/2];


n1 = 100; % nombre de points classe 1
n2 = 150; % nombre de points classe 2

% generation de donnees aleatoires suivant lois gaussiennes
% classe 1
X1 =  mvnrnd(vmu1, vSIGMA1,n1);   
Y1 = ones(n1, 1);
% classe 2
X2 =  mvnrnd(vmu2, vSIGMA2,n2);    
Y2 = zeros(n2, 1);


figure, plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')


% Dans la suite on ne travaillera qu'avec X et Y
% matrice des donn�es
X = [X1; X2]; clear X1 X2

% vecteur des labels
Y = [Y1; Y2]; clear Y1 Y2
lambda = 1e-6;
[theta, allJ] = reglogclass(X,Y,lambda);
ypred = reglogval(X,theta);

erreur = mean(ypred~=Y);
%erreur = 100*(length(find(ypred~=Y))/length(ypred))

figure(1)
M = 200;
[aux1,aux2]=meshgrid(linspace(-5,5,M));
aux=[reshape(aux1,M*M,1) reshape(aux2,M*M,1)];
Score = [ones(M*M, 1) aux]*theta;
figure(1), hold on
[c,h]=contour(aux1,aux2,reshape(Score, M,M), [0 0], 'g', 'Linewidth',2);
clabel(c,h);

%% Classification
