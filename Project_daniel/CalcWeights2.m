function [classWeights,classes] = CalcWeights2(NetworkDataAge)
% calculates weights for dataset (labels for the dataset)
% better calculation
A = categorical(floor(NetworkDataAge));
classWeights = 1./countcats(A);
classWeights = classWeights'/mean(classWeights);
classes = str2double(categories(A));
end

