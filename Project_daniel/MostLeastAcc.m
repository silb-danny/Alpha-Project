function [f,c,u] = MostLeastAcc(in,MinMax)
c = unique(in);
h = length(c);
f = 1:h;
for i = 1:h
    f(i) = length(find(in == c(i)));
end
u = f;
if(MinMax == "min")
    f = min(f);
else
    f = max(f);
end
end

