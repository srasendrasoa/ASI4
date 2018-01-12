clear all
close all

%% 
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
Y2 = -ones(n2, 1);


figure, plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')


% Dans la suite on ne travaillera qu'avec X et Y
% matrice des donn�es
X = [X1; X2]; clear X1 X2

% vecteur des labels
Y = [Y1; Y2]; clear Y1 Y2

% Fixer la valeur de C
C = logspace(-2,2,9);    
labels = Y;
% test avec une valeur de C
% C = C(1);
for i=1:length(C)
    [w, b, alpha] = monsvmclass(X, labels, C(i));
    figure(1)
    N = 200;
    [aux1,aux2]=meshgrid(linspace(-5,5,N));
    aux=[reshape(aux1,N*N,1) reshape(aux2,N*N,1)];
    fx = aux*w + b;
    figure(1), hold on
    % trace la frontiere de d�cision f(x) = 0 et la marge f(x)=1 et f(x)=-1
    [c,h]=contour(aux1,aux2,reshape(fx, N,N), [-1 0 1], 'g', 'Linewidth',2);
    clabel(c,h);
    % points supports
    seuil = 1e-5;
    ind = find(alpha >= seuil);
    hold on 
    plot(X(ind, 1),X(ind, 2),'ms','markersize',12)   
    % erreur de classification
    % prediction
end

%%
clear all 
close all

%%
load('uspsasi.mat');

ind = y==1|y==8;
X = x(ind,:);
labels=y(ind);
C = logspace(-2,2,9);    

% Découpage et normalisation, Xa sert de référence

[Xtest, Ytest,Xapp, Yapp] = splitdata(X,Y,1/3);
[Xapp, ma, siga]= normalizemeanstd(Xapp);
[~,Xv]= normalizemeanstd(Xv,ma,siga);
[~,Xt]= normalizemeanstd(Xt,ma,siga);

%% U vs V