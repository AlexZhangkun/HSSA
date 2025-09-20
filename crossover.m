function x4 = crossover(E,data,ex,x2,x3)
x4 = ex; count = 1;
for i = 2 : length(E)
    x1 = ex;
    x1.route = SCX(E(1).route,E(i).route,data.M,size(data.customer,1),data.D);
    for l = 1 : numel(x1.route)
        if x1.route(l) > data.M
            if x1.route(l-1) <= data.M
                time = data.tw(x1.route(l)-data.M,2);
                route_time(x1.route(l)-data.M) = time;
            else   
                route_time(x1.route(l)-data.M) = time +  data.tw(x1.route(l-1)-data.M,5) + data.time(x1.route(l-1)-data.M,x1.route(l));
            end
        end
    end
    x1.time = route_time;
    x1 = feasible(x1,data);
    x1.fitness = fun(x1.route,x1.time,data);
    fi = reshape([x4.fitness,E.fitness,x2.fitness,x3.fitness],2,size([x4.fitness,E.fitness,x2.fitness,x3.fitness],2)/2)';
    if ~ismember(x1.fitness,fi,'rows') 
        x4(count) = x1; 
        count = count + 1;
    end
end