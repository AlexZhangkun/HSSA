function y = dominate(p,q)
%% y = 1 p do q; y = 0 ; q do q; 
% a = feasible(p); b = feasible(q);
%     if a == 1 && b == 1%pq¶¼¿ÉÐÐ
        if isstruct(p)
            p = p.fit;
        end
        if isstruct(q)
            q = q.fit;
        end
        if  all(p<=q) && any(p<q)
            y = 1;
        elseif all(q<=p) && any(q<p)
            y = 0;
        else
            y = 2;
        end
end
        