function [age,gen,netage,netgen] = predictPerson(y,fs,efs,mn,mx,age,gen,extremeValues,AgeSVM,GenSVM,netGen,netAge,smSize,tp)
% predicts age and gender using regression and classificationg in classical
% ways and deep learning based.
% for single person sound file
% correcting amplitude range difference
if (tp == "strech" || tp == "s")
    v = [mn,mx];
    x = [min(y),max(y)];
    y = interp1(x,v,y);
end
if (tp == "normmax" || tp == "nx")
    y = (y/max(y))*mx; % normalizing and fixing range using max
end 
if (tp == "normmin" || tp == "nn")
    y = (y/min(y))*mn; % normalizing and fixing range using min
end 
% fixing sample rate
t = fs/efs;
y = resample(y,1,t);
y = stretchAudio(y,t);
fs = fs/t;
% preparing data
d = PrepareForOne(y,fs,gen,extremeValues);
t = melSpectrogram(y,fs);
td = zeros(32,smSize);
sze = size(t,1);
td(:,1:min(sze,smSize)) = t(:,1:min(sze,smSize));
data = {td};
dataAge = table(data, age);
dataAge.Properties.VariableNames = {'Predictors' 'Response'};
dataGen = table(data, categorical(gen));
dataGen.Properties.VariableNames = {'Predictors' 'Response'};
% predicting values
age = predict(AgeSVM,d.statistics);
gen = predict(GenSVM,d.statistics);
netage = 1; %netAge.predict(dataAge);
netgen = 'f';% netGen.classify(dataGen);
end

