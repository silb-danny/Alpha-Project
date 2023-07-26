function [dataT] = PrepareForOne(y,fs,label,extremeValues)
pDataCell = {statsForsamples(y,fs,30,0)};
pDataMat = convToMat(pDataCell);
[~,statistics] = ErrorStats(pDataMat,3);
[row,col] = find(extremeValues == 1); % positions of extreme values
statistics(row,col,:) = 0;
dataT = PrepareData(label,statistics,1);
end

