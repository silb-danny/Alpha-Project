function [c,mae,inRange,rmse,rmser,maer] = drawAgeDist(svmAge,TestAge,f,type)
% pred1 = predict(svmAge,TrainAge.statistics);
% mae = mean(abs(TrainAge.label-pred1));
% rmse = sqrt(mean((TrainAge.label-pred1).^2));
% scatter(1:length(pred1),TrainAge.label, 'cyan',".");
% hold on
% scatter(1:length(pred1),pred1, 'magenta','.');
% % errorbar(1:length(pred1),TrainAge.label,TrainAge.label-pred1,'LineStyle',"none");
% hold off
if type == 'r'
    u = floor(TestAge.label/f)*f;
    c = unique(u);
    pred1 = predict(svmAge,TestAge.statistics);
    temp = min(abs(u-floor(pred1/f)*f),1);
    inRange = zeros(size(c,1),1);
    count = zeros(size(c,1),1);
    sum1 = zeros(size(c,1),1);
    y = TestAge.label-pred1;
    for i = 1:size(c,1)
        y1 = y(u == c(i));
        count(i)=size(y1,1);
        sum1(i)=sum(y1);
        inRange(i)=sum(temp(u == c(i)));
    end
end
if type == 'n'
    u = floor(TestAge.Response/f)*f;
    c = unique(u);
    pred1 = predict(svmAge,TestAge);
    temp = min(abs(u-floor(pred1/f)*f),1);
    inRange = zeros(size(c,1),1);
    count = zeros(size(c,1),1);
    sum1 = zeros(size(c,1),1);
    y = TestAge.Response-pred1;
    for i = 1:size(c,1)
        y1 = y(u == c(i));
        count(i)=size(y1,1);
        sum1(i)=sum(y1);
        inRange(i)=sum(temp(u == c(i)));
    end
end
if type == 'ne'
    u = floor(TestAge.Response/f)*f;
    c = unique(u);
    tbl = TestAge.Predictors;
    predictors = cell2flatmat(tbl);
    pred1 = predict(svmAge,predictors);
    temp = min(abs(u-floor(pred1/f)*f),1);
    inRange = zeros(size(c,1),1);
    count = zeros(size(c,1),1);
    sum1 = zeros(size(c,1),1);
    y = TestAge.Response-pred1;
    for i = 1:size(c,1)
        y1 = y(u == c(i));
        count(i)=size(y1,1);
        sum1(i)=sum(y1);
        inRange(i)=sum(temp(u == c(i)));
    end
end
mae = abs(sum1)./count;
rmse = sqrt(((sum1).^2)./count);
maer = mean(abs(y));
rmser = sqrt(mean((y).^2));

end
% scatter(1:length(pred1),TestAge.label, 'green',".");
% hold on
% scatter(1:length(pred1),pred1, 'magenta','.');
% pred1 = TestAge.label-pred1;
% yneg = (pred1 <= 0).*pred1;
% ypos = (pred1 > 0).*pred1;
% errorbar(1:length(pred1),TestAge.label,ypos,yneg,'LineStyle',"-");
% hold off
