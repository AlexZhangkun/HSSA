function x = Fast_NS(x,fitness)
%% ���ٷ�֧�������
for i = 1: length(x)
    S{i}=[];%p֧��Ľ⼯��
    N(i) = 0;%֧���x�ĸ���
    for j = 1 : length(x)
        if dominate(x1,x2,fitness) == 1 %�ж�p��q֮���֧���ϵ
            S{i} = [S{i},x{i}];
        else
            N(i) = N(i) + 1;
        end
    end
    F{1} = [];
    if N(i) == 0
        xrank(i) = 1; %ǰ�ز������
        F{1} = [F1,x];
        c = 1;
    end
    while ~isempty(F{c})
        Q = {}; %��һ��ǰ�صĽ⼯
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
    
    	