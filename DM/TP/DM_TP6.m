
clear all;close all;
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
Y2 = 2*ones(n2, 1);


figure, plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')


% Dans la suite on ne travaillera qu'avec X et Y
% matrice des donn�es
X = [X1; X2]; clear X1 X2

% vecteur des labels
Y = [Y1; Y2]; clear Y1 Y2


%%  A COMPLETER : VOTRE IMPLEMENTATION DE LA LDA 
Ntot = n1+n2;
probapri1 = n1/Ntot;
probapri2 = n2/Ntot;

mu1 = (1/n1)*sum(X(find(Y==1),:));
mu2 = (1/n2)*sum(X(find(Y==2),:));
figure;
hold on 
plot(mu1,'bo');
plot(mu2,'ro');
hold off

X1 = X(find(Y==1),:);
X2 = X(find(Y==2),:);

sigma1 = cov(X1);
sigma2 = cov(X2);

SIGMA = (n1*sigma1+n2*sigma2)/Ntot;

w = SIGMA\(mu2-mu1)';

w0 = 0.5.*mu2*(SIGMA\mu2')-0.5.*mu1*(SIGMA\mu1')+log(probapri1/probapri2);
%% A DECOMMENTER : trace de la frontiere de decision de la LDA connaissant le vecteur w et le scalaire w0
 M = 50;
 % definition du maillage du plan
[auxdim1, auxdim2]=meshgrid(linspace(-8, 8, M)); 
 auxdata = [reshape(auxdim1,M*M,1) reshape(auxdim2,M*M,1)]; 
 
 % trace frontiere LDA
 gx = auxdata*w + w0;
 figure;
 [c,h]=contour(auxdim1, auxdim2, reshape(gx,M,M), [0 0]);
 set(h, 'linewidth', 2, 'color', 'g')
 clabel(c,h)
 hold on
 plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')


% calcul de l'erreur d'apprentissage 
f_a = X*w + w0;
Ypred_a = ones(size(f_a));
Ypred_a(f_a < 0)=1;
Ypred_a(f_a >= 0)=2;

Erreur = mean(Y ~= Ypred_a)

%% EX2
data = load('astrodata.mat');

X = data.X;
Y = data.Y;
[Xtest, Ytest,Xapp, Yapp] = splitdata(X,Y,1/3);
[Xan, Xvn, ma, siga]= normalizemeanstd(Xapp);
[~,Xtn]= normalizemeanstd(Xapp,Xtest,ma,siga);
n1 = size(find(Yapp==1),1);
n2 = size(find(Yapp==2),1);
Ntot = n1+n2;
probapri1 = n1/Ntot;
probapri2 = n2/Ntot;
 
mu1 = (1/n1)*sum(Xan(find(Yapp==1),:));
mu2 = (1/n2)*sum(Xan(find(Yapp==2),:));


X1an = Xan(find(Yapp==1),:);
X2an = Xan(find(Yapp==2),:);

sigma1 = cov(X1an);
sigma2 = cov(X2an);

SIGMA = (n1*sigma1+n2*sigma2)/Ntot;

w = SIGMA\(mu2-mu1)';

w0 = 0.5.*mu2*(SIGMA\mu2')-0.5.*mu1*(SIGMA\mu1')+log(probapri1/probapri2);

% calcul de l'erreur d'apprentissage 
f_a = Xtn*w + w0;
Ypred_a = ones(size(f_a));
Ypred_a(f_a < 0)=1;
Ypred_a(f_a >= 0)=2;

Erreur = mean(Ytest ~= Ypred_a)