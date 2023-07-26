function [genGraph] = drawGenderGraph(u,labels)
bar(u)
genGraph = gca;
genGraph.set('xticklabel',labels);
legend({'female','male'},'Location','northwest')
title('gender calssification accuracy with classical and deep learning based methods (balanced testset)')
xlabel('male/female') 
ylabel('accuracy 0-1')
end

