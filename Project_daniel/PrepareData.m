function [datatable] = PrepareData(labelIn,statistics,sen)
[h,~] = size(labelIn);
label = table('Size',[h*sen 1],'VariableTypes',{class(labelIn(1))},'VariableNames',{'label'});
[h,l,z] = size(statistics);
stats = zeros(z,h*l);
for i = 1:z
    label.label(i) = labelIn(ceil(i/sen));
    stats(i,:) = reshape(statistics(:,:,i),1,h*l);
end
stats(isnan(stats)) = 0;
datatable = table(label.label,stats,'VariableNames',{'label','statistics'});
end

