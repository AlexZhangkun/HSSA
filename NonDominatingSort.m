function [x, F] = NonDominatingSort(x,num)
    [x, F] = NonDominatedSorting(x); %��֧�������
    Num = numel(x); 
    if Num == num
        return;
    end
    x = CrowdingDistance(x,F);%ӵ����������(��ԭʼ�ķ���)
    p = []; i = 1;
    while numel(p) + numel(F{i}) <= num
%       [x,F{i}] = CrowdingDistanceAssignment1(x,F{i},d); 
        p = [p,F{i}];
        i = i + 1;
    end  
    [~,index] = sort([x(F{i}).CrowdDistance]);
    F{i} = F{i}(index);
    p = [p,F{i}(1:num-numel(p))];
    x = x(p);
    [x, F] = NonDominatedSorting(x); %��֧�������
end
        
    