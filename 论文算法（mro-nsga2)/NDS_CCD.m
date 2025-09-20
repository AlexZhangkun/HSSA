function [x,x_child, F] = NDS_CCD(x,Num,c_num)
    [x, F] = NonDominatedSorting(x); %非支配解排序
    num = numel(x); 
    if Num == num
        F11 = [];       
        for i = 1 : numel(F)-1
            F11 = [F11,F{i}];
            if numel(F11) + numel(F{i+1}) >Num/(c_num+1)
                F11 = [F11,F{i+1}(1:Num/(c_num+1) - numel(F11))];
                break
            end
        end       
        x_child = x(setdiff(1:Num,F11));
        x = x(F11);
        return;
    end
    x = CrowdingDistance(x,F);%拥挤距离排序(最原始的方法)
    p = []; i = 1;
    while numel(p) + numel(F{i}) <= Num
%       [x,F{i}] = CrowdingDistanceAssignment1(x,F{i},d); 
        p = [p,F{i}];
        i = i + 1;
    end  
    [~,index] = sort([x(F{i}).CrowdDistance]);
    F{i} = F{i}(index);
    p = [p,F{i}(1:Num-numel(p))];
    x = x(p);
    [x, F] = NonDominatedSorting(x); %非支配解排序
    F11 = [];    
    if numel(F) ~= 1
        for i = 1 : numel(F)-1
            F11 = [F11,F{i}];
            if numel(F11) + numel(F{i+1}) >Num/(c_num+1)
                F11 = [F11,F{i+1}(1:Num/(c_num+1) - numel(F11))];
                break
            end
        end 
    x_child = x(setdiff(1:Num,F11));
    x = x(F11);
    else
        x_child = x(Num/2 + 1:end);
        x = x(1:Num/2);
    end
end
        
    