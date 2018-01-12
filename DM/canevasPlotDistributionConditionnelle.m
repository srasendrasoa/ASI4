




clear all
close all
clc

n=150; % nombre d'exemples par classe
mean1=[-4 -4]'; % moyenne classe 1
mean2=[4 4]'; % moyenne classe 2
sigma=[16 5; 5 9];  %  matrice de covariance 
ssigma=sqrtm(sigma);  %  on a besoin de la racine de la matrice de covariance pour g�nerer les donn�es


x1=randn(n,2)*ssigma +ones(n,1)*mean1'; % generation des donnees classe 1
x2=randn(n,2)*ssigma +ones(n,1)*mean2'; % generation des donnees classe 2


% Trace des points d'apprentissage
figure (1)
plot(x1(:,1), x1(:,2), 'r*')
hold on
plot(x2(:,1), x2(:,2), 'bs')
legend('Classe 1', 'Classe 2')
h = plot(mean1(1,:), mean1(2,:), 'gp'); set(h,'LineWidth',4);
h = plot(mean2(1,:), mean2(2,:), 'gd'); set(h,'LineWidth',4);


% Trace des lignes de niveau de la distribution conditionnelle des données
% selon les classes
N = 50;
[auxdim1, auxdim2]=meshgrid(linspace(-15, 15, N)); % definition du maillage du plan
auxdata = [reshape(auxdim1,N*N,1) reshape(auxdim2,N*N,1)]; 
[Nauxdata, d] = size(auxdata);

constante = 1/(2*pi)^(d/2)/sqrt(det(sigma));
for i=1:Nauxdata
    pxC1(i)=constante*exp(-( (auxdata(i, :)'-mean1)'*inv(sigma)*(auxdata(i, :)' - mean1))/2 ); % prob conditionnelle de C1
    pxC2(i)=constante*exp(-( (auxdata(i, :)'-mean2)'*inv(sigma)*(auxdata(i, :)'-  mean2))/2 ); % prob conditionnelle de C2
end;

 

pxC1Mat = reshape(pxC1,N,N);
pxC2Mat = reshape(pxC2,N,N);

[c,h]=contour(auxdim1, auxdim2, pxC1Mat); hold on
set(h,'LineWidth',2);
[c,h]=contour(auxdim1, auxdim2, pxC2Mat);
set(h,'LineWidth',2); 
 