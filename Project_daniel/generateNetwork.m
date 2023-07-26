function [netGen,netAge,netGenErr,netAgeErr] = generateNetwork(NetworkDataGen,validateGen,NetworkDataAge,validateAge,smSize,learningRates,batches,disp)
A = categorical(NetworkDataGen.Response);
numClasses = numel(categories(A));
numHops = 32;
numBands = smSize;
timePoolSize = ceil(numHops/8);

dropoutProb = 0.2;
numF = 12;
netGen = cell(size(learningRates,1),size(batches,1));
netGenErr = zeros(size(learningRates,1),size(batches,1));
netAge = cell(size(learningRates,1),size(batches,1));
netAgeErr = zeros(size(learningRates,1),size(batches,1));
for L = 1:size(learningRates,1)
    learningRate = learningRates(L);
    for b = 1:size(batches,1)
        batch = batches(b);
        layers = [
            imageInputLayer([numHops numBands])

            convolution2dLayer(3,numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,2*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer
            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer([timePoolSize,1])

            dropoutLayer(dropoutProb)
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];
        if disp
        options = trainingOptions('adam', ...
            'InitialLearnRate',learningRate, ...
            'MaxEpochs',25, ...
            'MiniBatchSize',batch, ...
            'Shuffle','every-epoch', ...
            'Plots','training-progress', ...
            'Verbose',true, ...
            'ValidationData',validateGen, ...
            'ValidationFrequency',30, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropFactor',0.1, ...
            'LearnRateDropPeriod',20);
        else
        options = trainingOptions('adam', ...
            'InitialLearnRate',learningRate, ...
            'MaxEpochs',25, ...
            'MiniBatchSize',batch, ...
            'Shuffle','every-epoch', ...
            'Verbose',true, ...
            'ValidationData',validateGen, ...
            'ValidationFrequency',30, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropFactor',0.1, ...
            'LearnRateDropPeriod',20);
        end
%         [net,info] = trainNetwork(NetworkDataGen,layers,options);
%         netGen(L,b) = {net};
%         netGenErr(L,b) = info.FinalValidationAccuracy;
        layers = [
            imageInputLayer([numHops numBands])

            convolution2dLayer(3,numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,2*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer(3,'Stride',2,'Padding','same')

            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer
            convolution2dLayer(3,4*numF,'Padding','same')
            batchNormalizationLayer
            reluLayer

            maxPooling2dLayer([timePoolSize,1])

            dropoutLayer(dropoutProb)
            fullyConnectedLayer(1)
            regressionLayer()];
        if disp
        options = trainingOptions('adam', ...
            'InitialLearnRate',learningRate, ...
            'MaxEpochs',7, ...
            'MiniBatchSize',batch, ...
            'Shuffle','every-epoch', ...
            'Plots','training-progress', ...
            'Verbose',true, ...
            'ValidationData',validateAge, ...
            'ValidationFrequency',30, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropFactor',0.1, ...
            'LearnRateDropPeriod',20);
        else
            options = trainingOptions('adam', ...
            'InitialLearnRate',learningRate, ...
            'MaxEpochs',7, ...
            'MiniBatchSize',batch, ...
            'Shuffle','every-epoch', ...
            'Verbose',true, ...
            'ValidationData',validateAge, ...
            'ValidationFrequency',30, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropFactor',0.1, ...
            'LearnRateDropPeriod',20);
        end
        [net,info] = trainNetwork(NetworkDataAge,layers,options);
        netAge(L,b) = {net};
        netAgeErr(L,b) = info.FinalValidationRMSE;
    end
end
end

