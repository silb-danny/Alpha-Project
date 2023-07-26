function [Gen,Age,y,Fs,filename] = indIn(info,ID,numS)
pNum = upper(ID);
[h,~] = size(info);
in = 1;
for i = 1:h % finding the row with the inputed name
    if(cell2mat(info.ID(i))== pNum)
        in = i;
    end
end
dir =  string(info.dir(in));
sen = string(upper(info.("seN"+numS)(in)));
filename = dir+sen+".WAV";
[y,Fs] = audioread(filename);
Gen = info.Sex(in);
Age = info.Age(in);
end

