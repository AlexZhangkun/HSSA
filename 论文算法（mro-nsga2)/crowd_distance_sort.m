function [x, F, cdistance] = crowd_distance_sort(x,F)
    I = numel(F{1});
    cdistance = zeros(1,I); %初始化拥挤距离
    fit = F1.fit;
    for j = 1 : 2 %目标函数个数
        [fitness,rank] = sort(fit(:,j));
        cdistance(1) = inf; cdistance(end) = inf;
        for i = 2 : I-1
            cdistance(rank(i)) = cdistance(rank(i)) + (fitness(i+1,j) - fitness(i-1,j)) / (fitness(I,j)-fitness(1,j));
        end
    end
end
