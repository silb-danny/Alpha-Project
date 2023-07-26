function [weights] = CalcWeights(label,t)
% calculates weights for dataset (labels for the dataset)
c = unique(label);
len = size(label,1);
h = length(c);
weights = ones(len,1);
for i = 1:h
   y = find(label == c(i));
   sweight = length(y);
   if(t == 'r' || t == "reg")
       weights(y) = 1/sweight;
   end
end
end

