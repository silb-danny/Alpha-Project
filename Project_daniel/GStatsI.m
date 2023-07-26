function [S,A,H,TRnTSt] = GStatsI(info)
[S,~,Sc] = unique(info(:,2));
S = table2array(S);
s = S;
[h,~] = size(S);
for i = 1:h
    s(i) = sum(info.Sex == S(i));
end
S = table(S,s);
[A,~,Ac] = unique(floor(info.Age));
a = A;
[h,~] = size(A);
for i = 1:h
    a(i) = sum(floor(info.Age) == A(i));
end
A = table(A,a);
[H,~,Hc]= unique(floor(str2double(info.Ht)*100));
ht = H;
[h,~] = size(H);
for i = 1:h
    ht(i) = sum(floor(str2double(info.Ht)*100) == H(i));
end
H = table(H,ht);
[t,~,ts] = unique(info.Use);
T=t;
[h,~] = size(t);
for i = 1:h
    T(i) = sum(info.Use == t(i));
end
TRnTSt = table(t,T);
end

