function [tab] = pepTocell(dataTimit,sen)
% calculates statistics on audio file for each speaker for every (sen)
% amount of sentences
[h,~] = size(dataTimit);
tab = cell(1,h*sen);
for i = 0:h-1
    ID = dataTimit.ID(i+1);
    for j = 1:sen
        [~,~,y,fs,~] = indIn(dataTimit,ID,j);
        p = statsForsamples(y,fs,30,0);
        tab{i*sen+j} = p;
    end
end
end

