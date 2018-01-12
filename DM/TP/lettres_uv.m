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
%[Xapp,Xtest]=normalizemeanstd(Xapp,Xtest,meanapp,stdxapp);
Xtest=normalizemeanstd(Xtest, [], meanapp,stdxapp);

%% Data pour regression logisitique

XappReg = Xapp;
XvalReg = Xval;
XtestReg = Xtest;
YappReg = Yapp;
YvalReg = Yval;
YtestReg = Ytest;

%% Validation croisée SVM - encodage label -1 et 1

C = logspace(-2,2,10)';
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
C=C(erreur_val==min(erreur_val));
[w,b,alpha]=monsvmclass(Xapp,Yapp,C(end));

% Calcul de l'erreur
ypred=monsvmval(Xtest,w,b);
ypred(ypred>0)=1;
ypred(ypred<0)=-1;
erreur = mean(Ytest~=ypred);

TP = length(Ytest(Ytest(ypred==Ytest)==1));
TN = length(Ytest(Ytest(ypred==Ytest)==-1));

FP = length(Ytest(Ytest(ypred==-1)==1));
FN = length(Ytest(Ytest(ypred==1)==-1));

confusion_matrix=[TP FP
    FN TN]
% taux de vrais positifs
fpr = FP/(FP+TN)
% Precision
tpr = TP/(TP+FN)

%% Tracé du ROC SVM

monroc(ypred,Ytest)

%% Regression Logistique - encodage label 0 et 1

% vecteur des labels
lambda = 1e-3;
YappReg = Yapp;
YappReg(YappReg == -1)= 0;
[theta, allJ] = reglogclass(XappReg,YappReg,lambda);
ypred = reglogval(XappReg,theta);

erreurReg = mean(ypred~=YappReg);

% ne pas oublier de faire taux d'erreur, matrice de confusion et ROC 



%% A faire (McNeymar)

%Zsvm = (Ychapsvm == Ytest)
%Zreg = (Ychapreg == Ytest)
% où Z(i) = 1 si true et 0 sinon

%Table de contingence(Zsvm,Zreg)

% testcholdout(Ychapsvm,Ychapreg,Ytest)