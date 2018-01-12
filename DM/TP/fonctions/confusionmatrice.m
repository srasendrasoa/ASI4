function cm = confusionmatrice(ytrue, ypred)

classcode = unique(ytrue);
nclass = length(classcode);

%if isempty(classcode, unique(ypred))
   cm = zeros(nclass, nclass);
   for i = 1 : nclass
       for j = 1 : nclass
           cm(i, j) = sum((ytrue == classcode(i)).*(ypred == classcode(j)));
       end
   end
%else
 %   error('Class mismatch between ytrue and ypred')
%end
