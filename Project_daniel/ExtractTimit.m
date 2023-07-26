function [info] = ExtractTimit()
fId = 'DOC\SPKRINFO.TXT';
t = readtable(fId,'Delimiter',';');
[h,~] = size(t);
t(:, [2]) = []; % resizing table
t([1:34],:) = []; % resizing table
baseT = string(zeros(h-34,9));
baseT = array2table(baseT);
%base data
for i = 1:h-34
    t2 = string(t{i,1});
    t2 = strsplit(t2);
    t2(:, [10:end]) = [];
    baseT(i,:) = array2table(t2);
end
%
fId = 'DOC\PROMPTS.TXT';
t = readtable(fId,'Delimiter',';');
[h,~] = size(t);
t([1:4],:) = []; % resizing table
t = strcat(t.Var1,t.File_Prompts_txt_Updated10_31_88); 
[h,~] = size(t);
sent1 = array2table(string(zeros(h,2)));
for i = 1:h
    t2 = string(t{i,1});
    t2 = strsplit(t2,'('); % removing the brackets
    tp = strsplit(t2(1,2),')');
    tp(:,[2]) = [];
    t2(1,2) = tp;
    sent1(i,:) = array2table(t2);
end

fId = 'DOC\SPKRSENT.TXT';
t = readtable(fId,'Delimiter',';');
[h,~] = size(t);
t(:, [2]) = []; % resizing table
t([1:7],:) = []; % resizing table
senT = string(zeros(h-7,10));
seNmT = array2table(senT); % name of sentences
senT = array2table(senT); % sentences
%sentince per person data
for i = 1:h-7
    t2 = string(t{i,1});
    t2 = strsplit(t2);
    t2(:, [1]) = [];
    t3 = t2;
    for j = 1:10 % inputing wich sentences used
        t2(1,j) = sent1{str2double(t2(1,j)),1};
        t3(1,j) = sent1{str2double(t3(1,j)),2};
    end
    seNmT(i,:) = array2table(t3);
    senT(i,:) = array2table(t2);
end
seNmT.Properties.VariableNames = {'seN1','seN2','seN3','seN4','seN5','seN6','seN7','seN8','seN9','seN10'};
[h,~] = size(baseT);
dir = string(zeros(h,1)); 
for i = 1:h % adding audio file directories
    if(baseT{i,4} == 'TRN')
        dir(i) = 'TRAIN\DR'+baseT{i,3}+'\'+baseT{i,2}+baseT{i,1}+'\'; 
    else
        if(baseT{i,4} == 'TST')
            dir(i) = 'TEST\DR'+baseT{i,3}+'\'+baseT{i,2}+baseT{i,1}+'\'; 
        end
    end
end
dir = array2table(dir);
baseT.Properties.VariableNames = {'ID','Sex','DR','Use','RecDate','BirthDate','Ht','Race','Edu'};
infoT = [baseT,senT,seNmT,dir];
Age = days(datetime(infoT.RecDate,'InputFormat',"MM/dd/uuuu")-datetime(infoT.BirthDate,'InputFormat',"MM/dd/uuuu"))/365;
infoT = addvars(infoT,Age,'Before','RecDate');
info = infoT;
[h,~] = size(info.Ht);
for i = 1:h
    p = strsplit(info.Ht(i),char(39));
    p(2) = str2double(erase(p(2),char(34)))/12;
    info.Ht(i) = convlength(sum(str2double(p),2),'ft','m');
end
fclose('all');
end

