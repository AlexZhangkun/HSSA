%% ∑«÷ß≈‰Ω‚≈≈–Ú
function [x, F] = NonDominatedSorting(x)
    num = numel(x);
    F{1} = [];
    for i = 1: num
        x(i).doset=[];
        x(i).docount=0;
    end
    for i =  1 : num
        for j = i+1 : num
            p = x(i);
            q = x(j);
            if dominate(p,q) == 1 %p do q
                p.doset = [p.doset j];
                q.docount = q.docount + 1;
            elseif dominate(p,q) == 0 %q do p
                q.doset = [q.doset i];
                p.docount = p.docount + 1;
            end
            x(i) = p;
            x(j) = q;   
        end
        if x(i).docount == 0
            F{1} = [F{1},i];
            x(i).rank = 1;
        end
    end

    k = 1;
    while true
        Q=[];
        for i = F{k}
            p = x(i);
            for j = p.doset
                q = x(j);
                q.docount = q.docount - 1;
                if q.docount == 0
                    Q = [Q,j];
                    q.rank = k + 1;
                end
                x(j) = q;
            end
        end
        if isempty(Q)
            break;
        end
        F{k+1} = Q;
        k = k + 1;   
    end
end