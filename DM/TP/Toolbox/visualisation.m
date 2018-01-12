
% bout de code pour tracer la frontière de décision d'un modèle de
% régression logistique en 2D. 
% theta est le vecteur de paramètres du modèle

figure(1)
M = 200;
[aux1,aux2]=meshgrid(linspace(-5,5,M));
aux=[reshape(aux1,M*M,1) reshape(aux2,M*M,1)];
Score = [ones(M*M, 1) aux]*theta;
figure(1), hold on
[c,h]=contour(aux1,aux2,reshape(Score, M,M), [0 0], 'g', 'Linewidth',2);
clabel(c,h);