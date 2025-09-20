function x1 = sc_select(x,E,data,Num,ex)%,fitness,fit,Num,I,Q,P,D,C,F,O,demand,customer,depot)
% [~,index] = sort(x.fitness,'descend');
x1 = ex; count = 1;
for i = 1: Num*0.6
    X = ex;
    if rand <= 1
%         X.route = OX(E{randperm(5,1)},x{index(i)},I); % iOrder crossover    
%         X.route = AEX(E,x{index(i)},I); %Alter edge crossover 
%         X.route = SCX(E{1},x{index(i)},I,size(customer,1),D);
%        [X.route,x2] = Sub_tour_crossover(E,x{index(i)}); %subtour exchange crossover
        X.route = OBX(E(randperm(length(E),1)).route,x(i).route,data.M); %order-based crossover
    else
%         X.route = OX(E{1},x{index(i)},I);
        X.route = SCX(E{randperm(5,1)}.route,x(i).route,I,size(customer,1),D);
%         X.route = OBX(E{randperm(5,1)},x{index(i)},I); %order-based crossover
    end
    for l = 1 : numel(X.route)
        if X.route(l) > data.M
            if X.route(l-1) <= data.M
                time = data.tw(X.route(l)-data.M,2);
                route_time(X.route(l)-data.M) = time;
            else   
                route_time(X.route(l)-data.M) = time +  data.tw(X.route(l-1)-data.M,5) + data.time(X.route(l-1)-data.M,X.route(l));
            end
        end
    end
    X.time = route_time;
    X = feasible(X,data);
    X.fitness = fun(X.route,X.time,data);
    fi = reshape([x.fitness,x1.fitness],2,size([x.fitness,x1.fitness],2)/2)';
    
    if ~ismember(X.fitness,fi,'rows')
        x1(count) = X;
        count = count + 1;
    end
end
