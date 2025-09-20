function [route,time] = greedy_cluster(data)
    %% 聚类客户
    c.cluster = [];
    c.sum_dem = [];
    c.gra = [];
    c.time = [];
    demand = data.demand; 
    non_c = 1:data.N;%初始化未被分配客户
    k = 1;
    while ~isempty(non_c)
        c.cluster{k} = []; %初始化聚类
        c.sum_dem{k} = zeros(1,3);
        q = repmat(data.Q,3,1);%初始化剩余车辆容量
        j = non_c(randi(numel(non_c)));%随机选择一个客户
        time = data.tw(j,2);
        c.time(j) = time;
        dc = non_c;
        while ~isempty(dc)
            if time_c(data.tw(j,:),time) >= data.alpha  && Cr(demand(j,:),q) >= data.DPI
                c.cluster{k} = [c.cluster{k}, j];
                de = demand(j,:);
                q = q - de(end:-1:1);
                c.sum_dem{k} = c.sum_dem{k} + de;
                c.time(j) = time;
                time = time + data.tw(j,5);
                dc(dc == j) = [];
                if isempty(dc)
                    break;
                else
                    [~,j] = min(data.D(j,dc));
                    j = dc(j);
                    time = time + data.time(c.cluster{k}(end)+data.M,j+data.M);
                end
            else
                dc(dc == j) = [];
                if isempty(dc)
                    break;
                else
                    time = time - data.time(c.cluster{k}(end)+data.M,j+data.M);
                    [~,j] = min(data.D(j,dc));
                    j = dc(j);%随机选择一个客户
                    time = time + data.time(c.cluster{k}(end)+data.M,j+data.M);
                end
            end
        end
        non_c = setdiff(non_c,c.cluster{k});
         if numel((c.cluster{k}))~=1
             c.gra{k} = sum(data.customer(c.cluster{k},:))/numel((c.cluster{k})); %计算每个聚类的重心
         else
             c.gra{k} = data.customer(c.cluster{k},:); %计算每个聚类的重心
         end
        k = k + 1;
    end
    time = c.time;

     %% 分配处理中心
     %计算重心到仓库的距离
    g2d = zeros(1,numel(c.gra));
    for i = 1: data.M
        for l = 1 : numel(c.gra)
            g2d(i,l) = dis(c.gra{1,l},data.depot(i,:));
        end
    end
    u = sum(data.D(1:data.M,data.M+1:end)');%计算仓库到每个客户的距离之和
    [~,w] = sort(data.P'./(u.*data.O'),'descend'); %对仓库开放等级进行排序
    route = [];
    g2d1 = g2d;
    dem = c.sum_dem;%每个聚类第i种货物的需求
    non_cl = 1: numel(c.cluster); %未被分配的聚类
    while ~isempty(non_cl)
        d = w(1);
        p = repmat(data.P(d),1,3);%仓库剩余i货物容量
        [~,cl] = min(g2d1(d,:));
        ncl = non_cl; %初始化未被分配的聚类
        while ~isempty(ncl)
            if Cr(dem{cl},p) >= data.API
                route = [route,d,c.cluster{cl}+data.M];
                p = p - dem{cl}(end:-1:1);
%                     ncl = setdiff(ncl,cl);
%                     non_cl = setdiff(non_cl,cl);
                ncl(ncl == cl) = [];
                non_cl(non_cl == cl) = [];
                if isempty(ncl)
                    for cc = 1 : size(data.depot,1)
                        g2d1(cc,cl) = inf;
                    end
                    break;
                else
                    for cc = 1 : size(data.depot,1)
                        g2d1(cc,cl) = inf;
                    end
                    [~,cl] = min(g2d1(d,:));
                end
            else
%                     ncl = setdiff(ncl,cl);
                ncl(ncl == cl) = [];
                if isempty(ncl)
                    g2d1(d,cl) = inf;
                    break;
                else
                    g2d1(d,cl) = inf;
                    [~,cl] = min(g2d1(d,:));
                end 
            end
        end
        w(1) = [];
    end       

    if sum(route>5) >30
        b = 0;
    end

