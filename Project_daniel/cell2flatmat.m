function predictors = cell2flatmat(tbl)
predictors = zeros(size(tbl,1),size(cell2mat(tbl(1)),1)*size(cell2mat(tbl(1)),2));
for i = 1:size(tbl,1)
    OneDArray = reshape(cell2mat(tbl(i)).',1,[]);
    predictors(i,:) = OneDArray;
end
end

