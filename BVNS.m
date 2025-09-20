function X = BVNS(X,data,kmax)
k = 1;
for i = 1 : numel(X)
    while k <= kmax
        X1 = shake(X{i},kmax,data.M);
        x = check_feasibility(X1,data);
        x.fitness = fun(x.route,x.arrtime,data);
%         if sum(fitness == fit) == 0
%             if fit < fitness(i) 
%                 X{i} = x;  fitness(i) = fit;
%                 k = 1;
%             else
%                 k = k + 1;
%             end
%         end
    end
end
end