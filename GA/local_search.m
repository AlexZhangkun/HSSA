function [x1,fitness] = local_search(x1,I,fitness,P,Q,demand,customer,depot,D,C,F,O)
count = 1; k = 1;
while k <= 3
    if k == 1
        x2 = swap(x1,I);
    elseif k == 2
        x2 = inverse(x1);
%     elseif k == 5
%         x2 = interchange(x1,I);
    elseif k == 3
        x2 = insert(x1);
    elseif k == 4
        x2 = depot_mutation(x1,I);
    end
    x2 = check_feasibility(x2,I,P,Q,demand,customer,depot);
    fit = fun(x2,D,C,F,O,I);
    if fit < fitness
        x1 = x2; fitness = fit; 
    else
        count = count + 1;
        if count > 20
            k = k + 1;
            count = 0;
        end
    end
end
