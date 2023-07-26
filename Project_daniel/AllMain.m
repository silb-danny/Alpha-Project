function [ageMae,genAccuracy,c,ageModels,genModels,cAge,cGen] = AllMain(dataTAge,dataTGen,NetworkDataAge,NetworkDataGen,t,f,sen,testType)
%     Dividing dataset - classic
% [TestAge,TrainAge] = divideDataSet(dataTAge,sen,0.80); floor(dataTAge.label/f)*f
% [TestGen,TrainGen] = divideDataSet(dataTGen,sen,0.80); dataTAge.label
cAge = cvpartition(floor(dataTAge.label/f)*f,'Holdout',0.3,'Stratify',true);
TestAge = dataTAge(cAge.test(),:);
TrainAge = dataTAge(cAge.training(),:);
cGen = cvpartition(dataTGen.label,'Holdout',0.3,'Stratify',true);
TestGen = dataTGen(cGen.test(),:);
TrainGen = dataTGen(cGen.training(),:);

%     Dividing dataset - deep network
% [TestAgeNet,TrainAgeNet] = divideDataSet(NetworkDataAge,sen,0.80);
% [TestGenNet,TrainGenNet] = divideDataSet(NetworkDataGen,sen,0.80);
TestAgeNet = NetworkDataAge(cAge.test(),:);
TrainAgeNet = NetworkDataAge(cAge.training(),:);
TestGenNet = NetworkDataGen(cGen.test(),:);
TrainGenNet = NetworkDataGen(cGen.training(),:);

%     calculating weights
TrainGenWeights = CalcWeights(TrainGen.label,'r');%floor(TrainAge.label/f)*f
TrainAgeWeights = CalcWeights(floor(TrainAge.label/f)*f,'r');

%     calculating weights deep network
% [AgeWeightsNet,ageClasses] = CalcWeights2(floor(NetworkDataAge.Response));
AgeWeightsNet = CalcWeights(floor(TrainAgeNet.Response),'r');
GenWeightsNet = CalcWeights(TrainGenNet.Response,'r');

%     balancing dataset classic:
TestAge1 = BalanceDataSet(TestAge,floor(TestAge.label/f)*f,'max',sen);
TrainAge1 = BalanceDataSet(TrainAge,floor(TrainAge.label/f)*f,'max',sen);

TestGen1 = BalanceDataSet(TestGen,TestGen.label,'max',sen);
TrainGen1 = BalanceDataSet(TrainGen,TrainGen.label,'max',sen);

%     balancing dataset deep:
TestAge1Net = BalanceDataSet(TestAgeNet,floor(TestAgeNet.Response/f)*f,'max',sen);
TrainAge1Net = BalanceDataSet(TrainAgeNet,floor(TrainAgeNet.Response/f)*f,'max',sen);

TestGen1Net = BalanceDataSet(TestGenNet,TestGenNet.Response,'min',sen);
TrainGen1Net = BalanceDataSet(TrainGenNet,TrainGenNet.Response,'mins',sen);

    % Classification + regression
% GenSVM1 = fitcsvm(TrainGen.statistics,TrainGen.label); % reg
GenSVM2 = fitcsvm(TrainGen1.statistics,TrainGen1.label); % balanced
GenSVM3 = fitcsvm(TrainGen.statistics,TrainGen.label,'Weights',TrainGenWeights); % 99-98 percent accuracy 
% AgeSVM1 = fitrsvm(TrainAge.statistics,TrainAge.label); % centered around 30s - average of ages
AgeSVM2 = fitrsvm(TrainAge1.statistics,TrainAge1.label);
AgeSVM3 = fitrsvm(TrainAge.statistics,TrainAge.label,'Weights',TrainAgeWeights); % centered around 30s - average of ages
% mean(abs(predict(AgeSVM2,dataTAge.statistics)-dataTAge.label)) % 15.35-18.12
% mean(abs(predict(AgeSVM3,dataTAge.statistics)-dataTAge.label)) % 9.2-10

    % Deep learning cnn
tbl = TrainAge1Net.Predictors;
predictors = cell2flatmat(tbl);
MdlAge = fitrnet(predictors,TrainAge1Net.Response);
tbl = TrainAgeNet.Predictors;

predictors = cell2flatmat(tbl);
MdlAge1 = fitrnet(predictors,TrainAgeNet.Response,"Weights",AgeWeightsNet);
tbl = NetworkDataAge.Predictors;
predictors = cell2flatmat(tbl);
% mean(abs(predict(MdlAge,predictors)-NetworkDataAge.Response)) % 12.22
% mean(abs(predict(MdlAge1,predictors)-NetworkDataAge.Response)) % 12.14

predictors = TrainAge1.statistics;
MdlAge2 = fitrnet(predictors,TrainAge1.label);
predictors = TrainAge.statistics;
MdlAge3 = fitrnet(predictors,TrainAge.label,"Weights",TrainAgeWeights);
predictors = dataTAge.statistics;
% mean(abs(predict(MdlAge2,predictors)-dataTAge.label)) % 15.18-16
% mean(abs(predict(MdlAge3,predictors)-dataTAge.label)) % 8.2-9

tbl = TrainGen1Net.Predictors;
predictors = cell2flatmat(tbl);
MdlGen = fitcnet(predictors,TrainGen1Net.Response);
tbl = TrainGenNet.Predictors;
predictors = cell2flatmat(tbl);
MdlGen1 = fitcnet(predictors,TrainGenNet.Response,"Weights",GenWeightsNet);
tbl = NetworkDataGen.Predictors;
predictors = cell2flatmat(tbl);
% sum(predict(MdlGen,predictors) == NetworkDataGen.Response)/numel(NetworkDataGen.Response)
% sum(predict(MdlGen1,predictors) == NetworkDataGen.Response)/numel(NetworkDataGen.Response)

predictors = TrainGen1.statistics;
MdlGen2 = fitcnet(predictors,TrainGen1.label);
predictors = TrainGen.statistics;
MdlGen3 = fitcnet(predictors,TrainGen.label,"Weights",TrainGenWeights);
predictors = dataTGen.statistics;
% sum(predict(MdlGen2,predictors) == dataTGen.label)/numel(dataTGen.label)
% sum(predict(MdlGen3,predictors) == dataTGen.label)/numel(dataTGen.label)

ageModels = {AgeSVM2,AgeSVM3,MdlAge,MdlAge1,MdlAge2,MdlAge3};
genModels = {GenSVM2,GenSVM3,MdlGen,MdlGen1,MdlGen2,MdlGen3};
if testType == "test1"
        % Accuracy Age in groups
    % t = 5;
    [~,mae1] = drawAgeDist(AgeSVM2,TestAge1,t,'r');
    [~,mae2] = drawAgeDist(AgeSVM3,TestAge1,t,'r');
    [~,mae3] = drawAgeDist(MdlAge,TestAge1Net,t,'ne'); 
    [c,mae4] = drawAgeDist(MdlAge1,TestAge1Net,t,'ne'); 
    [~,mae5] = drawAgeDist(MdlAge2,TestAge1,t,'r'); 
    [~,mae6] = drawAgeDist(MdlAge3,TestAge1,t,'r'); 
    ageMae = [mae1,mae2,mae3,mae4,mae5,mae6];

        % Accuracy gender
    [~,out1] = drawGenDist(GenSVM2,TestGen1,'r');
    [~,out2] = drawGenDist(GenSVM3,TestGen1,'r');
    [~,out3] = drawGenDist(MdlGen,TestGen1Net,'n'); 
    [~,out4] = drawGenDist(MdlGen1,TestGen1Net,'n'); 
    [~,out5] = drawGenDist(MdlGen2,TestGen1,'r'); 
    [~,out6] = drawGenDist(MdlGen3,TestGen1,'r'); 
    genAccuracy = [out1;out2;out3;out4;out5;out6];
end
if testType == "test"
        % Accuracy Age in groups
    % t = 5;
    [~,mae1] = drawAgeDist(AgeSVM2,TestAge,t,'r');
    [~,mae2] = drawAgeDist(AgeSVM3,TestAge,t,'r');
    [~,mae3] = drawAgeDist(MdlAge,TestAgeNet,t,'ne'); 
    [c,mae4] = drawAgeDist(MdlAge1,TestAgeNet,t,'ne'); 
    [~,mae5] = drawAgeDist(MdlAge2,TestAge,t,'r'); 
    [~,mae6] = drawAgeDist(MdlAge3,TestAge,t,'r'); 
    ageMae = [mae1,mae2,mae3,mae4,mae5,mae6];

        % Accuracy gender
    [~,out1] = drawGenDist(GenSVM2,TestGen,'r');
    [~,out2] = drawGenDist(GenSVM3,TestGen,'r');
    [~,out3] = drawGenDist(MdlGen,TestGenNet,'n'); 
    [~,out4] = drawGenDist(MdlGen1,TestGenNet,'n'); 
    [~,out5] = drawGenDist(MdlGen2,TestGen,'r'); 
    [~,out6] = drawGenDist(MdlGen3,TestGen,'r'); 
    genAccuracy = [out1;out2;out3;out4;out5;out6];
end
end

