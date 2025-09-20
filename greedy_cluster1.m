function pop = greedy_cluster1(data,DPI,API,alpha)
cust = 1:data.N;  %初始化未被安排的客户
k = 1; %聚类下标
while ~isempty(cust)
    x{k} = [];                  %储存路线
    c = cust(randperm(length(cust),1));
    cust_d = cust;              %初始化未被聚类的客户
    dem(k,:) = zeros(1,3);      %总需求
    q = repmat(data.Q,1,3);     %车辆剩余容量
    time = data.tw(c,2);          %第一个客户的抵达时间应该等于梯形时间窗的满意度为1的起点。
    while ~isempty(cust_d)
        if ~isempty(x{k})
            t = time + data.ft{x{k}(end),c};
        else
            t = time;
        end
        if Cr1(q,data.demand(c,:))>=DPI && Cr2(t,data.tw(c,:),alpha) == 1 
            x{k} = [x{k},c];
            cust_d(cust_d == c) = [];
            d = data.demand(c,:);
            q = q - d(end:-1:1);
            dem(k,:) = dem(k,:) + data.demand(c,:);
            time = time + data.ft{x{k}(end),c};
            if ~isempty(cust_d)
                [~,d] = min(data.D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        else
            cust_d(cust_d == c) = [];
            if ~isempty(cust_d)
                [~,d]=min(data.D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        end
    end
    if length(x{k}) == 1
        gra(k,:) = data.customer(x{k},:)/size(x{k},2);
    else
        gra(k,:) = (sum(data.customer(x{k},:)))/size(x{k},2); %计算聚类重心
    end  
    for i = 1 : length(x{k})
        cust(cust == x{k}(i)) = [];
    end
%     cust = setdiff(cust,x{k});
    k = k + 1;
end
g2d = dis(gra,data.depot);%计算聚类重心到仓库的距离
% c2d = sum(D(1:5,:)');
% [~,w] = sort(P./(c2d.*O)); %仓库开放等级排序
dep = 1:data.M;
clu = 1:length(x);
while ~isempty(clu) 
    d = dep(randperm(length(dep),1)); %随机选择一个仓库
    [~,index] = min(g2d(d,clu));
    sc = clu(index(1));
    p = repmat(data.P(d),1,3);
    cl = clu;
    a_c = []; %记录已经被安排的聚类
    while ~isempty(cl)
        if Cr1(p,dem(sc,:)) >= API %dem(sc) <= p 
            x{sc} = [d,x{sc}+data.M];
            cl = setdiff(cl,sc);
            de = dem(sc,:);
            p = p - de(end:-1:1);
            a_c = [a_c,sc];
            if ~isempty(cl)
                [~,index] = min(g2d(d,cl));
                sc = cl(index(1));
            else
                break
            end                
        else
            cl = setdiff(cl,sc);
            if ~isempty(cl)
                [~,index] = min(g2d(d,cl));
                sc = cl(index(1));
            else
                break
            end
        end
    end
    clu = setdiff(clu,a_c);
    dep = setdiff(dep,d);                                                                                     
end
pop = [];
for i = 1:length(x)
    pop = [pop,x{i}];
end
end