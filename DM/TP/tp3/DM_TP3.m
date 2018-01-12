%%
clear all
close all
%%
load('george.dat');
load('ds2.dat');

%% CLUSTERING GEORGE
george_split1 = mydownsampling(george,16);
dist_gsplit1 = distance(george_split1);
lvl_george=aggclust(dist_gsplit1,'single');

figure(1)
dendro(lvl_george);
title('Clustering avec distance max', 'fontsize', 24)

K=5; % nombre de clusters voulus
% recuperation des indices des points de chaque cluster
N = size(george_split1,1);
clusters=lvl_george(N-K+1).cluster;

% trace des clusters obtenus
plotclusters(clusters, george_split1, K);
title('Clustering avec distance max', 'fontsize', 24)

%% CLUSTERING DS2
ds2_split1 = mydownsampling(ds2,16);
dist_gsplit1 = distance(ds2_split1);
lvl_ds2=aggclust(dist_gsplit1,'single');

figure(1)
dendro(lvl_ds2);
title('Clustering avec distance max', 'fontsize', 24)

K=10; % nombre de clusters voulus
% recuperation des indices des points de chaque cluster
N = size(ds2_split1,1);
clusters=lvl_ds2(N-K+1).cluster;

% trace des clusters obtenus
plotclusters(clusters, ds2_split1, K);
title('Clustering avec distance max', 'fontsize', 24)

%% KMEANS
X=load('ds2.dat');
seuil=10^-3;
K = 8;
N=size(X,1);
indperm = randperm(N); 
CO=X(indperm(1:K),:); %initialisation des centres
[C,clusters,Jw] = kmoyennes(X,CO,K,seuil);
figure(2)
plot(Jw,'--*');
plotclusters(clusters,X,K);

%% 