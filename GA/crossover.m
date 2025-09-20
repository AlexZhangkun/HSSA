function [X,fitness] = crossover(X,Num,I,D,C,F,O,P,Q,demand,customer,depot,fitness)
%X1 精英个体 X2普通父代种群
h1 = randperm(Num/2,Num/2);
h2 = randperm(Num/2,Num/2)+ Num/2;
for i = 1 : Num/2
    if rand <= 1
        c1 = h1(i);
        c2 = h2(i);
    %         x = OX(X{c1},X{c2},I); %Order crossover
    %         x = AEX(E,X2{i},I); %Alter edge crossover
    %     [x1,x2] = Sub_tour_crossover(X{c1},X{c2});
%         [x1,x2] = OBX(X{c1},X{c2},I);
        [x1,x2] = OX(X{c1},X{c2},I);
        x1 = check_feasibility(x1,I,P,Q,demand,customer,depot);
        f1 = fun(x1,D,C,F,O,I);
        if sum(fitness == f1) >=2
            if f1< fitness(c1)
                X{c1} = x1;fitness(c1) = f1;
            else
%                 if rand < exp(-(f1-fitness(c1))/(K*T))
%                     X{c1} = x1; fitness(c1) = f1;
%                 end
            end
        end
        x2 = check_feasibility(x2,I,P,Q,demand,customer,depot);
        f2 = fun(x2,D,C,F,O,I);
        if sum(fitness == f2) >=2
            if f2 < fitness(i)
                X{c2} = x2;fitness(c2) = f2;
            else
%                 if rand < exp(-(f2-fitness(c2))/(K*T))
%                     X{c2} = x2; fitness(c2) = f2;
%                 end
            end
        end
    end
end
end