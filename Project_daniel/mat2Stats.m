function [values] = mat2Stats(pepMatrix)
[~,t,pep] = size(pepMatrix);
[h,~] = size(extractStats(1:10));
values = zeros(h,t,pep);
for z = 1:pep % looping through every person
    for x = 1:t % looping through each feature
        temp = pepMatrix(:,x,z);
        values(:,x,z) = extractStats(temp(~isnan(temp)));
    end
end
end

