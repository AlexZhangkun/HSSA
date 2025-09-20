function [x,F] = nondominatesort(x)
    num = numel(x); %种群数量
    for i = 1: num
        x(i).dset=[];
        x(i).dcount=0;
    end
    F{1} = []; %找第一层级
    for i = 1 : num
        for j = i+1 : num
            p = x(i);
            q = x(j);
            if dominate(p,q) == 1 % p do q 
                p.dset = [p.dset, j];
                q.dcount = q.dcount + 1;
            elseif dominate(p,q) == 0 % q do p
                q.dset = [q.dset, i];
                p.dcount = p.dcount + 1;
            end
            x(i) = p;
            x(j) = q;
        end
        if x(i).dcount == 0
            F{1} = [F{1},i];
            x(i).rank = 1;
        end
    end
    k = 1;
    while true % 排序其他层级
        Q = [];
        for i = F{k}
            p = x(i);
            for j = p.dset
                q = x(j);
                q.dcount = q.dcount - 1;
                if q.dcount == 0
                    Q = [Q, j];
                    q.rank = k + 1;
                end
                x(j) = q;
            end
        end
        if isempty(Q)
            break;
        end
        k = k + 1;
        F{k} = Q;
    end
end
            
    
    