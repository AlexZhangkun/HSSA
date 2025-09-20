function [x,F] = CrowdingDistanceAssignment1(x,F)
num = numel(F);
% d1 = zeros(1,num);
fit = [x(F).fitness];
% [~,index2] =  sort(fit(2,:));
% d1(index2(end)) = inf;
% for i = 2 : num-1
%     d1(i) = (x(i+1).fitness(1)-x(i-1).fitness(1))/(max(fit(1,:))-min(fit(1,:))) + (x(i+1).fitness(12)-x(i-1).fitness(2))/(max(fit(12,:))-min(fit(2,:)));
% end
for i = 1 : size(fit,1)
    [~,index1] =  sort(fit(i,:));
    x(F(index1(1))).crdis = inf; x(F(index1(end))).crdis = inf;
    for j = 2 : num - 1
        x(F(index1(j))).crdis = x(F(index1(j))).crdis  + (x(F(index1(j+1))).fitness(i)-x(F(index1(j-1))).fitness(i))/(max(fit(i,:))-min(fit(i,:)));
    end
end
end