function [YPeval, MatDist]=kppv(Xeval, Xapp, Yapp, k, MatDist)


% USAGE
% [YPeval,MatDist]=knn(Xeval, Xapp, Yapp, k, MatDist)

% Xeval : les donn�es dont on veut predire la classe. Xeval est une matrice
% de dimensions Ne x d (d: nombre de variables)

% Xapp : donn�es d'apprentissage (donn�es de r�f�rence), matrice Na x d

% Yapp : vect de taille Na contenant les labels des points dans Xapp

% MatDist : matrice de distance entre les points dans Xeval et ceux de
% Xapp. Matrice de dimensions Ne x Na. Si cette matrice n'existe pas il
% faut faire l'appel comme [YPeval,MatDist]=kppv(Xeval, Xapp, Yapp, k, [])

% YPeval : vecteur (taille Ne) des labels pr�dits pour les points de Xeval



% on d�termine combien de classes on a dans les donn�es
classcode=(unique(Yapp))';
nbclasse=length(classcode);



Ne=size(Xeval,1);
Na=size(Xapp,1);
YPeval=zeros(Ne,1);

% on calcule la matrice des distances entre les points Xeval et Xapp si
% l'appel a �t� fait avec MatDist = [] (matrice vide) sinon on ne fait rien
if nargin < 5 || isempty(MatDist) % on a deja calcule la matrice de distance
    MatDist = zeros(Ne, Na);
    for i=1:Ne;
        for j=1:Na;            
            MatDist(i,j)=(Xeval(i,:)- Xapp(j,:))*(Xeval(i,:)- Xapp(j,:))';
        end;
    end;
end;

% Calcul de la pr�diction des labels des Ne points de Xeval par kppv
for i=1:Ne
    [~,I]=sort(MatDist(i,:));
    C=Yapp(I);
    classeppv=C(1:k);
    nc=0*ones(nbclasse,1);
    for j=1:k;
        ind=find(classcode==classeppv(j));
        nc(ind)=nc(ind)+1;    
    end;
    [~,aff]=max(nc);
    YPeval(i)=classcode(aff);
end;




