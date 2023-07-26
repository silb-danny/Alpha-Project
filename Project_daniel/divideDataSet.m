function [Test,Train] = divideDataSet(dataT,sen,perc)
h = size(dataT,1);
trainL = ceil((h/sen)*perc); % training length
testL = (h/sen)-trainL; % testing length
randV = randperm(h/sen,testL); % generating unreapeating random values
tstRnd = repelem(randV,sen);
trnRn = setxor(1:h/sen,tstRnd);
trnRnd = repelem(trnRn,sen);
tstRnd = ranIndc(tstRnd,sen,testL);
trnRnd = ranIndc(trnRnd,sen,trainL);
Test = dataT(tstRnd,:);
Train = dataT(trnRnd,:);
end

