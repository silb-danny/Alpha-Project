function outputData = personalDataFromFile(label,filename)
[y,fs] = audioread(filename);
[dataInSamples,d] = valuesForsamples(y,fs,30,0,18);
d = {d};
data = table2array(dataInSamples);
data = reshape(data',1,[]); % converting data into a row vector
outputData = table(label,data,d);
end

