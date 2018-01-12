
function monroc(fx, labels)

% fx : vecteur de taille Ncontenant les predictions fournies par le SVM 
% sur N points xi. fx(i) = w'*xi + b avec w et b parametres du SVM. 
% NB : fx = X*w + b si vous calculez la prediction SVM pour N points dans
% la matrice X
%
% labels : vecteur de taille N contenant les vrais labels associes aux points xi

seuils = [min(fx):0.01:max(fx)+0.01];
TPR = [];
FPR = [];
for i = 1:length(seuils)
    b_pred = fx>=seuils(i);
    TP = sum(b_pred==1 & labels == 1);
    FP = sum(b_pred==1 & labels == -1);
    TN = sum(b_pred==0 & labels == -1);
    FN = sum(b_pred==0 & labels == 1);
    TPR(i) = TP/(TP+FN);
    FPR(i) = FP/(TN+FP);
end
figure(1);hold off
plot(FPR(end:-1:1), TPR(end:-1:1),'b-', 'linewidth', 2)
set(gca, 'fontsize', 16)
xlabel('Taux de faux positifs FPR', 'fontsize', 18)
ylabel('Taux de vrais positifs FPR', 'fontsize', 18)