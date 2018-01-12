

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
X = [X1; X2]; 

% vecteur des labels
Y = [Y1; Y2]; 


%%  A COMPLETER : VOTRE IMPLEMENTATION DE LA LDA 
n_tot = n1+n2;
pi1 = n1/n_tot;
pi2 = n2/n_tot;
m1 = (1/n1)*sum(X(find(Y==1),:));
m2 = (1/n2)*sum(X(find(Y==2),:));
figure()
plot(m1,'bo');
hold on
plot(m2,'ro');
hold off
e1 = cov(X(find(Y==1),:));
e2 = cov(X(find(Y==2),:));
e = (n1*e1+n2*e2)/n_tot;


%% A DECOMMENTER : trace de la frontiere de decision de la LDA connaissant le vecteur w et le scalaire w0
M = 50;
% definition du maillage du plan
[auxdim1, auxdim2]=meshgrid(linspace(-8, 8, M)); 
auxdata = [reshape(auxdim1,M*M,1) reshape(auxdim2,M*M,1)]; 

% trace frontiere LDA
w = e\(m2-m1)';
w0 = 0.5* m2 * (e\m2')-0.5*m1*(e\m1')+log(pi1/pi2);
gx = auxdata*w + w0;
[c,h]=contour(auxdim1, auxdim2, reshape(gx,M,M), [0 0]); 
set(h, 'linewidth', 2, 'color', 'g'); hold on
plot(X1(:,1), X1(:,2), 'ro', 'markersize', 8, 'markerfacecolor', 'r')
hold on
plot(X2(:,1), X2(:,2), 'bv', 'markersize', 8, 'markerfacecolor', 'b')

clabel(c,h)

%% Taux d'erreur

ychap = zeros(size(Xv,1),1);
fv = X*w+w0;
ychap(fv<0)=1;
ychap(fv>=0)=2;

erreur = mean(Y~=ychap)

%% Exo 2
data = load('astrodata.mat');
X = data.X;
Y = data.Y;
[Xa,Ya,Xt,Yt] = splitdata(X,Y,1/2);
[Xa,Xt,ma,siga] = normalizemeanstd(Xa);
[Xt] = normalizemeanstd(Xt,ma,siga);
