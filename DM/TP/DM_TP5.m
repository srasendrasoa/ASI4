clear all
close all
clc

% param�tres du probl�me primal
c = [3 1]';
b = [1 1 1 1]';
A = [1 1; 1 -1;-1 1;-1 -1];

% Trac� de la fonction objectif et des contraintes du probl�me primal
N = 150;
x = linspace(-2, 5, N);
y = linspace(-2, 5, N);
[X,Y] = meshgrid(x, y);
x = reshape(X,N*N,1);
y = reshape(Y,N*N,1);
J = 0.5*(x-c(1)).^2 + 0.5*(y-c(2)).^2;
[val, h]=contour(X, Y, reshape(J, N,N), 15, 'linewidth', 1.25);
%clabel(val,h);
hold on

% contraintes
N = 150;
x = linspace(-1, 1, N);
y = linspace(-1, 1, N);
[X,Y] = meshgrid(x, y);
x = reshape(X,N*N,1);
y = reshape(Y,N*N,1);
ineq = (A * [x y]' - b*ones(1,N*N))';
hold on
contour(X, Y, reshape(ineq(:,1), N,N), [0 0], 'm', 'linewidth', 2);
contour(X, Y, reshape(ineq(:,2), N,N), [0 0], 'm', 'linewidth', 2);
contour(X, Y, reshape(ineq(:,3), N,N), [0 0], 'm', 'linewidth', 2);
contour(X, Y, reshape(ineq(:,4), N,N), [0 0], 'm', 'linewidth', 2);

set(gca,'fontsize', 24)
colorbar



% Resolution du probleme primal par cvx
% Probleme
% minimize    1/2 || theta-C||^2
%               s.t.    A*theta -b <= 0

n = 2;
fprintf( 'Calcul de la solution primale par CVX ... \n\n');
cvx_begin quiet % quiet pour �viter l'affichage des iterations de cvx
    variable theta(n); % declarer que theta est la variable du prob, vecteur de taille n
    minimize 0.5*quad_form(theta - c, eye(n)) % fonction objectif
    A*theta - b <= 0; % contraintes inegalites
cvx_end

fprintf('\n\n Fait ! \n');

% affichage resultats
fprintf('\n\n Solution obtenue : \n');
disp(theta);
plot(theta(1), theta(2), 'ro', 'markersize', 12, 'markerfacecolor','r' )

% valeur de la fonction objectif pour theta optimal
J_theta_primal = quad_form(theta - c, eye(n));

%% resolution du probleme dual

% min 1/2 u'Hu + u'q
% H = AA'
% q = -(Ac-b)
m = size(A,1);
H = A*A';
q = -(A*c-b);
fprintf( 'Calcul de la solution primale par CVX ... \n\n');
cvx_begin quiet
    variable mu(m);
    minimize(0.5*quad_form(mu,H)+q'*mu);
    mu <= 0;
cvx_end

fprintf('\n\n Fait ! \n');
J_theta_dual = -(0.5*quad_form(mu,H)+q'*mu);
% affichage resultats
fprintf('\n\n Solution obtenue : \n');
disp(mu);
% valeur fct duale J_theta_dual