function x = feasible(x,data)
    q = cell(1,data.l); %计算车辆容量 
    p = cell(1,data.l); %计算转运中心容量
    ir = cell(1,data.l);
    id = cell(1,data.l);
    newx = cell(1,data.l);A = 0; B = 0;
    for j = 1 : data.l
        a = find(x.route{j}<= data.M);
        len = length(a);
        p{j} = cell(1,data.M);
        newx{j} = cell(1,data.M);
        p1 = repmat(data.P(:,j),1,3);
        p2 = p1;%剩余仓库容量
        for i = 1: len
            q1 = repmat(data.Q(j),1,3); 
            if i < len
                newx{j}{x.route{j}(a(i))} = [newx{j}{x.route{j}(a(i))} , x.route{j}(a(i)+1:a(i+1)-1)];
                if a(i)+1 == a(i+1)-1
                    q{j}{i} = data.demand{j}(x.route{j}(a(i)+1:a(i+1)-1)-data.M,:);
                else
                    q{j}{i} = sum(data.demand{j}(x.route{j}(a(i)+1:a(i+1)-1)-data.M,:));
                end
            else
                newx{j}{x.route{j}(a(i))} = [newx{j}{x.route{j}(a(i))} , x.route{j}(a(i)+1:end)];
                if a(i)+1 == numel(x.route{j})
                    q{j}{i}  = data.demand{j}(x.route{j}(a(i)+1:end)-data.M,:);
                else
                    q{j}{i}  = sum(data.demand{j}(x.route{j}(a(i)+1:end)-data.M,:));
                end
            end
            if Cr(q{j}{i},q1)<data.DPI
                ir{j} = [ir{j}, x.route{j}(a(i))];%记录不可行的线路属于的仓库 
                A = 1;
            end
            if isempty(p{j}{x.route{j}(a(i))})
                p{j}{x.route{j}(a(i))} = q{j}{i}; 
            else
                p{j}{x.route{j}(a(i))} = p{j}{x.route{j}(a(i))} + q{j}{i}; 
            end
            if Cr(p{j}{x.route{j}(a(i))} ,p1(x.route{j}(a(i)),:)) < data.API
                id{j} = [id{j}, x.route{j}(a(i))];%记录不可行的仓库
                B = 1;
            end
        end
        for u = 1: numel(p)
            if ~isempty(p{j}{u})
                p2(u,:) = p2(u,:) - p{j}{u}(end:-1:1);
            end
        end
        if ~isempty(ir{j}) && isempty(id{j}) %车辆超过容量，仓库未超过容量，重新安排该仓库的车辆路径
            for k = 1 : numel(ir{j}) 
                dindex = data.depot{j}(ir{j}(k),:);
                customer = data.customer(newx{j}{ir{j}(k)}-data.M,:);
                demand = data.demand{j}(newx{j}{ir{j}(k)}-data.M,:);
                Q = data.Q(j);
                tw = data.tw{j}(newx{j}{ir{j}(k)}-data.M,:);
                time = data.time{j}([ir{j}(k),newx{j}{ir{j}(k)}],:);
                [r,t] = vrptw(dindex,customer,demand,Q,tw,time,data.DPI);
                rou = [ir{j}(k),newx{j}{ir{j}(k)}];
                route{j}{ir{j}(k)} = rou(r);
                x.arrtime(j,newx{j}{ir{j}(k)}) = t;%arrtime(j,newx{j}{ir{j}(k)}) = t;
            end
            dep = setdiff(1:data.M,rou(rou<=data.M)); %将剩余仓库的客户安排路径
            for l = 1:numel(dep)
                depot = data.depot{j}(dep(l),:);
                customer = data.customer(newx{j}{dep(l)}-data.M,:);
                demand = data.demand{j}(newx{j}{dep(l)}-data.M,:);
                Q = data.Q(j);
                tw = data.tw{j}(newx{j}{dep(l)}-data.M,:);
                time = data.time{j}([dep(l),newx{j}{dep(l)}],:);
                [r,t] = vrptw(depot,customer,demand,Q,tw,time,data.DPI);
                rou = [dep(l),newx{j}{dep(l)}];
                route{j}{dep(l)} = rou(r);
                x.arrtime(j,newx{j}{dep(l)}-data.M) = t;
            end
            
        elseif ~isempty(id{j}) %仓库超过容量，剔除超过的一部分客户，再重新安排路径
            for k = 1 : numel(unique(id{j}))
                cust = []; dema = zeros(1,3);
                while Cr(p{j}{id{j}(k)} ,p1(id{j}(k),:)) < data.API
                    d = data.demand{j}(newx{j}{id{j}(k)}(end)-data.M,:);
                    p{j}{id{j}(k)} = p{j}{id{j}(k)} - d; 
                    p2(id{j}(k),:) = p2(id{j}(k),:) + d(end:-1:1);
                    cust = [cust,newx{j}{id{j}(k)}(end)];
                    dema = dema + d;
                    newx{j}{id{j}(k)}(end) = [];
                end
                depot1 = find(sum((p2 - dema(end:-1:1) >=0)') == 3);
                index = depot1(randi(numel(depot1)));
                depot = data.depot{j}(index,:);
                newx{j}{index} = [newx{j}{index},cust];
                customer = data.customer(newx{j}{index}-data.M,:);
                demand = data.demand{j}(newx{j}{index}-data.M,:);
                Q = data.Q(j);
                tw = data.tw{j}(newx{j}{index}-data.M,:);
                time = data.time{j}([index,newx{j}{index}],:);
                [r,t] = vrptw(depot,customer,demand,Q,tw,time,data.DPI);

                rou = [index,newx{j}{index}];
                route{j}{index} = rou(r);                
                x.arrtime(j,newx{j}{index}-data.M) = t;
            end
            dep = setdiff(1:data.M,rou(rou<=data.M)); %将剩余仓库的客户安排路径
            for l = 1:numel(dep)
                depot = data.depot{j}(dep(l),:);
                customer = data.customer(newx{j}{dep(l)}-data.M,:);
                demand = data.demand{j}(newx{j}{dep(l)}-data.M,:);
                Q = data.Q(j);
                tw = data.tw{j}(newx{j}{dep(l)}-data.M,:);
                time = data.time{j}([dep(l),newx{j}{dep(l)}],:);
                [r,t] = vrptw(depot,customer,demand,Q,tw,time,data.DPI);
                rou = [dep(l),newx{j}{dep(l)}];
                route{j}{dep(l)} = rou(r);
                x.arrtime(j,newx{j}{dep(l)}-data.M) = t;
            end
        end
    end   
    if A==1||B==1
        X =cell(1,numel(route));
        for i = 1 : numel(route)
            if ~isempty(route{i})
                for j = 1: numel(route{i})
                    X{i} = [X{i},route{i}{j}];
                end
               x.route{i} = X{i}; 
            end
        end
    end
end