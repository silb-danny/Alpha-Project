function [ranInd] = ranIndc(ranIn,sen,k)
% k -> length before groups
% sen -> amount of elements in group
% ranIn -> randomly distrubted elements
ranInd = sen*(ranIn-1) + (circshift(mod(1:k*sen,sen),1)+1); % randomly distrubuting based on groups
end

