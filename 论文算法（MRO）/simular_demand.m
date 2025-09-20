function data = simular_demand(data)
data.actualDemand = cell(1,2);
    for i = 1: data.l
        for j = 1: data.N
            while true 
                r = randperm(data.demand{i}(j,3)-data.demand{i}(j,1),1) + data.demand{i}(j,1);
                alpha = membership(r,data.demand{i}(j,:));
                if alpha > rand
                    data.actualDemand{i}(j) = r;
                    break;
                end
            end
        end
    end
end
                    