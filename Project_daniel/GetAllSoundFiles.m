function [ys,fss] = GetAllSoundFiles(dataTimit,sen)
[h,~] = size(dataTimit);
ys = cell(1,h*sen);
fss = cell(1,h*sen);
for i = 0:h-1 % for each person
    ID = dataTimit.ID(i+1);
    for j = 1:sen % for each sentence
        [~,~,y,fs,~] = indIn(dataTimit,ID,j);
        ys{i*sen+j} = y;
        fss{i*sen+j} = fs;
    end
end
end


