
function [w, b, alpha] = monsvmclass(X, labels, C)

% X = matrice des donnees de dim N x d
% labels : vecteur des labels
% C : le param�tre C de SVM

% Matrice des noyaux K = [x_i^T x_j] i,j=1,...,n
K = X*X';
% Matrice H = [y_i y_j x_i^T x_j] i,j=1,...,n
H = K.*(labels*labels');
% vecteur compos� que de 1
N = length(labels);
q = ones(N, 1);

verbose = 0;  % je veux pas les details
chouia = 1e-8; % le petit truc magique
[monpetitalpha, b, pos] = monqp(H,q,labels,0,C,chouia,verbose);
alpha = zeros(N, 1);
alpha(pos) = monpetitalpha;

% � w maintenant : w = sum_i \in SV \alpha_i y_i x_i
% avec SV = l'ens des points tq alpha_i non nuls
dim = size(X, 2);
w = zeros(dim, 1);

% for i=1:n
%     w = w + alpha(i)*labels(i)*X(i,:)';
% end
% la même chos en plus illisible :(
w = sum(((monpetitalpha.*labels(pos))*ones(1, dim)).*X(pos, :))';
