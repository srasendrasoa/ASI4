clear all
close all
%% Initialisation

% Chargement des données
load('letter.mat');
load('letter_test.mat');

lettre1=21;
lettre2=22;

X1=data_letter(label_letter==lettre1,:);
X2=data_letter(label_letter==lettre2,:);
X=[X1
    X2];

Y1=ones(size(X1,1),1);
Y2=-1.*ones(size(X2,1),1);
Y=[Y1
    Y2];

% Séparation en set d'entraînement, validation et test 
[Xapp,Yapp,Xtemp,Ytemp]=splitdata(X,Y,0.8);
[Xtest,Ytest,Xval,Yval]=splitdata(Xtemp,Ytemp,0.5);

% Normalisation
[Xapp,Xval,meanapp,stdxapp]=normalizemeanstd(Xapp,Xval);
[Xtest]=normalizemeanstd(X_test,[],meanapp,stdxapp);

%% Validation croisée

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
    [w,b,alpha]=monsvmclass(Xapp,Yapp,C(i));

    % Erreur validation
    ypred_val=monsvmval(Xval,w,b);
    ypred_val(ypred_val>0)=1;
    ypred_val(ypred_val<0)=-1;
    erreur = mean(Yval~=ypred_val);
    erreur_val(i)=erreur;
    
    % Erreur apprentissage
    ypred_app=monsvmval(Xapp,w,b);
    ypred_app(ypred_app>0)=1;
    ypred_app(ypred_app<0)=-1;
    erreur = mean(Yapp~=ypred_app);
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
Xapp=[Xapp
    Xval];
Yapp=[Yapp
    Yval];

% Entraînement du modèle
% Selection du bon C
C=C(find(erreur_val==min(erreur_val)));
[w,b,alpha]=monsvmclass(Xapp,Yapp,C(end));

% Calcul de l'erreur
ypred=monsvmval(Xtest,w,b);
ypred(ypred>0)=1;
ypred(ypred<0)=-1;
erreur = mean(Ytest~=ypred);

TP = length(Ytest(Ytest(find(ypred==Ytest))==1));
TN = length(Ytest(Ytest(find(ypred==Ytest))==-1));

FP = length(Ytest(Ytest(find(ypred==-1))==1));
FN = length(Ytest(Ytest(find(ypred==1))==-1));

confusion_matrix=[TP FP
    FN TN]
fpr = FP/(FP+TN)
tpr = TP/(TP+FN)