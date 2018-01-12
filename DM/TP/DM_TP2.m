clear all
close all
%% 
load('iris.mat');
[valprop, U, moy] = mypca(x);

%%
%bar(valprop);
k=2;
P = U(:,1:k);
C = projpca(x, moy, P);
plot(C(:,1),C(:,2),'s');

%%
xhat = reconstructpca(C,P,moy); 
[n,p] = size(x);
test = 1/n*(norm(x-xhat,'fro')); 

%%
load('uspsasi.mat');
chiffre = 8;
index = find(y==chiffre);
X_ch = x(index,:);
X_ch_corr = corrcoef(X_ch); 
imagesc(X_ch_corr);

figure(2)
imagesc(reshape(X_ch(chiffre,:),16,16)');colormap(gray);
[p_values, U, moy] = mypca(X_ch);
figure(3);
bar(p_values);
k=2;
P = U(:,1:k);
C = projpca(X_ch,moy, P);
Xhat = reconstructpca(C,P,moy);
figure(4)
plot(C(:,1), C(:,2), 's');

figure(5);
imagesc(reshape(Xhat(chiffre,:),16,16)');colormap(gray);


