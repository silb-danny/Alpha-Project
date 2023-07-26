function [extremeValues,statistics] = ErrorStats(pDataMat,bar)
% converts 3d data person matrix into 3d data statistic matrix with 18
% stats over all the audio file for all the 17 features and finds extreme
% values in the statistics matrix
t = mat2Stats(pDataMat);
[h,~,~] = size(t);
e = zeros(h,17);
for i = 1:h
    for j = 1:17
        [~,l] = size(histcounts(t(i,j,:)));
        g = sum(histcounts(t(i,j,:))==0);
        e(i,j) = g > l/bar;
    end
end
extremeValues = e;
statistics = t;
[row,col] = find(extremeValues == 1); % positions of extreme values
statistics(row,col,:) = 0;
end

