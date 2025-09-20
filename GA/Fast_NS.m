function x = Fast_NS(x,fitness)
%% 快速非支配解排序
for i = 1: length(x)
    S{i}=[];%p支配的解集合
    N(i) = 0;%支配解x的个数
    for j = 1 : length(x)
        if dominate(x1,x2,fitness) == 1 %判断p、q之间的支配关系
            S{i} = [S{i},x{i}];
        else
            N(i) = N(i) + 1;
        end
    end
    F{1} = [];
    if N(i) == 0
        xrank(i) = 1; %前沿层次排序
        F{1} = [F1,x];
        c = 1;
    end
    while ~isempty(F{c})
        Q = {}; %下一层前沿的解集
        for k = 1: length(F{c})
            for l = 1 ; length(S{i})
                N(l) = N(l) - 1;
                if N(l) == 0 
                    rank(l) = c + 1;
                    Q = [Q,x{l}];
                end
            end
        end
    end
    c = c + 1;
    F{c} = Q;
end
    
    	