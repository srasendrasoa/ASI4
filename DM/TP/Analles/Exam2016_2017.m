clear all;
close all;

%% Execice 1

load('elections.mat');

[valprop,U,moy] = mypca(X);

P = U(:,1:2); 

C = projpca(X,moy,P);

ind_dem = Y==-1;
ind_rep = Y==1;

plot(C(ind_rep,2),'r*'); hold on;
plot(C(ind_dem,1), 'b.');


%% Exercice 2

load('astroapp.mat');
load('astroval.mat');
load('astrotest.mat');

phi_a = [Xa(:,1) Xa(:,2) Xa(:,3) Xa(:,4) Xa(:,1).^2 Xa(:,2).^2 Xa(:,3).^2 Xa(:,4).^2];
phi_v = [Xv(:,1) Xv(:,2) Xv(:,3) Xv(:,4) Xv(:,1).^2 Xv(:,2).^2 Xv(:,3).^2 Xv(:,4).^2];
phi_t = [Xt(:,1) Xt(:,2) Xt(:,3) Xt(:,4) Xt(:,1).^2 Xt(:,2).^2 Xt(:,3).^2 Xt(:,4).^2];

% Normalisation
[phi_a,phi_v,meanapp,stdxapp]=normalizemeanstd(phi_a,phi_v);
[phi_t]=normalizemeanstd(phi_t,[],meanapp,stdxapp);
%%

C = [0.0001
    0.001
    0.01
    0.1
    9
    9.1
    9.2
    9.3
    9.4
    9.5
    9.6
    9.7
    9.8
    9.9
    10
    100
    1000
    10000];
erreur_val=zeros(size(C,1),1);
erreur_app=zeros(size(C,1),1);

for i=1:size(C,1)
    [w,b,alpha]=monsvmclass(phi_a,Ya,C(i));

    % Erreur validation
    ypred_val=monsvmval(phi_v,w,b);
    ypred_val(ypred_val>0)=1;
    ypred_val(ypred_val<0)=-1;
    erreur = mean(Yv~=ypred_val);
    erreur_val(i)=erreur;
    
    % Erreur apprentissage
    ypred_app=monsvmval(phi_a,w,b);
    ypred_app(ypred_app>0)=1;
    ypred_app(ypred_app<0)=-1;
    erreur = mean(Ya~=ypred_app);
    erreur_app(i)=erreur;
    
end
figure(2)
hold on
plot(erreur_val,'r--*');
plot(erreur_app,'b--+');
legend('erreurVal','erreurAPP')
hold off

%% Entrainement du modèle avec le bon C
%Fusion de l'ensemble d'apprentissage et de validation
Xapp=[phi_a
    phi_v];
Yapp=[Ya
    Yv];

% Entraînement du modèle
% Selection du bon C
C=C(erreur_val==min(erreur_val));
C = 9.2;
[w,b,alpha]=monsvmclass(Xapp,Yapp,C(end));

% Calcul de l'erreur
ypred=monsvmval(phi_t,w,b);
ypred(ypred>0)=1;
ypred(ypred<0)=-1;
erreur = mean(Yt~=ypred);

TP = length(Yt(Yt(find(ypred==Yt))==1));
TN = length(Yt(Yt(find(ypred==Yt))==-1));

FP = length(Yt(Yt(find(ypred==-1))==1));
FN = length(Yt(Yt(find(ypred==1))==-1));

confusion_matrix=[TP FP
    FN TN]
fpr = FP/(FP+TN) 
tpr = TP/(TP+FN) %taux de vrais positifs