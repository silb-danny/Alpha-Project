function [ageGraph] = drawAgeGraph(u,MAEx,labels)
bar(u)
ageGraph = gca;
legend(labels,'Location','northwest')
title('MAE in age groups of 5 years with classical and deep learning based methods (balanced testset)')
xlabel('Age Groups') 
ylabel('Age Error')
c = MAEx;
ageGraph.set('xticklabel', c')
end

