function x = feasible(x,data)
a = find(x.route<= data.M);
len = length(a);
q = zeros(len,3);%初始化车辆容量
p = zeros(data.M,3);%初始化仓库剩容量
uc = [];%记录又不满足时间窗的车辆属于的仓库
ud = [];%记录不满足容量限制的仓库
new_x = cell(1,data.M);
for i = 1: len
    if i < len
        for l  = 1: numel(a(i)+1:a(i+1)-1) %时间窗是否满足
            if time_c(data.tw(x.route(a(i)+l)-data.M,:),x.time(x.route(a(i)+l)-data.M)) < data.alpha
                if ~ismember(x.route(a(i)),uc)
                    uc = [uc, x.route(a(i))];
                end
                break;
            end
        end   
        if a(i)+1 ~= a(i+1)-1
            q(i,:) = sum(data.demand(x.route(a(i)+1:a(i+1)-1)-data.M,:));
        else
            q(i,:) = data.demand(x.route(a(i)+1:a(i+1)-1)-data.M,:);
        end
        if Cr(q(i,:),repmat(data.Q,1,3)) < data.DPI
            if ~ismember(x.route(a(i)),uc)
                uc = [uc, x.route(a(i))];
            end
        end
        new_x{x.route(a(i))} = [new_x{x.route(a(i))},x.route(a(i)+1:a(i+1)-1)];
    else
        for l  = 1: numel(a(i)+1:length(x.route)) %时间窗是否满足
            if time_c(data.tw(x.route(a(i)+l)-data.M,:),x.time(x.route(a(i)+l)-data.M)) < data.alpha
                if ~ismember(x.route(a(i)),uc)
                    uc = [uc, x.route(a(i))];
                end
                break;
            end
        end   
        if a(i)+1 ~= length(x.route)
            q(i,:) = sum(data.demand(x.route(a(i)+1:end)-data.M,:));
        else
            q(i,:) = data.demand(x.route(a(i)+1:end)-data.M,:);
        end
        new_x{x.route(a(i))} = [new_x{x.route(a(i))},x.route(a(i)+1:end)];
    end
    p(x.route(a(i)),:) = p(x.route(a(i)),:) + q(i,:);
end

for i = 1 : data.M
    if Cr(p(i,:),repmat(data.P(i),1,3)) < data.API
        ud = [ud, i];
    end
end

%给超出容量限制的仓库重新安排客户使其满足容量限制
cust = [];%记录被删除的客户
for i = 1 : length(ud)
%     depuli = new_x{ud(i)};
    [~,c] = max(data.D(ud(i),new_x{ud(i)}));
    p(ud(i),:) = p(ud(i),:) - data.demand(new_x{ud(i)}(c)-data.M,:);
    cust = [cust,new_x{ud(i)}(c)];
    new_x{ud(i)}(new_x{ud(i)} == new_x{ud(i)}(c)) = [];
    while Cr(p(ud(i),:),repmat(data.P(ud(i)),1,3)) < data.API
        [~,c] = max(data.D(ud(i),new_x{ud(i)}));
        p(ud(i),:) = p(ud(i),:) - data.demand(new_x{ud(i)}(c)-data.M,:);
        cust = [cust,new_x{ud(i)}(c)];
        new_x{ud(i)}(new_x{ud(i)} == new_x{ud(i)}(c)) = [];
    end
end
    
%给剔除的客户分配仓库（首先考虑容量限制，优先考虑已经开放的仓库，在根据距离来选择)）
for i = 1 : length(cust)
    pot_depot = [];%备选仓库集合
    for j = 1 : data.M
        if Cr(p(j,:)+data.demand(cust(i)-data.M),repmat(data.P(j),1,3)) >= data.API
            pot_depot = [pot_depot,j];
        end
    end 
    [~,index] = min(data.D(cust(i),pot_depot(p(pot_depot,3) >0)));
    if isempty(index)
        index = randi(length(pot_depot));
    end
    new_x{pot_depot(index)} = [new_x{pot_depot(index)},cust(i)];
end
x.route = []; 
for i = 1 : data.M
    if ~isempty(new_x{i})
        time = data.time([i,new_x{i}],[i,new_x{i}]);
        D = data.D([i,new_x{i}],[i,new_x{i}]);
        [r,t] = vrptw(data.customer(new_x{i}-data.M,:),data.demand(new_x{i}-data.M,:),data.Q,data.tw(new_x{i}-data.M,:),time,data.DPI,data.alpha,D);
        rou = [i,new_x{i}];
        x.route = [x.route,rou(r)];
        x.time(new_x{i}-data.M) = t;
    end
end
     
    