function [x,fitness,E,fit,c] = sc_select(x,E,fitness,fit,Num,I,Q,P,D,C,F,O,demand,customer,depot,c)
[~,index] = sort(fitness,'descend');
for i = 1: Num 
    if rand <= 1
%         x1 = OX(E{randperm(5,1)},x{index(i)},I); % iOrder crossover    
%         x1 = AEX(E,x{index(i)},I); %Alter edge crossover 
%         x1 = SCX(E{1},x{index(i)},I,size(customer,1),D);
%        [x1,x2] = Sub_tour_crossover(E,x{index(i)}); %subtour exchange crossover
        x1 = OBX(E{randperm(5,1)},x{index(i)},I); %order-based crossover
        X = check_feasibility(x1,I,P,Q,demand,customer,depot);
        f = fun(X,D,C,F,O,I);
    end
    if  sum(fitness == f) < 2
        if f <  fitness(index(i)) 
            fitness(index(i)) = f; x{index(i)} = X;
        end
    end
%     else
%         x1 = OX(E{randperm(5,1)},x{i},I);
% %         x1 = SCX(E{randperm(5,1)},x{index(i)},I,size(customer,1),D);
% %         x1 = OBX(E{randperm(5,1)},x{index(i)},I); %order-based crossover
%         X = check_feasibility(x1,I,P,Q,demand,customer,depot);
%         f = fun(X,D,C,F,O,I);
%         if f <  fitness(i) 
%             fitness(i) = f; x{i} = X;c(2) = c(2) + 1;
%         end
%     end
end
for j = 1 : length(E)
%     if rand <= 0.8
% %     x2 = SCX(E{1},E{j},I,size(customer,1),D);
% %     x2 = OX(E{1},E{j},I); % iOrder crossover 
%         x2 = OBX(E{1},E{j},I); %order-based crossover
%         X = check_feasibility(x2,I,P,Q,demand,customer,depot);
%         f = fun(X,D,C,F,O,I);
%     else
        [X,f]  = local_search(x{i},I,fitness(i),P,Q,demand,customer,depot,D,C,F,O);
%     end
%     if sum(fit == f) <=1
        if f < fit(j) 
            fit(j) = f; E{j} = X;
        end
%     end    
end

