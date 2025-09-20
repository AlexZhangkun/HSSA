function [X,fitness,e] = BVNS(X,fitness,kmax,customer,depot,I,D,C,O,F,P,Q,demand,e)
k = 1;
for i = 1 : length(X)
    while k <= kmax
        X1 = shake(X{i},kmax,I);
        [X2,fit] = local_search(X1,I,fitness(i),P,Q,demand,customer,depot,D,C,F,O);
%         x = check_feasibility(X2,I,P,Q,demand,customer,depot);
%         fit = fun(x,D,C,F,O,I);
        if fit < fitness(i) 
            X{i} = X2;  fitness(i) = fit; e(6) = e(6)+1;
            k = 1; 
        else
            k = k + 1;
        end
    end
end
end