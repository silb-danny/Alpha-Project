function [accuracy,out] = drawGenDist(svmGen,TestGen,type)
if type == 'r'
    p = predict(svmGen,TestGen.statistics);
    pM = p(TestGen.label == "M");
    gM = TestGen.label(TestGen.label == "M");
    pF = p(TestGen.label == "F");
    gF = TestGen.label(TestGen.label == "F");
    out = [sum(pF == gF)./size(gF,1),sum(pM == gM)./size(gM,1)];
    accuracy = sum(p == TestGen.label)./size(TestGen.label,1)*100;
end
if type == 'n'
    predictors = cell2flatmat(TestGen.Predictors);
    p = predict(svmGen,predictors);
    pM = p(TestGen.Response == "M");
    gM = TestGen.Response(TestGen.Response == "M");
    pF = p(TestGen.Response == "F");
    gF = TestGen.Response(TestGen.Response == "F");
    out = [sum(pF == gF)./size(gF,1),sum(pM == gM)./size(gM,1)];
    accuracy = sum(p == TestGen.Response)./size(TestGen.Response,1)*100;
end
end

