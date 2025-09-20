function b = dominate(p,q)
% %% y = 1 p do q; y = 0 ; q do q;
%     if isstruct(x)
%         x=x.fitness;
%     end
% 
%     if isstruct(y)
%         y=y.fitness;
%     end
% 
%     b=all(x<=y) && any(x<y);
        if isstruct(p)
            p = p.fitness;
        end
        if isstruct(q)
            q = q.fitness;
        end
        if  all(p<=q) && any(p<q)
            b = 1;
            if sum(p == q) == 2
                b = 2;
            end
        elseif all(q<=p) && any(q<p)
            b = 0;
            if sum(p == q) == 2
                b = 2;
            end
        else 
            b = 2;
        end


end