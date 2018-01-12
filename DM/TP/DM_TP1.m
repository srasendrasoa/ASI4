clear all;
close all;

%% Exercice 1
commandwindow
load('WhiteW.mat');
moy = mean(X);
variance = var(X);

% figure(1)
% imagesc(corrcoef(X),colorbar,title('matrice de corrélation de X'));

%% Exercice 2
Y1 = sum(Y==1);
Y0 = sum(Y==0);
indo= find(Y==0);
Yapp = [];
Ytest = [];
Yapp = [Yapp;Y(indo(1:length(indo)/2))];
Ytest = [Ytest;Y(indo(length(indo)/2)+1:end)];    

ratio = 1/3;
[Xa, Ya, Xt, Yt] = splitdata(X,Y,ratio);
[Xa, Ya, Xv, Yv] = splitdata(Xa,Ya,ratio);

%% Exercice 3

Xapp = Xa;
Yapp = Ya;
Xval = Xv;
Yval = Yv;

kValues = 1:2:25;
MatDistApp = [];
MatDistVal = [];
MatDistTest = [];
errApp = [];
errVal = [];
errTest = [];

for i=1:length(kValues)
    k=kValues(i);
    [Yapp1,MatdistApp]=kppv(Xapp,Xapp,Yapp,k,MatDistApp);
    [Yval1,MatdistVal]=kppv(Xval,Xapp,Yapp,k,MatDistVal);
    [Yt1,MatdistVal]=kppv(Xt,Xapp,Yapp,k,MatDistTest);
    errApp(i) = mean(Yapp ~= Yapp1);
    errVal(i) = mean(Yval ~= Yval1);
    errTest(i) = mean(Yt ~= Yt1);
end

%% plot

figure
plot(kValues,errApp,'*--b','erreur apprentissage',kValues,errVal,'+-r','erreur validation',kValues,errTest,'--g');

%% choix du k optimal

[Ervalmin,index] = min(errVal);
k_opti = kValues(index);

% K optimal = 7

%% normaliser par rapport à var et mean de Xapp

