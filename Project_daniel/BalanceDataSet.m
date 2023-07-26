function [balancedData] = BalanceDataSet(data,label,MinMax,sen)
% equalizes dataset based on minmax
[f,c] = MostLeastAcc(label,MinMax);
h = length(c);
finalInd = ones(h,f);
for i = 1:h
    [~, y] = ismember(c(i),label);
    len = length(y);
    ind = circshift(mod(1:f,len),1)+1;
    finalInd(i,:) = y(ind);
end
finalInd = reshape(finalInd',[1 h*f]);
balancedData = data(finalInd,:);
len = floor(length(finalInd)/sen);
ranInd = repelem(randperm(len),sen);
ranInd = ranIndc(ranInd,sen,len); % randomize indexes based on group
balancedData = balancedData(ranInd,:);
end

