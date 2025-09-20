function data = simular_demand(data)
    data.actualDemand = zeros(1,data.N);
    for j = 1: data.N
        while true 
            r = randperm(data.demand(j,3)-data.demand(j,1),1) + data.demand(j,1);
            alpha = membership(r,data.demand(j,:));
            if alpha > rand
                data.actualDemand(j) = r;
                break;
            end
        end
    end
end
                    