function [matrix3dData] = convToMat(p)
% converting cells into 3d matrix where each layer is data of person
z = length(p); % people
x = max(cellfun('size',p,2)); % columns
y = max(cellfun('size',p,1)); % rows
matrix3dData = zeros(y,x,z);
matrix3dData(matrix3dData == 0) = nan;
for i = 1:z
    [h,w] = size(p{i});
    matrix3dData(1:h,1:w,i) = p{i}(:,:);
end
end

