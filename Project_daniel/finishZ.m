function [newY] = finishZ(y,amount)
[l,~] = size(y);
newY = zeros(ceil(l/amount)*amount,1);
newY(1:l,1) = y;
end

