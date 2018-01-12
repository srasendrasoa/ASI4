function [theta, allJ] = reglogclass(X, y, lambda, epsilon, Maxiter)

% X : matrice des donnees de taille N x d (N : nombre de points)
% y : vecteur des labels correspondant de taille N
% Attention : yi appartient � {0, 1}
% lambda :  parametre de regularisation
% epsilon : critere d'arret
% Maxiter : nombre maximal d'iterations

if nargin < 4
    epsilon = 1e-4;
end 
if nargin < 5
    Maxiter = 100;
end

% former la matrice Phi
[N, d] = size(X);
Phi = [ones(N, 1) X];

% epsilon : critere d'arret sur  J

% initialisation de theta
theta = zeros(d+1, 1);

critJ = 1e3;
critJ_old = critJ + 10*epsilon;

J = inf*ones(Maxiter,1);

% matrice identite
I  = eye(d+1);

i=1;
while  i <= Maxiter  && abs(critJ_old - critJ) > epsilon       % tantque on n'a pas converge
    
    % calcul des vecteurs p = 1/(1+exp(Phi*theta))
    a = Phi * theta;
    p = exp(a)./(1+exp(a));
    
    % Critere = -log max vraisemblance
    critJ_old = critJ;
    critJ = -(sum(y.*a) - sum(log(1+exp(a))));
    J(i) = critJ;
    
    fprintf('Iter % d  \t Cost = %6.6f \n', i, J(i));
    if i > 1
        if J(i) > J(i-1)
            error('critere augmente : pas normal')
        end
    end
    % vecteur des poids pi*(1-pi)
    w = p.*(1-p) + lambda;
    
    % r�sidu
    r = a + (y-p)./w;
    
    % nouvelle estimation de theta
    theta = (Phi'*diag(w)*Phi + lambda*I)\(Phi'*(w.*r));
   
    i = i+1;
    
end

allJ = J(1:min(i-1, Maxiter));
