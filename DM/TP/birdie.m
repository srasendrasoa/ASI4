

%% TP Birds
clear all
close all
clc

% Charger image : c'est une matrice 3D 128 x 128 x 3
bird = double(imread('bird_small.tiff'));

% dimensions
[Nlig, Ncol, d] = size(bird);

% transformer la matrice 3D en 2D avec chaque ligne repr�sentant les canaux
% RGB de chaque pixel ij de l'image
X = reshape(bird, Nlig*Ncol, d);


% ---------------- A COMPLETER AVEC VOTRE KMEANS ------------
seuil=10^-3;
nbclusters = 50;
N=size(X,1);
indperm = randperm(N); 
CO=X(indperm(1:nbclusters),:); %initialisation des centres
[Centres,clusters,Jw] = kmoyennes(X,CO,nbclusters,seuil);



% ----------------------------------------------------------


% --------------- AFFICHAGE -------------------------
% --------- On suppose que les centres trouves sont dans la matrice Centres
Centres = round(Centres);

% afichage des centres des clusters
figure; hold on
for k=1:nbclusters
   col = (1/255).*Centres(k,:);
   rectangle('Position', [k, 0, 1, 1], 'FaceColor', col, 'EdgeColor', col);
end
axis off




% chargement de la grande image
large_image = double(imread('bird_large.tiff'));
figure,
imshow(uint8(large_image));
title('Image initiale', 'fontsize', 16)


% on remplace directement dans l'image la valeur rgb du pixel par le centre
% le plus proche (pour sauver de place memorire)
[Nlig, Ncol, d] = size(large_image);
for i = 1:Nlig
    for j = 1:Ncol
        
        r = large_image(i,j,1); g = large_image(i,j,2); b = large_image(i,j,3);
        x = [r, g, b]; % on recupere les valeurs RGB du pixel ij
        
        % ---------------- A COMPLETER  ------------
        for k=1:nbclusters
            distance(k)=norm(x-Centres(k,:),2);
        end
        [val,indice] = min(distance);
        large_image(i,j,:) = Centres(indice,:);
    end 
end
% on affiche l'image apres encodage avec Kmeans 
figure
imshow(uint8(large_image));
title('Encodage de l''image via Kmeans', 'fontsize', 16)
