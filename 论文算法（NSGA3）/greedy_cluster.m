function [route,time] = greedy_cluster(data)
    %% 聚类客户
    c.cluster = [];
    c.sum_dem = [];
    c.gra = [];
    c.time = [];
    c = repmat(c,data.l,1);
        for i = 1: data.l
            demand = data.demand{i}; 
            non_c = 1:data.N;%初始化未被分配客户
            k = 1;
            while ~isempty(non_c)
                c(i).cluster{k} = []; %初始化聚类
                c(i).sum_dem{k} = zeros(1,3);
                q = repmat(data.Q(i),3,1);%初始化剩余车辆容量
                j = non_c(randi(numel(non_c)));%随机选择一个客户
                time = data.tw{i}(j,2);
                c(i).time(j) = time;
                dc = non_c;
                while ~isempty(dc)
                    if time_c(data.tw{i}(j,:),time) >= data.alpha  && Cr(demand(j,:),q) >= data.DPI
                        c(i).cluster{k} = [c(i).cluster{k}, j];
                        de = demand(j,:);
                        q = q - de(end:-1:1);
                        c(i).sum_dem{k} = c(i).sum_dem{k} + de;
                        c(i).time(j) = time;
                        time = time + data.tw{i}(j,5);
                        dc(dc==j) = [];
                        if isempty(dc)
                            break;
                        else
                            [~,j] = min(data.D{i}(j,dc));
                            j = dc(j);
                            time = time + data.time{i}(c(i).cluster{k}(end)+data.M,j+data.M);
                        end
                    else
                        dc(dc==j) = [];
                        if isempty(dc)
                            break;
                        else
                            time = time - data.time{i}(c(i).cluster{k}(end)+data.M,j+data.M);
                            [~,j] = min(data.D{i}(j,dc));
                            j = dc(j);%随机选择一个客户
                            time = time + data.time{i}(c(i).cluster{k}(end)+data.M,j+data.M);
                        end
                    end
                end
                non_c = setdiff(non_c,c(i).cluster{k});
                 if numel((c(i).cluster{k}))~=1
                     c(i).gra{k} = sum(data.customer(c(i).cluster{k},:))/numel((c(i).cluster{k})); %计算每个聚类的重心
                 else
                     c(i).gra{k} = data.customer(c(i).cluster{k},:); %计算每个聚类的重心
                 end
                k = k + 1;
            end
        end
time = [[c(1).time];[c(2).time]];


     %% 分配处理中心
     %计算重心到仓库的距离
    g2d = cell(1,data.l);
    u = cell(1,data.l);
    w = cell(1,data.l);
    for j = 1 : data.l
        for i = 1: data.M
            for l = 1 : numel(c(j).gra)
                g2d{j}{i}(l) = dis1(c(j).gra{1,l},data.depot{j}(i,:));
            end
        end
        u{j} = sum(data.D{j}(1:data.M,data.M+1:end)');%计算仓库到每个客户的距离之和
        [~,w{j}] = sort(data.P(:,j)'./(u{j}.*data.O(:,j)'),'descend'); %对仓库开放等级进行排序
    end
    route = cell(1,data.l);
    g2d1 = g2d;
    for i = 1 : data.l
        dem = c(i).sum_dem;%每个聚类第i种货物的需求
        non_cl = 1: numel(c(i).cluster); %未被分配的聚类
        while ~isempty(non_cl)
            d = w{i}(1);
            p = repmat(data.P(d,i),1,3);%仓库剩余i货物容量
            [~,cl] = min(g2d1{i}{d});
            ncl = non_cl;
            while ~isempty(ncl)
                if Cr(dem{cl},p) >= data.API
                    route{i} = [route{i},d,c(i).cluster{cl}+data.M];
                    p = p - dem{cl}(end:-1:1);
                    ncl = setdiff(ncl,cl);
                    non_cl = setdiff(non_cl,cl);
                    if isempty(ncl)
                        for cc = 1 : size(data.depot{i},1)
                            g2d1{i}{cc}(cl) = inf;
                        end
                        break;
                    else
                        for cc = 1 : size(data.depot{i},1)
                            g2d1{i}{cc}(cl) = inf;
                        end
                        [~,cl] = min(g2d1{i}{d});
                    end
                else
                    ncl = setdiff(ncl,cl);
                    if isempty(ncl)
                        g2d1{i}{d}(cl) = inf;
                        break;
                    else
                        g2d1{i}{d}(cl) = inf;
                        [~,cl] = min(g2d1{i}{d});
                    end 
                end
            end
            w{i}(1) = [];
        end       
    end
end

